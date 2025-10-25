package dal;

import java.sql.*;
import java.util.*;
import model.dto.QuestionDTO;
import model.dto.QuestionListItemDTO;
import model.dto.QuestionOptionDTO;
import model.dto.QuestionTextKeyDTO;
import model.entity.InstructorProfile;
import model.entity.Question;
import model.entity.QuestionOption;
import model.entity.QuestionTextKey;

public class QuestionManagerDAO extends DBContext {

    public List<QuestionListItemDTO> getFilteredQuestions(String status, String keyword, String instructorName, String type, String topicId) {
        List<QuestionListItemDTO> list = new ArrayList<>();

        String sql = "SELECT q.question_id, q.content, q.type, q.status, "
                + "q.explanation, q.review_comment, q.media_url, "
                + "u.full_name AS instructor_name, t.name AS topic_name "
                + "FROM Question q "
                + "JOIN Users u ON q.created_by = u.user_id "
                + "LEFT JOIN Topics t ON q.topic_id = t.topic_id "
                + "WHERE q.status <> 'draft' "
                + "AND q.topic_id IS NOT NULL ";;

        if (!"all".equalsIgnoreCase(status)) {
            sql += "AND q.status = ? ";
        }
        if (type != null && !"all".equalsIgnoreCase(type)) {
            sql += "AND q.type = ? ";
        }
        if (topicId != null && !"all".equalsIgnoreCase(topicId)) {
            sql += "AND q.topic_id = ? ";
        }
        if ((keyword != null && !keyword.isBlank()) || (instructorName != null && !instructorName.isBlank())) {
            sql += "AND (q.content LIKE ? OR u.full_name LIKE ?) ";
        }

        sql += "ORDER BY q.question_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            if (!"all".equalsIgnoreCase(status)) {
                ps.setString(idx++, status);
            }
            if (type != null && !"all".equalsIgnoreCase(type)) {
                ps.setString(idx++, type);
            }
            if (topicId != null && !"all".equalsIgnoreCase(topicId)) {
                ps.setInt(idx++, Integer.parseInt(topicId));
            }
            if ((keyword != null && !keyword.isBlank()) || (instructorName != null && !instructorName.isBlank())) {
                ps.setString(idx++, "%" + (keyword == null ? "" : keyword) + "%");
                ps.setString(idx++, "%" + (instructorName == null ? "" : instructorName) + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionListItemDTO q = new QuestionListItemDTO();
                q.setQuestionId(rs.getInt("question_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setStatus(rs.getString("status"));
                q.setExplanation(rs.getString("explanation"));
                q.setReviewComment(rs.getString("review_comment"));
                q.setMediaUrl(rs.getString("media_url"));
                q.setInstructorName(rs.getString("instructor_name"));
                q.setTopicName(rs.getString("topic_name"));
                list.add(q);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public QuestionListItemDTO getQuestionDetail(int questionId) {
        String sql = "SELECT q.question_id, q.content, q.type, q.status, "
                + "q.explanation, q.media_url, q.review_comment, "
                + "u.full_name AS instructor_name "
                + "FROM Question q "
                + "JOIN Users u ON q.created_by = u.user_id "
                + "WHERE q.question_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                QuestionListItemDTO q = new QuestionListItemDTO();
                q.setQuestionId(rs.getInt("question_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setStatus(rs.getString("status"));
                q.setExplanation(rs.getString("explanation"));
                q.setMediaUrl(rs.getString("media_url"));
                q.setReviewComment(rs.getString("review_comment"));
                q.setInstructorName(rs.getString("instructor_name"));
                q.setOptions(getOptionsByQuestionId(questionId));
                q.setAnswers(getAnswersByQuestionId(questionId));

                return q;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<QuestionOption> getOptionsByQuestionId(int questionId) {
        List<QuestionOption> list = new ArrayList<>();
        String sql = "SELECT option_id, question_id, content, is_correct "
                + "FROM QuestionOption WHERE question_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionOption o = new QuestionOption();
                o.setOptionId(rs.getInt("option_id"));
                o.setQuestionId(rs.getInt("question_id"));
                o.setContent(rs.getString("content"));
                o.setCorrect(rs.getBoolean("is_correct"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<QuestionTextKey> getAnswersByQuestionId(int questionId) {
        List<QuestionTextKey> list = new ArrayList<>();
        String sql = "SELECT key_id, question_id, answer_text "
                + "FROM QuestionTextKey WHERE question_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionTextKey a = new QuestionTextKey();
                a.setKeyId(rs.getInt("key_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setAnswerText(rs.getString("answer_text"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateQuestionStatus(int questionId, String newStatus) {
        String sql = "UPDATE Question SET status = ?, review_comment = NULL WHERE question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, questionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean rejectQuestionWithReason(int questionId, String reason) {
        String sql = "UPDATE Question SET status = 'rejected', review_comment = ? WHERE question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, questionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public List<String> findInstructorNames(String keyword) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT full_name FROM Users WHERE role = 'Instructor' AND full_name LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("full_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
