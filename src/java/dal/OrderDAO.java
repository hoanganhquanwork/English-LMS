package dal;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.entity.Course;
import model.entity.OrderItem;
import model.entity.Orders;
import model.entity.ParentProfile;
import model.entity.StudentProfile;
import model.entity.Users;

public class OrderDAO extends DBContext {

    public int createOrder(int parentId, BigDecimal totalAmount) {
        String sql = """
            INSERT INTO Orders (parent_id, status, created_at)
            VALUES (?, 'pending', GETDATE())
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, parentId);
            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi tạo Order mới:");
            e.printStackTrace();
        }
        return -1;
    }

    public void updateOrderPaidSuccess(int orderId) {
        String sql = "UPDATE Orders SET status = ?, paid_at = GETDATE(), payment_method = NULL WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "paid");
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Orders getOrderDetail(int orderId) {
        Orders order = null;
        String sql = """
        SELECT o.order_id, o.parent_id, o.status, o.created_at, o.paid_at,
               oi.order_item_id, oi.price_vnd,
               c.course_id, c.title AS course_title,
               s.user_id AS student_id, u.full_name AS student_name
        FROM Orders o
        JOIN OrderItems oi ON o.order_id = oi.order_id
        JOIN Course c ON oi.course_id = c.course_id
        JOIN StudentProfile s ON oi.student_id = s.user_id
        JOIN Users u ON s.user_id = u.user_id
        WHERE o.order_id = ?
        ORDER BY c.title
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            List<OrderItem> items = new ArrayList<>();
            while (rs.next()) {
                if (order == null) {
                    order = new Orders();
                    order.setOrderId(rs.getInt("order_id"));
                    ParentProfile p = new ParentProfile();
                    p.setUserId(rs.getInt("parent_id"));
                    order.setParent(p);
                    order.setStatus(rs.getString("status"));

                    Timestamp created = rs.getTimestamp("created_at");
                    order.setCreatedAt(created != null ? created.toLocalDateTime() : null);

                    Timestamp paid = rs.getTimestamp("paid_at");
                    order.setPaidAt(paid != null ? paid.toLocalDateTime() : null);
                }

                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setPriceVnd(rs.getBigDecimal("price_vnd"));

                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setTitle(rs.getString("course_title"));
                item.setCourse(c);

                StudentProfile s = new StudentProfile();
                Users u = new Users();
                u.setUserId(rs.getInt("student_id"));
                u.setFullName(rs.getString("student_name"));
                s.setUser(u);
                item.setStudent(s);

                items.add(item);
            }

            if (order != null) {
                order.setItems(items);
                order.setTotalAmount(items.stream()
                        .map(OrderItem::getPriceVnd)
                        .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, newStatus);
            stm.setInt(2, orderId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Orders> getOrdersByParentAndStatus(int parentId, String status) {
    List<Orders> list = new ArrayList<>();
    String sql = """
        SELECT o.order_id, o.status, o.payment_method, o.created_at, o.paid_at,
               ISNULL(SUM(oi.price_vnd), 0) AS total_amount
        FROM Orders o
        LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
        WHERE o.parent_id = ? AND o.status = ?
        GROUP BY o.order_id, o.status, o.payment_method, o.created_at, o.paid_at
        ORDER BY o.created_at DESC
    """;

    try (PreparedStatement stm = connection.prepareStatement(sql)) {
        stm.setInt(1, parentId);
        stm.setString(2, status);

        ResultSet rs = stm.executeQuery();
        while (rs.next()) {
            Orders order = new Orders();
            order.setOrderId(rs.getInt("order_id"));
            order.setStatus(rs.getString("status"));
            order.setPaymentMethod(rs.getString("payment_method"));

            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null)
                order.setCreatedAt(createdAt.toLocalDateTime());

            Timestamp paidAt = rs.getTimestamp("paid_at");
            if (paidAt != null)
                order.setPaidAt(paidAt.toLocalDateTime());

            order.setTotalAmount(rs.getBigDecimal("total_amount"));

            list.add(order);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public Users getOrderOwner(int orderId) {
        String sql = """
            SELECT u.user_id, u.full_name, u.email, u.role
            FROM Orders o
            JOIN Users u ON o.parent_id = u.user_id
            WHERE o.order_id = ?
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cleanupExpiredOrders() {
    String sql = """
        UPDATE Orders
        SET status = 'cancelled'
        WHERE status = 'pending'
          AND order_id NOT IN (SELECT order_id FROM OrderItems)
          AND created_at < DATEADD(MINUTE, -30, GETDATE());
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}


}
