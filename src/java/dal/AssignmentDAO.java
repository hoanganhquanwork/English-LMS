/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Assignment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.dto.AssignmentDTO;
import model.dto.AssignmentWorkDTO;
import model.dto.RubricCriterionDTO;

/**
 *
 * @author Lenovo
 */
public class AssignmentDAO extends DBContext {

    private final ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

    public boolean insertAssignment(Assignment a) {
        String sql = """
        INSERT INTO Assignment
        (assignment_id, title, content, instructions, submission_type,
         attachment_url, max_score, passing_score_pct, is_ai_grade_allowed, prompt_summary)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, a.getAssignmentId().getModuleItemId());

            st.setString(2, a.getTitle());
            st.setString(3, a.getContent());
            st.setString(4, a.getInstructions());
            st.setString(5, a.getSubmissionType());
            st.setString(6, a.getAttachmentUrl());

            double maxScore = (a.getMaxScore() > 0) ? a.getMaxScore() : 100.0;
            st.setDouble(7, maxScore);

            if (a.getPassingScorePct() != null) {
                st.setDouble(8, a.getPassingScorePct());
            } else {
                st.setNull(8, Types.DECIMAL);
            }

            st.setBoolean(9, a.isAiGradeAllowed());

            if (a.getPromptSummary() != null && !a.getPromptSummary().isBlank()) {
                st.setString(10, a.getPromptSummary());
            } else {
                st.setNull(10, Types.NVARCHAR);
            }

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
                a.setAssignmentId(moduleItemDAO.getModuleItemById(rs.getInt("assignment_id")));
                a.setTitle(rs.getString("title"));
                a.setContent(rs.getString("content"));
                a.setInstructions(rs.getString("instructions"));
                a.setSubmissionType(rs.getString("submission_type"));
                a.setAttachmentUrl(rs.getString("attachment_url"));
                a.setMaxScore(rs.getDouble("max_score"));
                a.setPassingScorePct(rs.getObject("passing_score_pct") != null ? rs.getDouble("passing_score_pct") : null);
                a.setAiGradeAllowed(rs.getBoolean("is_ai_grade_allowed"));
                a.setPromptSummary(rs.getString("prompt_summary"));
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
            attachment_url = ?, max_score = ?, passing_score_pct = ?, 
            is_ai_grade_allowed = ?, prompt_summary = ?
        WHERE assignment_id = ?
    """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, a.getTitle());
            st.setString(2, a.getContent());
            st.setString(3, a.getInstructions());
            st.setString(4, a.getSubmissionType());
            st.setString(5, a.getAttachmentUrl());
            st.setDouble(6, a.getMaxScore());

            if (a.getPassingScorePct() != null) {
                st.setDouble(7, a.getPassingScorePct());
            } else {
                st.setNull(7, Types.DECIMAL);
            }

