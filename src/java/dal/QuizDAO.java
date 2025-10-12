/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Quiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author Lenovo
 */
public class QuizDAO extends DBContext{
    public boolean insertQuiz(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO Quiz (quiz_id, title, attempts_allowed, passing_score_pct, pick_count) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quiz.getQuizId());
            ps.setString(2, quiz.getTitle());
            if (quiz.getAttemptsAllowed() != null) ps.setInt(3, quiz.getAttemptsAllowed());
            else ps.setNull(3, Types.INTEGER);
            if (quiz.getPassingScorePct() != null) ps.setBigDecimal(4, quiz.getPassingScorePct());
            else ps.setNull(4, Types.DECIMAL);
            if (quiz.getPickCount() != null) ps.setInt(5, quiz.getPickCount());
            else ps.setNull(5, Types.INTEGER);
            return ps.executeUpdate() > 0;
        }
    }
     public List<Integer> getQuestionIdsByModules(List<Integer> moduleIds) throws SQLException {
        if (moduleIds.isEmpty()) return Collections.emptyList();
        String inClause = String.join(",", moduleIds.stream().map(String::valueOf).toArray(String[]::new));
        String sql = "SELECT question_id FROM Question WHERE module_id IN (" + inClause + ")";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Integer> list = new ArrayList<>();
            while (rs.next()) list.add(rs.getInt("question_id"));
            return list;
        }
    }
}
