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

    public void clearOrderItems(int orderId) {
        String sql = "UPDATE OrderItems SET order_id = NULL WHERE order_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
    List<OrderItem> list = new ArrayList<>();
    String sql = "SELECT oi.order_item_id, oi.price_vnd, " +
                 "c.course_id, c.title, " +
                 "s.user_id AS student_id, u.full_name AS student_name " +
                 "FROM OrderItems oi " +
                 "JOIN Course c ON oi.course_id = c.course_id " +
                 "JOIN StudentProfile s ON oi.student_id = s.user_id " +
                 "JOIN Users u ON s.user_id = u.user_id " +
                 "WHERE oi.order_id = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, orderId);
        ResultSet rs = st.executeQuery();

        while (rs.next()) {
            OrderItem item = new OrderItem();
            item.setOrderItemId(rs.getInt("order_item_id"));
            item.setPriceVnd(rs.getBigDecimal("price_vnd"));

            // --- Course ---
            Course c = new Course();
            c.setCourseId(rs.getInt("course_id"));
            c.setTitle(rs.getString("title"));
            item.setCourse(c);

            // --- Student ---
            StudentProfile s = new StudentProfile();
            s.setUserId(rs.getInt("student_id"));  
            Users user = new Users();
            user.setFullName(rs.getString("student_name"));
            s.setUser(user);
            item.setStudent(s);

            list.add(item);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public void createForOrder(int orderId, int requestId, int courseId, int studentId, double price) {
        final String sql = """
            INSERT INTO OrderItems (order_id, request_id, course_id, student_id, price_vnd)
            VALUES (?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, requestId);
            ps.setInt(3, courseId);
            ps.setInt(4, studentId);
            ps.setBigDecimal(5, BigDecimal.valueOf(price));
            ps.executeUpdate();
        } catch (SQLException e) {
            // Có thể dính UNIQUE (order_id, course_id, student_id) nếu gọi trùng
            e.printStackTrace();
            throw new RuntimeException("Tạo OrderItem thất bại", e);
        }
    }

}
