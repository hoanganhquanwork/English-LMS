package dal;

import java.sql.*;
import java.util.*;
import model.entity.Course;
import model.entity.Users;

public class ParentProgressDAO extends DBContext {

    // Lấy danh sách con
    public List<Users> getChildrenByParent(int parentId) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name, u.email FROM StudentProfile s "
                + "JOIN Users u ON s.user_id = u.user_id WHERE s.parent_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách khóa học mà con đang học hoặc đã hoàn thành
    public List<Course> getCourseProgress(int studentId) {
        List<Course> list = new ArrayList<>();
        String sqlCourses = """
            SELECT 
                e.course_id,
                c.title,
                MAX(p.updated_at) AS last_progress_update
            FROM Enrollments e
            JOIN Course c 
                ON c.course_id = e.course_id
            LEFT JOIN Progress p 
                ON p.student_id = e.student_id
               AND p.module_item_id IN (
                    SELECT mi.module_item_id 
                    FROM Module m
                    JOIN ModuleItem mi ON mi.module_id = m.module_id
                    WHERE m.course_id = e.course_id
                )
            WHERE e.student_id = ?
            GROUP BY e.course_id, c.title
            ORDER BY last_progress_update DESC;
        """;

        try (PreparedStatement ps = connection.prepareStatement(sqlCourses)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int courseId = rs.getInt("course_id");
                String title = rs.getString("title");
                Course c = new Course();
                c.setCourseId(courseId);
                c.setTitle(title);
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countModuleItems(int courseId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM ModuleItem mi
            JOIN Module m ON mi.module_id = m.module_id
            WHERE m.course_id = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public int countRequiredItems(int courseId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM ModuleItem mi
            JOIN Module m ON mi.module_id = m.module_id
            WHERE m.course_id = ? AND mi.is_required = 1
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public int countCompletedItems(int studentId, int courseId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Progress p
            JOIN ModuleItem mi ON p.module_item_id = mi.module_item_id
            JOIN Module m ON mi.module_id = m.module_id
            WHERE p.student_id = ? AND m.course_id = ? AND p.status = 'completed'
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public int countRequiredCompleted(int studentId, int courseId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Progress p
            JOIN ModuleItem mi ON p.module_item_id = mi.module_item_id
            JOIN Module m ON mi.module_id = m.module_id
            WHERE p.student_id = ? AND m.course_id = ?
              AND p.status = 'completed' AND mi.is_required = 1
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    public Double calculateAverageScore(int studentId, int courseId) throws SQLException {
        String sql = """
            SELECT AVG(p.score_pct) as avg_score
            FROM Progress p
            JOIN ModuleItem mi ON p.module_item_id = mi.module_item_id
            JOIN Module m ON mi.module_id = m.module_id
            WHERE p.student_id = ? AND m.course_id = ? AND mi.is_required = 1
            AND p.status = 'completed' AND p.score_pct IS NOT NULL
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Double avgScore = rs.getDouble("avg_score");
                return rs.wasNull() ? null : avgScore;
            }
        }
        return null;
    }

}
