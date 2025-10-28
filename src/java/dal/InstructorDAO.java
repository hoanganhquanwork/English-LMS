/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Lenovo
 */
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InstructorDAO extends DBContext{
    public int countCoursesByInstructor(int instructorId) {
        String sql = "SELECT COUNT(*) FROM Course WHERE created_by = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countStudentsByInstructor(int instructorId) {
        String sql = "SELECT COUNT(DISTINCT e.student_id) " +
                     "FROM Enrollments e " +
                     "JOIN Course c ON e.course_id = c.course_id " +
                     "WHERE c.created_by = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static void main(String[] args) {
        InstructorDAO dao = new InstructorDAO();
        System.out.println(dao.countCoursesByInstructor(3));
        System.out.println(dao.countStudentsByInstructor(3));
    }
}
