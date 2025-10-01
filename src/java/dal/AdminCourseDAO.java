package dal;

import java.sql.*;

public class AdminCourseDAO extends DBContext {
    public int countActiveCourses() {
        String sql = "SELECT COUNT(*) FROM courses WHERE status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
