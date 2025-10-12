package dal;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.entity.Course;
import model.entity.OrderItem;
import model.entity.StudentProfile;
import model.entity.Users;

public class OrderItemDAO extends DBContext {

    public boolean createFromCourseRequest(int requestId, int courseId, int studentId, double priceVnd) {
        String sql = """
            INSERT INTO OrderItems (order_id, request_id, course_id, student_id, price_vnd)
            VALUES (NULL, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, courseId);
            ps.setInt(3, studentId);
            ps.setDouble(4, priceVnd);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // 🔹 Lấy tất cả OrderItem chưa có order_id (chờ thanh toán)

    public List<OrderItem> getPendingItemsByParent(int parentId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = """
            SELECT 
                oi.order_item_id, oi.price_vnd, 
                c.course_id, c.title AS course_title, 
                s.user_id AS student_id, u.full_name AS student_name
            FROM OrderItems oi
            JOIN Course c ON oi.course_id = c.course_id
            JOIN StudentProfile s ON oi.student_id = s.user_id
            JOIN Users u ON s.user_id = u.user_id
            JOIN CourseRequests r ON oi.request_id = r.request_id
            WHERE r.parent_id = ? AND oi.order_id IS NULL
            ORDER BY r.decided_at DESC
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
                s.setUserId(rs.getInt("student_id"));
                item.setStudent(s);

                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean assignItemsToOrder(List<Integer> itemIds, int orderId) {
        if (itemIds == null || itemIds.isEmpty()) {
            return false;
        }
        String placeholders = itemIds.stream()
                .map(id -> "?")
                .collect(Collectors.joining(","));
        String sql = "UPDATE OrderItems SET order_id = ? WHERE order_item_id IN (" + placeholders + ")";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            // Set orderId cho tham số đầu tiên
            ps.setInt(1, orderId);

            // Set các itemIds cho các tham số tiếp theo (bắt đầu từ index 2)
            for (int i = 0; i < itemIds.size(); i++) {
                ps.setInt(i + 2, itemIds.get(i));
            }

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 🔹 Tính tổng tiền các mục được chọn
    public BigDecimal calculateTotalByIds(List<Integer> itemIds) {
        if (itemIds == null || itemIds.isEmpty()) {
            return BigDecimal.ZERO;
        }
        String inClause = itemIds.toString().replace("[", "(").replace("]", ")");
        String sql = "SELECT SUM(price_vnd) AS total FROM OrderItems WHERE order_item_id IN " + inClause;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public void clearOrderItems(int orderId) {
        String sql = "UPDATE OrderItems SET order_id = NULL WHERE order_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
