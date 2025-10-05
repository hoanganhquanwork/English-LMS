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

    public boolean createLinkRequest(int studentId, int parentId) {
        String sql = "INSERT INTO ParentLinkRequests(student_id, parent_id, status, created_at, decided_at) "
                + "            VALUES (?, ?, 'pending', GETDATE(), GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, parentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean unlinkParentRequest(int studentId, int parentId) {
        String firstSql = "UPDATE StudentProfile SET parent_id=NULL WHERE user_id=? AND parent_id=?";
        String secondSql = "INSERT INTO ParentLinkRequests(student_id, parent_id, status, created_at, decided_at) "
                + " VALUES (?, ?, 'unlink', GETDATE(), GETDATE())";
        try {
            PreparedStatement st1 = connection.prepareStatement(firstSql);
            st1.setInt(1, studentId);
            st1.setInt(2, parentId);
            if (st1.executeUpdate() == 0) {
                return false;
            }
            PreparedStatement st2 = connection.prepareStatement(secondSql);
            st2.setInt(1, studentId);
            st2.setInt(2, parentId);
            if (st2.executeUpdate() == 0) {
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    public boolean cancelPendingRequest(int studentId) {
        String sql = "UPDATE ParentLinkRequests "
                + "SET status='canceled', decided_at=GETDATE() "
                + "WHERE student_id=? AND status='pending'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getLatestStatus(int studentId) {
        String sql = "SELECT TOP 1 status FROM ParentLinkRequests WHERE student_id = ? "
                + "ORDER BY COALESCE(decided_at, created_at) DESC, request_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            return rs.next() ? rs.getString("status") : null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getLatestParentEmail(int studentId) {
        String sql = "SELECT TOP 1 u.email\n"
                + "        FROM ParentLinkRequests r\n"
                + "        JOIN Users u ON u.user_id = r.parent_id\n"
                + "        WHERE r.student_id = ?\n"
                + "        ORDER BY COALESCE(r.decided_at, r.created_at) DESC, r.request_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            return rs.next() ? rs.getString("email") : null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