            st.setBoolean(8, a.isAiGradeAllowed());
            st.setString(9, a.getPromptSummary());
            st.setInt(10, a.getAssignmentId().getModuleItemId());

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public AssignmentDTO findAssignmentById(int assignmentId) {
        String sql = "SELECT assignment_id, title, content, instructions, submission_type,"
                + " attachment_url, passing_score_pct, is_ai_grade_allowed, prompt_summary"
                + " FROM Assignment WHERE assignment_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, assignmentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                AssignmentDTO a = new AssignmentDTO();
                a.setAssignmentId(rs.getInt("assignment_id"));
                a.setTitle(rs.getString("title"));
                a.setContent(rs.getString("content"));
                a.setInstructions(rs.getString("instructions"));
                a.setSubmissionType(rs.getString("submission_type"));
                a.setAttachmentUrl(rs.getString("attachment_url"));
                a.setPassingScorePct(rs.getBigDecimal("passing_score_pct"));
                a.setAiGradeAllowed(rs.getBoolean("is_ai_grade_allowed"));
                a.setPromptSummary(rs.getString("prompt_summary"));
                a.setRubric(getRubricByAssignmentId(assignmentId));
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<RubricCriterionDTO> getRubricByAssignmentId(int assignmentId) {
        String sql = " SELECT assignment_id, criterion_no, weight, guidance "
                + "  FROM RubricCriterion "
                + "  WHERE assignment_id = ? "
                + "  ORDER BY criterion_no";
        List<RubricCriterionDTO> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, assignmentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                RubricCriterionDTO r = new RubricCriterionDTO();
                r.setAssignmentId(rs.getInt("assignment_id"));
                r.setCriterionNo(rs.getShort("criterion_no"));
                r.setWeight(rs.getBigDecimal("weight"));
                r.setGuidance(rs.getString("guidance"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public AssignmentWorkDTO findAssigmentWork(int studentId, int assignmentId) {
        String sql = " SELECT * FROM AssignmentWork "
                + " WHERE assignment_id = ? AND student_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, assignmentId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                AssignmentWorkDTO work = new AssignmentWorkDTO();
                work.setAssignmentId(rs.getInt("assignment_id"));
                work.setStudentId(rs.getInt("student_id"));
                work.setSubmittedAt(rs.getTimestamp("submitted_at") != null
                        ? rs.getTimestamp("submitted_at").toLocalDateTime() : null);
                work.setTextAnswer(rs.getString("text_answer"));
                work.setFileUrl(rs.getString("file_url"));
                work.setStatus(rs.getString("status"));
                work.setScore(rs.getBigDecimal("score"));
                work.setGraderId((Integer) rs.getObject("grader_id"));
                work.setDraftSavedAt(rs.getTimestamp("draft_saved_at") != null
                        ? rs.getTimestamp("draft_saved_at").toLocalDateTime() : null);
                work.setGradedAt(rs.getTimestamp("graded_at") != null
                        ? rs.getTimestamp("graded_at").toLocalDateTime() : null);
                work.setFeedbackText(rs.getString("feedback_text"));
                return work;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveAssignmentDraft(AssignmentWorkDTO work) {
        String updateSql = "UPDATE AssignmentWork "
                + " SET text_answer = ?, file_url = ?, status = 'draft',"
                + " draft_saved_at = GETDATE() "
                + " WHERE assignment_id = ? AND student_id = ?";

        String insertSql = "INSERT INTO AssignmentWork "
                + " (assignment_id, student_id, text_answer, file_url, status, draft_saved_at) "
                + "  VALUES (?, ?, ?, ?, 'draft', GETDATE())";

        try {
            PreparedStatement up = connection.prepareStatement(updateSql);
            up.setString(1, work.getTextAnswer());
            up.setString(2, work.getFileUrl());
            up.setInt(3, work.getAssignmentId());
            up.setInt(4, work.getStudentId());
            if (up.executeUpdate() > 0) {
                return true;
            }

            PreparedStatement ins = connection.prepareStatement(insertSql);
            ins.setInt(1, work.getAssignmentId());
            ins.setInt(2, work.getStudentId());
            ins.setString(3, work.getTextAnswer());
            ins.setString(4, work.getFileUrl());
            ins.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean submitWork(AssignmentWorkDTO work) {
        String updateSql = "UPDATE AssignmentWork "
                + "  SET status = 'submitted', "
                + "  submitted_at = GETDATE(), "
                + "  text_answer = ?, file_url = ? "
                + "  WHERE assignment_id = ? AND student_id = ?";
        String insertSql = "INSERT INTO AssignmentWork "
                + " (assignment_id, student_id, text_answer, file_url, status, submitted_at) "
                + "  VALUES (?, ?, ?, ?, 'submitted', GETDATE())";
        try {
            PreparedStatement up = connection.prepareStatement(updateSql);
            up.setString(1, work.getTextAnswer());
            up.setString(2, work.getFileUrl());
            up.setInt(3, work.getAssignmentId());
            up.setInt(4, work.getStudentId());
            int rows = up.executeUpdate();
            if (rows > 0) {
                return true;
            }

            PreparedStatement ins = connection.prepareStatement(insertSql);
            ins.setInt(1, work.getAssignmentId());
            ins.setInt(2, work.getStudentId());
            ins.setString(3, work.getTextAnswer());
            ins.setString(4, work.getFileUrl());
            return ins.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateScoreAndFeedback(int assignmentId, int studentId, double score, String feedback, Integer graderId) {
        String sql = "UPDATE AssignmentWork "
                + "  SET score = ?, feedback_text = ?, grader_id = ?, graded_at = GETDATE(), "
                + "  status = CASE WHEN ? >= (SELECT passing_score_pct FROM Assignment WHERE assignment_id = ?)"
                + "  THEN 'passed' ELSE 'returned' END"
                + "  WHERE assignment_id = ? AND student_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDouble(1, score);
            st.setString(2, feedback);

            if (graderId == null) {
                st.setNull(3, java.sql.Types.INTEGER);
            } else {
                st.setInt(3, graderId);
            }

            st.setDouble(4, score);
            st.setInt(5, assignmentId);
            st.setInt(6, assignmentId);
            st.setInt(7, studentId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
