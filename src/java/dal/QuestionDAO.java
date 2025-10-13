/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.dto.QuestionDTO;
import model.dto.QuestionOptionDTO;
import model.dto.QuestionTextKeyDTO;
import model.entity.QuestionOption;

/**
 *
 * @author Lenovo
 */
public class QuestionDAO extends DBContext {

    public int insertQuestion(Question q) throws SQLException {
        String sql = "INSERT INTO Question (module_id, lesson_id, content, type, explanation) "
                + "OUTPUT INSERTED.question_id VALUES (?, ?, ?, ?, ?)";
        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getModuleId());
            if (q.getLessonId() != null) {
                ps.setInt(2, q.getLessonId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, q.getContent());
            ps.setString(4, q.getType());
            ps.setString(5, q.getExplanation());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public void insertOption(QuestionOption opt) throws SQLException {
        String sql = "INSERT INTO QuestionOption (question_id, content, is_correct) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, opt.getQuestionId());
            ps.setString(2, opt.getContent());
            ps.setBoolean(3, opt.isCorrect());
            ps.executeUpdate();
        }
    }

    public List<Question> getQuestionsByModule(int moduleId) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE module_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setModuleId(rs.getInt("module_id"));
                q.setLessonId(rs.getObject("lesson_id") != null ? rs.getInt("lesson_id") : null);
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                list.add(q);
            }
        }
        return list;
    }

    public List<QuestionOption> getOptionsByQuestion(int questionId) throws SQLException {
        List<QuestionOption> list = new ArrayList<>();
        String sql = "SELECT * FROM QuestionOption WHERE question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionOption o = new QuestionOption(
                        rs.getInt("option_id"),
                        rs.getInt("question_id"),
                        rs.getString("content"),
                        rs.getBoolean("is_correct")
                );
                list.add(o);
            }
        }
        return list;
    }

    public List<QuestionDTO> getQuestionByLessonId(int lessonId) {
        List<QuestionDTO> listQuestion = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE lesson_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                QuestionDTO question = new QuestionDTO();
                question.setQuestionId(rs.getInt("question_id"));
                question.setModuleId(rs.getInt("module_id"));
                question.setLessonId(rs.getInt("lesson_id"));
                question.setContent(rs.getString("content"));
                question.setMediaType(rs.getString("media_type"));
                question.setMediaUrl(rs.getString("media_url"));
                question.setType(rs.getString("type"));
                question.setExplanation(rs.getString("explanation"));
                question.setOptions(getOptionsByQuestionId(question.getQuestionId()));  // Lấy các lựa chọn
                question.setAnswers(getAnswersByQuestionId(question.getQuestionId()));  // Lấy các câu trả lời kiểu text
                listQuestion.add(question);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listQuestion;
    }

    public QuestionDTO getQuestionById(int questionId) {
        String sql = "SELECT * FROM Question WHERE question_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    QuestionDTO q = new QuestionDTO();
                    q.setQuestionId(rs.getInt("question_id"));
                    q.setModuleId(rs.getInt("module_id"));
                    q.setLessonId(rs.getInt("lesson_id"));
                    q.setContent(rs.getString("content"));
                    q.setMediaType(rs.getString("media_type"));
                    q.setMediaUrl(rs.getString("media_url"));
                    q.setType(rs.getString("type"));
                    q.setExplanation(rs.getString("explanation"));

                    q.setOptions(getOptionsByQuestionId(q.getQuestionId()));
                    q.setAnswers(getAnswersByQuestionId(q.getQuestionId()));
                    return q;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<QuestionDTO> getQuestionByModuleId(int moduleId) {
        List<QuestionDTO> listQuestion = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE module_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, moduleId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    QuestionDTO question = new QuestionDTO();
                    question.setQuestionId(rs.getInt("question_id"));
                    question.setModuleId(rs.getInt("module_id"));
                    question.setLessonId(rs.getInt("lesson_id"));
                    question.setContent(rs.getString("content"));
                    question.setMediaType(rs.getString("media_type"));
                    question.setMediaUrl(rs.getString("media_url"));
                    question.setType(rs.getString("type"));
                    question.setExplanation(rs.getString("explanation"));

                    question.setOptions(getOptionsByQuestionId(question.getQuestionId()));

                    question.setAnswers(getAnswersByQuestionId(question.getQuestionId()));

                    listQuestion.add(question);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listQuestion;
    }

    private List<QuestionOptionDTO> getOptionsByQuestionId(int questionId) {
        List<QuestionOptionDTO> options = new ArrayList<>();
        String sql = "SELECT * FROM QuestionOption WHERE question_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                QuestionOptionDTO option = new QuestionOptionDTO();
                option.setOptionId(rs.getInt("option_id"));
                option.setContent(rs.getString("content"));
                option.setIsCorrect(rs.getBoolean("is_correct"));
                options.add(option);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return options;
    }

    private List<QuestionTextKeyDTO> getAnswersByQuestionId(int questionId) {
        List<QuestionTextKeyDTO> answers = new ArrayList<>();
        String sql = "SELECT * FROM QuestionTextKey WHERE question_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionTextKeyDTO answer = new QuestionTextKeyDTO();
                answer.setKeyId(rs.getInt("key_id"));
                answer.setAnswerText(rs.getString("answer_text"));
                answers.add(answer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return answers;
    }

    public boolean isCorrectOption(int qid, int optionId) {
        String sql = "SELECT 1 FROM QuestionOption WHERE question_id = ? AND option_id = ? AND is_correct = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, qid);
            st.setInt(2, optionId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCorrectTextAnswer(int qid, String answer) {
        if (answer == null || answer.isBlank()) {
            return false;
        }

        String sql = "SELECT answer_text FROM QuestionTextKey WHERE question_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, qid);
            ResultSet rs = st.executeQuery();

            String normalizedAnswer = normalize(answer);
            if (rs.next()) {
                String correctAnswer = normalize(rs.getString("answer_text"));
                if (correctAnswer.equals(normalizedAnswer)) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String normalize(String s) {
        return (s == null) ? "" : s.trim().toLowerCase();
    }

}
