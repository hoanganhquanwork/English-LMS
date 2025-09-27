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
import model.Users;

/**
 *
 * @author Lenovo
 */
public class EnrollmentDAO extends DBContext {

    public List<Users> getStudentsByCourse(int courseId) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name, u.email "
                + "FROM Enrollments e "
                + "JOIN Users u ON e.student_id = u.user_id "
                + "WHERE e.course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Users s = new Users();
                s.setUserId(rs.getInt("user_id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        EnrollmentDAO dao = new EnrollmentDAO();
        List<Users> list = dao.getStudentsByCourse(1);
        for (Users u : list) {
            System.out.println(u.toString());
        }
    }
}
