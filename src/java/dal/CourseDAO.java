
package dal;

import java.util.List;
import model.Course;

/**
 *
 * @author Admin
 */
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class CourseDAO extends DBContext {

    public List<Course> searchCourse(int categoryIDs[], String[] languages, String[] levels,
            String keyWord, String sortBy, int pageIndex, int pageSize) {
        StringBuilder sql = new StringBuilder(
                "SELECT c.course_id, c.title, c.description, c.thumbnail, "
                + "       c.language, c.level, c.price, c.publish_at, c.created_at, "
                + "       ISNULL(enr.enroll_count,0) AS enroll_count "
                + "FROM Course c "
                + "LEFT JOIN (SELECT e.course_id, COUNT(*) AS enroll_count "
                + "           FROM Enrollments e GROUP BY e.course_id) enr "
                + "  ON enr.course_id = c.course_id "
                + "WHERE c.status = 'approved' AND c.publish_at IS NOT NULL "
        );

        List<Object> params = new ArrayList();
        if (keyWord != null && !keyWord.trim().isEmpty()) {
            sql.append(" AND (c.title LIKE ? OR c.description LIKE ?)");
            String kw = "%" + keyWord.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        appendIn(sql, params, "c.category_id", categoryIDs);
        appendIn(sql, params, "c.language", languages);
        appendIn(sql, params, "c.level", levels);

        if (sortBy == null) {
            sortBy = "popular";
        }
        switch (sortBy) {
            case "price":
                sql.append(" ORDER BY c.price ASC");
                break;
            case "popular":
                sql.append(" ORDER BY ISNULL(enr.enroll_count,0) DESC, ISNULL(c.publish_at, c.created_at) DESC");
                break;
            case "newest":
                sql.append(" ORDER BY c.publish_at DESC");
                break;
            default:
                sql.append(" ORDER BY c.course_id ASC");
                break;
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Course> listCourse = new ArrayList<>();
        try {
            int i = 1;
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (Object p : params) {
                st.setObject(i++, p);
            }
            st.setInt(i++, (pageIndex - 1) * pageSize);
            st.setInt(i++, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                listCourse.add(mapCourse(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listCourse;
    }

    public int countCourse(
            int[] categoryIDs, String[] languages, String[] levels,
            String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Course c WHERE c.status='approved' AND c.publish_at IS NOT NULL ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.title LIKE ? OR c.description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        appendIn(sql, params, "c.category_id", categoryIDs);
        appendIn(sql, params, "c.language", languages);
        appendIn(sql, params, "c.level", levels);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int i = 1;
            for (Object p : params) {
                st.setObject(i++, p);
            }
            ResultSet rs = st.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Category> getAllCategories() {
        String sql = "SELECT category_id, name, picture FROM Categories ORDER BY name";
        List<Category> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setPicture(rs.getString("picture"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllLanguages() {
        String sql = "SELECT DISTINCT language FROM Course WHERE language IS NOT NULL ORDER BY language";
        List<String> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllLevels() {
        String sql = "SELECT DISTINCT level FROM Course WHERE level IS NOT NULL ORDER BY level";
        List<String> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<Integer, Integer> getEnrollCounts(Collection<Integer> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return Collections.emptyMap();
        }
        String in = makePlaceholders(courseIds.size());
        String sql = "SELECT course_id, COUNT(*) AS cnt FROM Enrollments "
                + "WHERE course_id IN (" + in + ") GROUP BY course_id";
        Map<Integer, Integer> m = new HashMap<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int i = 1;
            for (Integer id : courseIds) {
                st.setInt(i++, id);
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                m.put(rs.getInt(1), rs.getInt(2));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return m;
    }

    private static Course mapCourse(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setCourseId(rs.getInt("course_id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setThumbnail(rs.getString("thumbnail"));
        c.setLanguage(rs.getString("language"));
        c.setLevel(rs.getString("level"));
        c.setPrice(rs.getBigDecimal("price"));

        Timestamp p = rs.getTimestamp("publish_at");
        c.setPublishAt(p != null ? p.toLocalDateTime() : null);

        Timestamp cr = rs.getTimestamp("created_at");
        c.setCreatedAt(cr != null ? cr.toLocalDateTime() : null);

        return c;
    }

    private static String makePlaceholders(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            if (i > 0) {
                sb.append(',');
            }
            sb.append('?');
        }
        return sb.toString();
    }

    private static void appendIn(StringBuilder sql, List<Object> params, String col, int[] ids) {
        if (ids == null || ids.length == 0) {
            return;
        }
        sql.append(" AND ").append(col).append(" IN (").append(makePlaceholders(ids.length)).append(")");
        for (int id : ids) {
            params.add(id);
        }
    }

    private static void appendIn(StringBuilder sql, List<Object> params, String col, String[] vals) {
        if (vals == null || vals.length == 0) {
            return;
        }
        sql.append(" AND ").append(col).append(" IN (").append(makePlaceholders(vals.length)).append(")");
        Collections.addAll(params, vals);
    }

    public List<Course> getTopPopularCourse() {
        String sql = "SELECT TOP 4 c.course_id, c.title, c.description, c.thumbnail, c.language, c.level, c.price, c.publish_at,  c.created_at, \n"
                + "    ISNULL(enr.enroll_count, 0) AS enroll_count\n"
                + "FROM Course c\n"
                + "LEFT JOIN (\n"
                + "    SELECT e.course_id, COUNT(*) AS enroll_count\n"
                + "    FROM Enrollments e\n"
                + "    GROUP BY e.course_id\n"
                + ") enr ON enr.course_id = c.course_id\n"
                + "WHERE c.status = 'approved'\n"
                + "  AND c.publish_at IS NOT NULL\n"
                + "ORDER BY ISNULL(enr.enroll_count, 0) DESC, c.publish_at DESC;";

        List<Course> listCourse = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                listCourse.add(mapCourse(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listCourse;
    }

    public List<Course> getTopNewestCourses() {
        String sql = "SELECT TOP 4 c.course_id, c.title, c.description, c.thumbnail, \n"
                + "c.language, c.level, c.price, c.publish_at, c.created_at\n"
                + "FROM Course c\n"
                + "WHERE c.status = 'approved'\n"
                + "ORDER BY c.publish_at DESC";
        List<Course> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    private CategoryDAO cdao = new CategoryDAO();

    public int countLessonsByCourse(int courseId) {
        String sql = "SELECT COUNT(*) FROM Lessons WHERE course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số học viên đang active trong 1 khóa
    public int countStudentsByCourse(int courseId) {
        String sql = "SELECT COUNT(DISTINCT student_id) FROM Enrollments WHERE course_id = ? AND status='active'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Course> searchAndFilterCourses(int instructorId, String keyword, String status) {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Course WHERE created_by = ? ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND title LIKE ? ");
        }
        if (status != null && !status.equalsIgnoreCase("all")) {
            sql.append("AND status = ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, instructorId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.equalsIgnoreCase("all")) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractCourse(rs)); // hàm convert ResultSet → Course
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Course getCourseById(int id) {
        String sql = "SELECT * FROM Course WHERE course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return extractCourse(rs);

            }
        } catch (SQLException e) {
            System.out.println("getCourseById error: " + e.getMessage());
        }
        return null;
    }

    private Course extractCourse(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setCourseId(rs.getInt("course_id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setLanguage(rs.getString("language"));
        c.setLevel(rs.getString("level"));
        c.setThumbnail(rs.getString("thumbnail"));
        c.setStatus(rs.getString("status"));
        c.setPrice(rs.getBigDecimal("price"));
        c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        c.setCategory(cdao.getCategoryById(rs.getInt("category_id")));

        return c;
    }
    public  boolean  addCourse(Course course) {
        String sql = "INSERT INTO Course (title, description, language, level, created_by, category_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setString(3, course.getLanguage());
            ps.setString(4, course.getLevel());
            ps.setInt(5, course.getCreatedBy().getUserId());
            ps.setInt(6, course.getCategory().getCategoryId());
           return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCourse(Course course) {
        String sql = "UPDATE Course SET title = ?, description = ?, language = ?, "
                + "level = ?, thumbnail = ?, category_id = ? "
                + "WHERE course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, course.getTitle());
            st.setString(2, course.getDescription());
            st.setString(3, course.getLanguage());
            st.setString(4, course.getLevel());
            st.setString(5, course.getThumbnail());
            st.setInt(6, course.getCategory().getCategoryId());
            st.setInt(7, course.getCourseId());

            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updateCourse: " + e.getMessage());
        }
        return false;
    }
        
    
     public boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM Course WHERE course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
