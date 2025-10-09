/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.QuestionOption;

/**
 *
 * @author Lenovo
 */
public class QuestionDAO extends DBContext {

    public int insertQuestion(Question q) throws SQLException {
        String sql = "INSERT INTO Question (module_id, lesson_id, question_text, question_type, explanation) "
                + "OUTPUT INSERTED.question_id VALUES (?, ?, ?, ?, ?)";
        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getModuleId());
            if (q.getLessonId() != null) {
                ps.setInt(2, q.getLessonId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, q.getQuestionText());
            ps.setString(4, q.getQuestionType());
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
        try ( PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, opt.getQuestionId());
            ps.setString(2, opt.getContent());
            ps.setBoolean(3, opt.isCorrect());
            ps.executeUpdate();
        }
    }

    public List<Question> getQuestionsByModule(int moduleId) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE module_id = ?";
        try ( PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setModuleId(rs.getInt("module_id"));
                q.setLessonId(rs.getObject("lesson_id") != null ? rs.getInt("lesson_id") : null);
                q.setQuestionText(rs.getString("question_text"));
                q.setQuestionType(rs.getString("question_type"));
                q.setExplanation(rs.getString("explanation"));
                list.add(q);
            }
        }
        return list;
    }

    public List<QuestionOption> getOptionsByQuestion(int questionId) throws SQLException {
        List<QuestionOption> list = new ArrayList<>();
        String sql = "SELECT * FROM QuestionOption WHERE question_id = ?";
        try ( PreparedStatement ps = connection.prepareStatement(sql)) {
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
}
