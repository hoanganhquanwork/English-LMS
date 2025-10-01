/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.*;
import java.sql.*;

/**
 *
 * @author Admin
 */
public class StudentDAO extends DBContext {

    public StudentProfile findStudentById(int userId) {
        String sql = "SELECT user_id, grade_level, institution, parent_id, address\n"
                + "            FROM StudentProfile\n"
                + "            WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                StudentProfile sp = new StudentProfile();
                sp.setUserId(rs.getInt("user_id"));
                sp.setGradeLevel(rs.getString("grade_level"));
                sp.setInstitution(rs.getString("institution"));
                int pid = rs.getInt("parent_id");
                sp.setParentId(rs.wasNull() ? null : pid);
                sp.setAddress(rs.getString("address"));
                return sp;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int updateStudentProfile(StudentProfile sp) {
        String sql = "UPDATE StudentProfile\n"
                + "            SET grade_level = ?, institution = ?, address = ?\n"
                + "            WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, sp.getGradeLevel());
            st.setString(2, sp.getInstitution());
            st.setString(3, sp.getAddress());
            st.setInt(4, sp.getUserId());
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
