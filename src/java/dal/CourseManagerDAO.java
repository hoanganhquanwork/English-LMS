package dal;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.entity.Course;
import model.entity.Category;
import model.entity.InstructorProfile;
import model.entity.Users;

public class CourseManagerDAO extends DBContext {

    public List<Course> getFilteredCourses(String status, String keyword, String sort) {
        List<Course> list = new ArrayList<>();

        String sql
                = "SELECT c.course_id, c.title, c.description, c.language, c.level, "
                + "       c.thumbnail, c.status, c.price, c.created_at, c.publish_at, "
                + "       ip.user_id AS instructor_id, ip.bio, ip.expertise, ip.qualifications, "
                + "       u.user_id, u.full_name, u.email, u.profile_picture, "
                + "       cat.category_id, cat.name AS category_name, cat.description AS category_description "
                + "FROM Course c "
                + "JOIN InstructorProfile ip ON c.created_by = ip.user_id "
                + "JOIN Users u ON ip.user_id = u.user_id "
                + "JOIN Categories cat ON c.category_id = cat.category_id "
                + "WHERE 1 = 1 ";

        if (status == null || "all".equalsIgnoreCase(status)) {
            sql += "AND c.status IN ('submitted', 'approved', 'rejected') ";
        } else {
            sql += "AND c.status = ? ";
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND (c.title LIKE ? OR u.full_name LIKE ?) ";
        }

        sql += "ORDER BY c.created_at " + ("oldest".equalsIgnoreCase(sort) ? "ASC " : "DESC ");

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            if (status != null && !"all".equalsIgnoreCase(status)) {
                ps.setString(idx++, status);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCourseFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Course> getFilteredCoursesForPublish(String status, String keyword, String sort) {
        List<Course> list = new ArrayList<>();

        String sql
                = "SELECT c.course_id, c.title, c.description, c.language, c.level, "
                + "       c.thumbnail, c.status, c.price, c.created_at, c.publish_at, "
                + "       ip.user_id AS instructor_id, ip.bio, ip.expertise, ip.qualifications, "
                + "       u.user_id, u.full_name, u.email, u.profile_picture, "
                + "       cat.category_id, cat.name AS category_name, cat.description AS category_description "
                + "FROM Course c "
                + "JOIN InstructorProfile ip ON c.created_by = ip.user_id "
                + "JOIN Users u ON ip.user_id = u.user_id "
                + "JOIN Categories cat ON c.category_id = cat.category_id "
                + "WHERE 1 = 1 ";

        if (status == null || "all".equalsIgnoreCase(status)) {
            sql += "AND c.status IN ('approved', 'publish', 'unpublish') ";
        } else {
            sql += "AND c.status = ? ";
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND (c.title LIKE ? OR u.full_name LIKE ?) ";
        }

        sql += "ORDER BY c.created_at " + ("oldest".equalsIgnoreCase(sort) ? "ASC " : "DESC ");

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            if (status != null && !"all".equalsIgnoreCase(status)) {
                ps.setString(idx++, status);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCourseFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Course getCourseById(int id) {
        String sql
                = "SELECT c.course_id, c.title, c.description, c.language, c.level, "
                + "       c.thumbnail, c.status, c.price, c.created_at, c.publish_at, "
                + "       ip.user_id AS instructor_id, ip.bio, ip.expertise, ip.qualifications, "
                + "       u.user_id, u.full_name, u.email, u.profile_picture, "
                + "       cat.category_id, cat.name AS category_name, cat.description AS category_description "
                + "FROM Course c "
                + "LEFT JOIN InstructorProfile ip ON c.created_by = ip.user_id "
                + "LEFT JOIN Users u ON ip.user_id = u.user_id "
                + "LEFT JOIN Categories cat ON c.category_id = cat.category_id "
                + "WHERE c.course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Course course = mapCourseFromResultSet(rs);
                    return course;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCourseStatus(int id, String newStatus) {
        String sql
                = "UPDATE Course "
                + "SET status = ?, "
                + "    publish_at = CASE WHEN ? = 'publish' THEN GETDATE() ELSE publish_at END "
                + "WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newStatus);
            ps.setInt(3, id);
            int rows = ps.executeUpdate();
            System.out.println("Updated course_id=" + id + " → " + newStatus + " (" + rows + " rows)");
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCoursePrice(int id, BigDecimal price) {
        String sql
                = "UPDATE Course "
                + "SET price = ? "
                + "WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBigDecimal(1, price);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Course mapCourseFromResultSet(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setCourseId(rs.getInt("course_id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setLanguage(rs.getString("language"));
        c.setLevel(rs.getString("level"));
        c.setThumbnail(rs.getString("thumbnail"));
        c.setStatus(rs.getString("status"));
        c.setPrice(rs.getBigDecimal("price"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            c.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp publishAt = rs.getTimestamp("publish_at");
        if (publishAt != null) {
            c.setPublishAt(publishAt.toLocalDateTime());
        }

        Users u = new Users();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setProfilePicture(rs.getString("profile_picture"));

        InstructorProfile ip = new InstructorProfile();
        ip.setUser(u);
        ip.setBio(rs.getString("bio"));
        ip.setExpertise(rs.getString("expertise"));
        ip.setQualifications(rs.getString("qualifications"));
        c.setCreatedBy(ip);

        Category cat = new Category();
        cat.setCategoryId(rs.getInt("category_id"));
        cat.setName(rs.getString("category_name"));
        cat.setDescription(rs.getString("category_description"));
        c.setCategory(cat);

        return c;
    }

    public boolean schedulePublish(int courseId, Timestamp publishDate) {
        String sql
                = "UPDATE Course "
                + "SET publish_at = ?, status = 'publish' "
                + "WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, publishDate);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean publishNow(int courseId) {
        String sql
                = "UPDATE Course "
                + "SET status = 'publish', publish_at = GETDATE() "
                + "WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean unpublishCourse(int courseId) {
        String sql
                = "UPDATE Course "
                + "SET status = 'unpublish' "
                + "WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean republishCourse(int courseId) {
        String sql
                = "UPDATE Course "
                + "SET status = 'publish', publish_at = GETDATE() "
                + "WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void autoPublishIfDue() {
        String sql = """
        UPDATE Course
        SET status = 'publish'
        WHERE status = 'approved'
          AND publish_at IS NOT NULL
          AND publish_at <= GETDATE()
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean rejectCourseWithReason(int courseId, int managerId, String reason) {
        String sqlCourse = "UPDATE Course SET status = 'rejected' "
                + "WHERE course_id = ? AND status IN ('submitted', 'approved')";

        String sqlUpdateManager = "UPDATE CourseManagers "
                + "SET reject_reason = ? "
                + "WHERE course_id = ? AND user_id = ?";

        String sqlInsertManager = "INSERT INTO CourseManagers (course_id, user_id, is_primary, can_approve, can_view_reports, reject_reason) "
                + "SELECT ?, ?, 1, 1, 1, ? "
                + "WHERE NOT EXISTS (SELECT 1 FROM CourseManagers WHERE course_id = ? AND user_id = ?)";

        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;

        try {
            connection.setAutoCommit(false);

            ps1 = connection.prepareStatement(sqlCourse);
            ps1.setInt(1, courseId);
            int updatedRows = ps1.executeUpdate();

            if (updatedRows == 0) {
                connection.rollback();
                return false;
            }

            ps2 = connection.prepareStatement(sqlUpdateManager);
            ps2.setString(1, reason);
            ps2.setInt(2, courseId);
            ps2.setInt(3, managerId);
            ps2.executeUpdate();

            ps3 = connection.prepareStatement(sqlInsertManager);
            ps3.setInt(1, courseId);
            ps3.setInt(2, managerId);
            ps3.setString(3, reason);
            ps3.setInt(4, courseId);
            ps3.setInt(5, managerId);
            ps3.executeUpdate();

            connection.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
            return false;
        } finally {
            try {
                if (ps1 != null) {
                    ps1.close();
                }
                if (ps2 != null) {
                    ps2.close();
                }
                if (ps3 != null) {
                    ps3.close();
                }
                connection.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }
}
