/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.entity.CourseManagers;
import model.entity.Course;
import model.entity.Category;
import model.entity.InstructorProfile;
import model.entity.Users;

public class CourseManagerDAO extends DBContext {

    private UserDAO userDAO = new UserDAO();

    public CourseManagerDAO() {
        super();
    }

  public List<Course> getAllCourses() {
    List<Course> list = new ArrayList<>();

    String sql = "SELECT c.course_id, c.title, c.description, c.language, c.level, "
            + "c.thumbnail, c.status, c.price, c.created_at, c.publish_at, "
            + "ip.user_id AS instructor_id, ip.bio, ip.expertise, ip.qualifications, "
            + "u.user_id AS u_id, u.full_name, u.email, u.profile_picture, "
            + "cat.category_id, cat.name AS category_name, cat.description AS category_description "
            + "FROM Course c "
            + "JOIN InstructorProfile ip ON c.created_by = ip.user_id "
            + "JOIN Users u ON ip.user_id = u.user_id "
            + "JOIN Categories cat ON c.category_id = cat.category_id "
            + "ORDER BY c.created_at DESC";

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Course course = new Course();
            course.setCourseId(rs.getInt("course_id"));
            course.setTitle(rs.getString("title"));
            course.setDescription(rs.getString("description"));
            course.setLanguage(rs.getString("language"));
            course.setLevel(rs.getString("level"));
            course.setThumbnail(rs.getString("thumbnail"));
            course.setStatus(rs.getString("status"));
            course.setPrice(rs.getBigDecimal("price"));

            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                course.setCreatedAt(createdAt.toLocalDateTime());
            }

            Timestamp publishAt = rs.getTimestamp("publish_at");
            if (publishAt != null) {
                course.setPublishAt(publishAt.toLocalDateTime());
            }

            Users u = new Users();
            u.setUserId(rs.getInt("u_id"));
            u.setFullName(rs.getString("full_name"));
            u.setEmail(rs.getString("email"));
            u.setProfilePicture(rs.getString("profile_picture"));

            // InstructorProfile
            InstructorProfile ip = new InstructorProfile();
            ip.setUser(u);
            ip.setBio(rs.getString("bio"));
            ip.setExpertise(rs.getString("expertise"));
            ip.setQualifications(rs.getString("qualifications"));

            course.setCreatedBy(ip);

            Category cat = new Category();
            cat.setCategoryId(rs.getInt("category_id"));
            cat.setName(rs.getString("category_name"));
            cat.setDescription(rs.getString("category_description"));

            course.setCategory(cat);

            list.add(course);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public boolean updateCourseStatus(int courseId, String status) {
        String sql;
        if ("approved".equals(status)) {
            sql = "UPDATE Course SET status = ?, publish_at = GETDATE() WHERE course_id = ?";
        } else {
            sql = "UPDATE Course SET status = ? WHERE course_id = ?";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

 public List<Course> getFilteredCourses(String status, String keyword, String sort) {
    List<Course> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
            "SELECT c.course_id, c.title, c.description, c.language, c.level, "
            + "c.thumbnail, c.status, c.price, c.created_at, c.publish_at, "
            + "ip.user_id AS instructor_id, ip.bio, ip.expertise, ip.qualifications, "
            + "u.user_id, u.full_name, u.email, u.profile_picture, "
            + "cat.category_id, cat.name AS category_name, cat.description AS category_description "
            + "FROM Course c "
            + "JOIN InstructorProfile ip ON c.created_by = ip.user_id "
            + "JOIN Users u ON ip.user_id = u.user_id "
            + "JOIN Categories cat ON c.category_id = cat.category_id "
            + "WHERE 1=1 "
    );

    if (status != null && !"all".equalsIgnoreCase(status)) {
        sql.append(" AND c.status = ? ");
    }
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND (c.title LIKE ? OR u.full_name LIKE ?) ");
    }
    if ("oldest".equalsIgnoreCase(sort)) {
        sql.append(" ORDER BY c.created_at ASC ");
    } else {
        sql.append(" ORDER BY c.created_at DESC ");
    }

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
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
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setTitle(rs.getString("title"));
                course.setDescription(rs.getString("description"));
                course.setLanguage(rs.getString("language"));
                course.setLevel(rs.getString("level"));
                course.setThumbnail(rs.getString("thumbnail"));
                course.setStatus(rs.getString("status"));
                course.setPrice(rs.getBigDecimal("price"));

                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    course.setCreatedAt(createdAt.toLocalDateTime());
                }
                Timestamp publishAt = rs.getTimestamp("publish_at");
                if (publishAt != null) {
                    course.setPublishAt(publishAt.toLocalDateTime());
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

                course.setCreatedBy(ip);

                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setName(rs.getString("category_name"));
                cat.setDescription(rs.getString("category_description"));
                course.setCategory(cat);

                list.add(course);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

   public Course getCourseById(int courseId) {
    String sql = "SELECT c.course_id, c.title, c.description, c.language, c.level, "
            + "c.thumbnail, c.status, c.price, c.created_at, c.publish_at, "
            + "u.user_id, u.full_name, u.email, u.profile_picture, "
            + "ip.user_id AS instructor_id, ip.bio, ip.expertise, ip.qualifications, "
            + "cat.category_id, cat.name AS category_name, cat.description AS category_description "
            + "FROM Course c "
            + "JOIN InstructorProfile ip ON c.created_by = ip.user_id "
            + "JOIN Users u ON ip.user_id = u.user_id "
            + "JOIN Categories cat ON c.category_id = cat.category_id "
            + "WHERE c.course_id = ?";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, courseId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setTitle(rs.getString("title"));
                course.setDescription(rs.getString("description"));
                course.setLanguage(rs.getString("language"));
                course.setLevel(rs.getString("level"));
                course.setThumbnail(rs.getString("thumbnail"));
                course.setStatus(rs.getString("status"));
                course.setPrice(rs.getBigDecimal("price"));

                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    course.setCreatedAt(createdAt.toLocalDateTime());
                }
                Timestamp publishAt = rs.getTimestamp("publish_at");
                if (publishAt != null) {
                    course.setPublishAt(publishAt.toLocalDateTime());
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
                course.setCreatedBy(ip);
                
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setName(rs.getString("category_name"));
                cat.setDescription(rs.getString("category_description"));

                course.setCategory(cat);

                return course;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
    public boolean updateCoursePrice(int courseId, BigDecimal price) {
        String sql = "UPDATE Course SET price = ? Where course_id =?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBigDecimal(1, price);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
