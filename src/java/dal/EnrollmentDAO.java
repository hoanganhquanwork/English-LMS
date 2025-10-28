/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Enrollment;
import model.entity.StudentProfile;
import model.entity.Users;

/**
 *
 * @author Lenovo
 */
public class EnrollmentDAO extends DBContext {

    public List<Enrollment> searchAndFilterEnrollments(int courseId, String keyword, String status) {
        List<Enrollment> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT e.enrollment_id, e.status, e.enrolled_at, "
                + "u.user_id, u.username, u.full_name, u.email, u.status AS user_status "
                + "FROM Enrollments e "
                + "JOIN Users u ON e.student_id = u.user_id "
                + "WHERE e.course_id = ? "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.email LIKE ?) ");
        }
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            sql.append("AND e.status = ? ");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setInt(idx++, courseId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(idx++, "%" + keyword + "%");
                st.setString(idx++, "%" + keyword + "%");
            }
            if (status != null && !status.equals("all") && !status.isEmpty()) {
                st.setString(idx++, status);
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // Users
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getString("user_status"));

                // Enrollment
                Enrollment e = new Enrollment();
                e.setEnrollmentId(rs.getInt("enrollment_id"));
                e.setStatus(rs.getString("status"));
                e.setEnrolledAt(rs.getDate("enrolled_at"));
                e.setUser(user);

                list.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertEnrollmentAfterPayment(int courseId, int studentId) {
        String sql = "INSERT INTO Enrollments (course_id, student_id, enrolled_at, status) "
                + "VALUES (?, ?, GETDATE(), 'active')";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            st.setInt(2, studentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isStudentEnrolledInCourse(int studentId, int courseId) {
        String sql = "SELECT 1 FROM Enrollments WHERE student_id=? "
                + "AND course_id=? AND status IN ('active','completed')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCompletedStatus(int courseId, int studentId) {
        String sql = "UPDATE Enrollments SET status='completed', completed_at= GETDATE() "
                + " WHERE course_id=? AND student_id=? AND status<>'completed'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            st.setInt(2, studentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
