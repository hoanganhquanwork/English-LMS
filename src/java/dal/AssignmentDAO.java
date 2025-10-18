/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Assignment;
import java.sql.*;

/**
 *
 * @author Lenovo
 */
public class AssignmentDAO extends DBContext{
    public boolean insertAssignment(Assignment a) {
        String sql = """
            INSERT INTO Assignment
            (assignment_id, title, content, instructions, submission_type,
             attachment_url, max_score, passing_score_pct, rubric)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, a.getAssignmentId());
            st.setString(2, a.getTitle());
            st.setString(3, a.getContent());
            st.setString(4, a.getInstructions());
            st.setString(5, a.getSubmissionType());
            st.setString(6, a.getAttachmentUrl());
            st.setDouble(7, a.getMaxScore());

            if (a.getPassingScorePct() != null) {
                st.setDouble(8, a.getPassingScorePct());
            } else {
                st.setNull(8, Types.DECIMAL);
            }

            st.setString(9, a.getRubric());

            return st.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(" Lỗi khi insert Assignment:");
            e.printStackTrace();
        }
        return false;
    }
    public Assignment getAssignmentById(int assignmentId) {
        String sql = "SELECT * FROM Assignment WHERE assignment_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, assignmentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Assignment a = new Assignment();
                a.setAssignmentId(rs.getInt("assignment_id"));
                a.setTitle(rs.getString("title"));
                a.setContent(rs.getString("content"));
                a.setInstructions(rs.getString("instructions"));
                a.setSubmissionType(rs.getString("submission_type"));
                a.setAttachmentUrl(rs.getString("attachment_url"));
                a.setMaxScore(rs.getDouble("max_score"));
                a.setPassingScorePct(rs.getObject("passing_score_pct") != null ? rs.getDouble("passing_score_pct") : null);
                a.setRubric(rs.getString("rubric"));
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean updateAssignment(Assignment a) {
        String sql = """
            UPDATE Assignment
            SET title = ?, content = ?, instructions = ?, submission_type = ?, 
                attachment_url = ?, max_score = ?, passing_score_pct = ?, rubric = ?
            WHERE assignment_id = ?
        """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, a.getTitle());
            st.setString(2, a.getContent());
            st.setString(3, a.getInstructions());
            st.setString(4, a.getSubmissionType());
            st.setString(5, a.getAttachmentUrl());
            st.setDouble(6, a.getMaxScore());
            if (a.getPassingScorePct() != null)
                st.setDouble(7, a.getPassingScorePct());
            else
                st.setNull(7, Types.DECIMAL);
            st.setString(8, a.getRubric());
            st.setInt(9, a.getAssignmentId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

 
}
