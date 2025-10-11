/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;

/**
 *
 * @author Admin
 */
public class ProgressDAO extends DBContext {

    public void createFirstProgress(int studentId, int moduleItemId) {
        String sql = "INSERT INTO Progress (student_id, module_item_id, status, percent_done, started_at, updated_at) "
                + " SELECT ?, ?, 'in_progress', 0.00, GETDATE(), GETDATE() "
                + " WHERE NOT EXISTS (SELECT 1 FROM Progress WHERE student_id = ? AND module_item_id = ? )";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, moduleItemId);
            st.setInt(3, studentId);
            st.setInt(4, moduleItemId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateReadingCompletedProgress(int studentId, int moduleItemId) {
        String sql = "UPDATE Progress SET status = ?, percent_done = 100,"
                + " completed_at = GETDATE() WHERE student_id = ? AND module_item_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "completed");
            st.setInt(2, studentId);
            st.setInt(3, moduleItemId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateDiscussionCompletedProgress(int studentId, int moduleItemId) {
        String sql = "UPDATE Progress SET status = ? WHERE student_id = ? AND module_item_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "completed");
            st.setInt(2, studentId);
            st.setInt(3, moduleItemId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
