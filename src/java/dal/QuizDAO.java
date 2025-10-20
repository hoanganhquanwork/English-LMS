/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import model.dto.QuestionDTO;
import model.dto.QuizAttemptAnswerDTO;
import model.dto.QuizAttemptDTO;
import model.dto.QuizAttemptQuestionDTO;
import model.dto.QuizDTO;
import model.entity.Quiz;

/**
 *
 * @author Admin
 */
public class QuizDAO extends DBContext {

    private QuestionDAO questionDAO = new QuestionDAO();

    public boolean insertQuiz(Quiz quiz) {
        String sql = "INSERT INTO Quiz (quiz_id, title, attempts_allowed, passing_score_pct, pick_count) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quiz.getQuizId());
            ps.setString(2, quiz.getTitle());

            // attempts_allowed
            if (quiz.getAttemptsAllowed() != null) {
                ps.setInt(3, quiz.getAttemptsAllowed());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            // passing_score_pct
            if (quiz.getPassingScorePct() != null) {
                ps.setDouble(4, quiz.getPassingScorePct());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }

            // pick_count
            if (quiz.getPickCount() != null) {
                ps.setInt(5, quiz.getPickCount());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Quiz getQuiz(int quizId) {
        String sql = "SELECT * FROM Quiz WHERE quiz_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quizId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Quiz q = new Quiz();
                q.setQuizId(rs.getInt("quiz_id"));
                q.setTitle(rs.getString("title"));
                q.setAttemptsAllowed((Integer) rs.getObject("attempts_allowed"));
                q.setPassingScorePct(rs.getObject("passing_score_pct") == null ? null : rs.getDouble("passing_score_pct"));
                q.setPickCount((Integer) rs.getObject("pick_count"));
                return q;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //
    //tuanta
    public QuizDTO getQuizById(int quizId) {
        String sql = "SELECT q.quiz_id, q.title, q.attempts_allowed, q.passing_score_pct, q.pick_count, mi.module_id "
                + "FROM Quiz q JOIN ModuleItem mi ON q.quiz_id = mi.module_item_id "
                + "WHERE q.quiz_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quizId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                QuizDTO q = new QuizDTO();
                q.setQuizId(rs.getInt("quiz_id"));
                q.setTitle(rs.getNString("title"));
                //tranh neu null getInt se tra ve 0
                q.setAttemptsAllowed((Integer) rs.getObject("attempts_allowed"));
                q.setPassingScorePct(rs.getObject("passing_score_pct") == null ? null : rs.getDouble("passing_score_pct"));
                q.setPickCount((Integer) rs.getObject("pick_count"));
                q.setModuleId(rs.getInt("module_id"));
                q.setBank(questionDAO.getQuestionByModuleId(q.getModuleId()));
                return q;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countSubmittedAttempts(int quizId, int studentId) {
        String sql = "SELECT COUNT(*) FROM QuizAttempt WHERE quiz_id=? AND student_id=? AND status='submitted'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quizId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Double getBestScoreFromAttempts(int quizId, int studentId) {
        String sql = "SELECT MAX(score_pct) FROM QuizAttempt WHERE quiz_id = ? "
                + " AND student_id = ? AND status='submitted'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quizId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getObject(1) == null ? null : rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getNextAttemptNo(int quizId, int studentId) {
        String sql = "SELECT ISNULL(MAX(attempt_no),0)+1 FROM QuizAttempt WHERE quiz_id=? AND student_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quizId);
            st.setInt(2, studentId);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }

    public Long createDraftAttempt(int quizId, int studentId, int attemptNo) {
        String sql = "INSERT INTO QuizAttempt(quiz_id, student_id, attempt_no, status) VALUES (?,?,?,'draft')";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setInt(1, quizId);
            st.setInt(2, studentId);
            st.setInt(3, attemptNo);
            int rows = st.executeUpdate();
            if (rows > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public QuizAttemptDTO findQuizAttempById(long attemptId) {
        String sql = "SELECT attempt_id, quiz_id, student_id, attempt_no, status, submitted_at, score_pct "
                + "FROM QuizAttempt WHERE attempt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                QuizAttemptDTO qa = new QuizAttemptDTO();
                qa.setAttemptId(rs.getLong("attempt_id"));
                qa.setQuizId(rs.getInt("quiz_id"));
                qa.setStudentId(rs.getInt("student_id"));
                qa.setAttemptNo(rs.getInt("attempt_no"));
                qa.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("submitted_at");
                qa.setSubmittedAt(ts == null ? null : ts.toLocalDateTime());
                qa.setScorePct(rs.getObject("score_pct") == null ? null : rs.getDouble("score_pct"));
                return qa;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public QuizAttemptDTO findLatestAttempt(int quizId, int studentId) {
        String sql = "SELECT TOP 1 attempt_id, quiz_id, student_id, attempt_no,"
                + " status, submitted_at, score_pct"
                + " FROM QuizAttempt WHERE quiz_id = ? AND student_id = ?"
                + " ORDER BY attempt_no DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quizId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                QuizAttemptDTO qa = new QuizAttemptDTO();
                qa.setAttemptId(rs.getLong("attempt_id"));
                qa.setQuizId(rs.getInt("quiz_id"));
                qa.setStudentId(rs.getInt("student_id"));
                qa.setAttemptNo(rs.getInt("attempt_no"));
                qa.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("submitted_at");
                qa.setSubmittedAt(ts == null ? null : ts.toLocalDateTime());
                qa.setScorePct(rs.getObject("score_pct") == null ? null : rs.getDouble("score_pct"));
                return qa;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<QuizAttemptQuestionDTO> getAttemptQuestions(long attemptId) {
        List<QuizAttemptQuestionDTO> list = new ArrayList<>();
        String sql = "SELECT aq.attempt_question_id, aq.attempt_id, aq.question_id, aq.display_order "
                + "FROM QuizAttemptQuestion aq WHERE aq.attempt_id = ? ORDER BY aq.display_order ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                QuizAttemptQuestionDTO qaq = new QuizAttemptQuestionDTO();
                qaq.setAttemptQuestionId(rs.getLong("attempt_question_id"));
                qaq.setAttemptId(rs.getLong("attempt_id"));
                int qid = rs.getInt("question_id");
                qaq.setQuestionId(qid);
                qaq.setDisplayOrder(rs.getInt("display_order"));

                QuestionDTO q = questionDAO.getQuestionById(qid);
                qaq.setQuestion(q);
                list.add(qaq);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<QuizAttemptAnswerDTO> getAttemptAnswers(long attemptId) {
        List<QuizAttemptAnswerDTO> list = new ArrayList<>();
        String sql = "SELECT attempt_id, question_id, chosen_option_id, answer_text, is_correct "
                + "FROM AttemptAnswer WHERE attempt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                QuizAttemptAnswerDTO qaa = new QuizAttemptAnswerDTO();
                qaa.setAttemptId(rs.getLong("attempt_id"));
                qaa.setQuestionId(rs.getInt("question_id"));
                Object opt = rs.getObject("chosen_option_id");
                qaa.setChosenOptionId(opt == null ? null : rs.getInt("chosen_option_id"));
                qaa.setAnswerText(rs.getString("answer_text"));
                Object corr = rs.getObject("is_correct");
                qaa.setIsCorrect(corr == null ? null : rs.getBoolean("is_correct"));
                list.add(qaa);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public long insertAttemptQuestion(long attemptId, int questionId, int displayOrder) {
        String sql = "INSERT INTO QuizAttemptQuestion(attempt_id, question_id, display_order) VALUES(?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setLong(1, attemptId);
            st.setInt(2, questionId);
            st.setInt(3, displayOrder);
            st.executeUpdate();
            return 0L;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0L;
    }

    //for save draft
    public int clearAnswersForAttempt(long attemptId) {
        String sql = "DELETE FROM AttemptAnswer WHERE attempt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public void insertAnswer(long attemptId, int questionId,
            Integer chosenOptionId, String answerText) {
        String sql = "INSERT INTO AttemptAnswer"
                + " (attempt_id, question_id, chosen_option_id, answer_text, is_correct) "
                + "VALUES (?,?,?,?,NULL)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            st.setInt(2, questionId);
            if (chosenOptionId == null) {
                st.setNull(3, java.sql.Types.INTEGER);
            } else {
                st.setInt(3, chosenOptionId);
            }

            if (answerText == null) {
                st.setNull(4, java.sql.Types.NVARCHAR);
            } else {
                st.setNString(4, answerText);
            }
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //

    //for grade
    public int markCorrectnessForMCQ(long attemptId) {
        String sql
                = "UPDATE aa SET aa.is_correct = CASE WHEN qo.is_correct = 1 THEN 1 ELSE 0 END "
                + "FROM AttemptAnswer aa "
                + "LEFT JOIN QuestionOption qo ON qo.option_id = aa.chosen_option_id "
                + "WHERE aa.attempt_id = ? AND aa.chosen_option_id IS NOT NULL";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int markCorrectnessForTextUsingKeys(long attemptId) {
        String sql
                = "UPDATE aa SET aa.is_correct = CASE WHEN qk.question_id IS NOT NULL THEN 1 ELSE 0 END "
                + "FROM AttemptAnswer aa "
                + "LEFT JOIN QuestionTextKey qk "
                + " ON qk.question_id = aa.question_id "
                + " AND LTRIM(RTRIM(LOWER(qk.answer_text))) = LTRIM(RTRIM(LOWER(aa.answer_text))) "
                + "WHERE aa.attempt_id = ? AND aa.answer_text IS NOT NULL";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            return st.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int[] countCorrectAndTotal(long attemptId) {
        String sql
                = "SELECT "
                + "  SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) AS correct_cnt, "
                + "  COUNT(*) AS total_cnt "
                + "FROM AttemptAnswer WHERE attempt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, attemptId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new int[]{rs.getInt("correct_cnt"), rs.getInt("total_cnt")};
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new int[]{0, 0};
    }

    public int markSubmitted(long attemptId, double scorePct) {
        String sql = "UPDATE QuizAttempt "
                + "SET status='submitted', score_pct=?, submitted_at=GETDATE() "
                + "WHERE attempt_id=? AND status='draft'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDouble(1, scorePct);
            st.setLong(2, attemptId);
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();;
            return -1;
        }
    }

    //for view lastest attempt
    public QuizAttemptDTO findLatestSubmittedAttempt(int quizId, int studentId) {
        String sql = "SELECT TOP 1 "
                + "attempt_id, quiz_id, student_id, attempt_no, status, "
                + "score_pct, submitted_at "
                + "FROM QuizAttempt "
                + "WHERE quiz_id = ? AND student_id = ? AND status = 'submitted' "
                + "ORDER BY submitted_at DESC, attempt_no DESC, attempt_id DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quizId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                QuizAttemptDTO qa = new QuizAttemptDTO();
                qa.setAttemptId(rs.getLong("attempt_id"));
                qa.setQuizId(rs.getInt("quiz_id"));
                qa.setStudentId(rs.getInt("student_id"));
                qa.setAttemptNo(rs.getInt("attempt_no"));
                qa.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("submitted_at");
                qa.setSubmittedAt(ts == null ? null : ts.toLocalDateTime());
                qa.setScorePct(rs.getObject("score_pct") == null ? null : rs.getDouble("score_pct"));
                return qa;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateQuiz(int quizId, String title, Integer attemptsAllowed, java.math.BigDecimal passingScorePct, Integer pickCount) {
        String sql = "UPDATE Quiz SET title = ?, attempts_allowed = ?, passing_score_pct = ?, pick_count = ? WHERE quiz_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, title);

            if (attemptsAllowed != null) {
                ps.setInt(2, attemptsAllowed);
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            if (passingScorePct != null) {
                ps.setBigDecimal(3, passingScorePct);
            } else {
                ps.setNull(3, Types.DECIMAL);
            }

            if (pickCount != null) {
                ps.setInt(4, pickCount);
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            ps.setInt(5, quizId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteQuiz(int quizId) {
        String sql = "DELETE FROM Quiz WHERE quiz_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
//
//end tuanta

