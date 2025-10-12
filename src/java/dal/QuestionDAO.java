/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.QuestionOption;

/**
 *
 * @author Lenovo
 */
public class QuestionDAO extends DBContext {

    public int insertQuestion(Question q) {
        String sql = "INSERT INTO Question (module_id, lesson_id, content, type, explanation) "
                + "OUTPUT INSERTED.question_id VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getModuleId());
            if (q.getLessonId() != null) {
                ps.setInt(2, q.getLessonId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, q.getContent());
            ps.setString(4, q.getType());
            ps.setString(5, q.getExplanation());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(" Lỗi khi thêm câu hỏi: " + e.getMessage());
        }
        return -1;
    }

    public void insertOption(QuestionOption opt) {
        String sql = "INSERT INTO QuestionOption (question_id, content, is_correct) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, opt.getQuestionId());
            ps.setString(2, opt.getContent());
            ps.setBoolean(3, opt.isCorrect());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println(" Lỗi khi thêm phương án: " + e.getMessage());
        }
    }

    public List<Question> getQuestionsByModule(int moduleId) {
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
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách câu hỏi theo module: " + e.getMessage());
        }
        return list;
    }

    public List<QuestionOption> getOptionsByQuestion(int questionId) {
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
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy phương án câu hỏi: " + e.getMessage());
        }
        return list;
    }

    public List<Question> getQuestionsByLesson(int lessonId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE lesson_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
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
        } catch (SQLException e) {
            System.err.println(" Lỗi getQuestionsByLesson: " + e.getMessage());
        }
        return list;
    }

    public boolean deleteQuestion(int questionId) {
        String deleteOptions = "DELETE FROM QuestionOption WHERE question_id = ?";
        String deleteQuestion = "DELETE FROM Question WHERE question_id = ?";
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps1 = connection.prepareStatement(deleteOptions)) {
                ps1.setInt(1, questionId);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = connection.prepareStatement(deleteQuestion)) {
                ps2.setInt(1, questionId);
                ps2.executeUpdate();
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateQuestionWithOptions(Question q, List<QuestionOption> options) {
        String updateQuestion = "UPDATE Question SET content = ?, explanation = ? WHERE question_id = ?";
        String deleteOldOptions = "DELETE FROM QuestionOption WHERE question_id = ?";
        String insertOption = "INSERT INTO QuestionOption (question_id, content, is_correct) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(updateQuestion)) {
                ps.setString(1, q.getContent());
                ps.setString(2, q.getExplanation());
                ps.setInt(3, q.getQuestionId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(deleteOldOptions)) {
                ps.setInt(1, q.getQuestionId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(insertOption)) {
                for (QuestionOption opt : options) {
                    ps.setInt(1, q.getQuestionId());
                    ps.setString(2, opt.getContent());
                    ps.setBoolean(3, opt.isCorrect());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
