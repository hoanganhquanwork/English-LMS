/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.Category;
import model.Course;

/**
 *
 * @author Lenovo
 */
public class CourseDAO extends DBContext {

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

//    public void addCourse(Course course) {
//        String sql = "INSERT INTO Course (title, description, language, level, thumbnail, price, created_by, category_id) "
//                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setString(1, course.getTitle());
//            ps.setString(2, course.getDescription());
//            ps.setString(3, course.getLanguage());
//            ps.setString(4, course.getLevel());
//            ps.setString(5, course.getThumbnail());
//            ps.setBigDecimal(6, course.getPrice());
//            ps.setInt(7, course.getCreatedBy().getUserId());
//            ps.setInt(8, course.getCategory().getCategoryId());
//            ps.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
    public  boolean  addCourse(Course course) {
        String sql = "INSERT INTO Course (title, description, language, level, thumbnail, created_by, category_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setString(3, course.getLanguage());
            ps.setString(4, course.getLevel());
            ps.setString(5, course.getThumbnail());
            ps.setInt(6, 3);
            ps.setInt(7, course.getCategory().getCategoryId());
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
     
    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        System.out.println(dao.getCourseById(1));
    }
}
