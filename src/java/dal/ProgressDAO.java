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

    public boolean markVideoWatched(int studentId, int moduleItemId) {
        String sql = "UPDATE Progress "
                + "SET percent_done = 100, updated_at = GETDATE() "
                + "WHERE student_id = ? AND module_item_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, moduleItemId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markLessonVideoCompleted(int studentId, int moduleItemId) {
        String sql = "UPDATE Progress "
                + "SET status = 'completed', completed_at = GETDATE(), updated_at = GETDATE() "
                + "WHERE student_id = ? AND module_item_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, moduleItemId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasWatchedVideo(int studentId, int moduleItemId) {
        String sql = "SELECT percent_done "
                + "FROM Progress "
                + "WHERE student_id = ? AND module_item_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, moduleItemId);
            ResultSet rs = st.executeQuery();
            if (!rs.next()) {
                return false;
            }
            double percent = rs.getDouble("percent_done");
            return percent == 100.0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //kiem tra xem hoan thanh lesson chua
    public boolean isLessonCompleted(int studentId, int moduleItemId) {
        String sql = "SELECT status FROM Progress WHERE student_id=? AND module_item_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, moduleItemId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return "completed".equalsIgnoreCase(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    public Double getBestScoreFromProgress(int studentId, int moduleItemId) {
        String sql = "SELECT score_pct FROM Progress WHERE student_id=? AND module_item_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, moduleItemId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return (Double) rs.getObject("score_pct"); // có thể null
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //quiz score
    public int updateBestQuizScore(int studentId, int moduleItemId, double newScorePct, boolean passed) {
        String sqlUpdate
                = "UPDATE Progress SET "
                + "  score_pct = CASE WHEN score_pct IS NULL OR ? > score_pct THEN ? ELSE score_pct END, "
                + "  status = CASE WHEN ? = 1 THEN 'completed' ELSE status END, "
                + "  completed_at = CASE WHEN ? = 1 AND completed_at IS NULL THEN GETDATE() ELSE completed_at END, "
                + "  updated_at = GETDATE() "
                + "WHERE student_id = ? AND module_item_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sqlUpdate);
            int i = 1;
            st.setDouble(i++, newScorePct);
            st.setDouble(i++, newScorePct);
            st.setInt(i++, passed ? 1 : 0);
            st.setInt(i++, passed ? 1 : 0);
            st.setInt(i++, studentId);
            st.setInt(i++, moduleItemId);
            int rows = st.executeUpdate();
            if (rows == 0) {
                throw new IllegalStateException("Progress chưa được tạo trước khi chấm điểm.");
            }
            return rows;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

}
