/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Question;
import model.entity.Topic;
import model.entity.InstructorProfile;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.dto.QuestionDTO;
import model.dto.QuestionOptionDTO;
import model.dto.QuestionTextKeyDTO;
import model.entity.QuestionOption;
import model.entity.QuestionTextKey;

/**
 *
 * @author Lenovo
 */
public class QuestionDAO extends DBContext {

    public int insertQuestion(Question q) {
        String sql = "INSERT INTO Question (lesson_id, content, media_url, type, explanation, status, topic_id, created_by) "
                + "OUTPUT INSERTED.question_id VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (q.getLessonId() != null) {
                ps.setInt(1, q.getLessonId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, q.getContent());
            ps.setString(3, q.getMediaUrl());
            ps.setString(4, q.getType());
            ps.setString(5, q.getExplanation());
            ps.setString(6, q.getStatus());
            if (q.getTopicId() != null) {
                ps.setInt(7, q.getTopicId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setInt(8, q.getCreatedBy().getUser().getUserId());

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

    public void insertTextAnswer(QuestionTextKey key) {
        String sql = "INSERT INTO QuestionTextKey (question_id, answer_text) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, key.getQuestionId());
            ps.setString(2, key.getAnswerText());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println(" Lỗi khi thêm đáp án text: " + e.getMessage());
        }
    }

    public int addQuestionsToModule(int moduleId, List<Integer> questionIds) {
        String checkSQL = "SELECT COUNT(*) FROM ModuleQuestions WHERE module_id = ? AND question_id = ?";
        String insertSQL = "INSERT INTO ModuleQuestions (module_id, question_id) VALUES (?, ?)";
        int successCount = 0;

        try {
            connection.setAutoCommit(false); // mở transaction

            for (int qid : questionIds) {
                // 1️⃣ kiểm tra trùng
                try (PreparedStatement checkStmt = connection.prepareStatement(checkSQL)) {
                    checkStmt.setInt(1, moduleId);
                    checkStmt.setInt(2, qid);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        continue; // bỏ qua nếu đã tồn tại
                    }
                }

                // 2️⃣ thêm mới
                try (PreparedStatement insertStmt = connection.prepareStatement(insertSQL)) {
                    insertStmt.setInt(1, moduleId);
                    insertStmt.setInt(2, qid);
                    successCount += insertStmt.executeUpdate();
                }
            }

            connection.commit(); // commit nếu không lỗi
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback(); // rollback khi lỗi
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return successCount;
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

    public String getAnswerByQuestionId(int questionId) {
        String sql = "SELECT answer_text FROM QuestionTextKey WHERE question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("answer_text");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Không có đáp án
    }

    public boolean submitQuestions(List<Integer> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) {
            return false;
        }

        String sql = "UPDATE Question SET status = 'submitted' WHERE question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            for (int id : questionIds) {
                ps.setInt(1, id);
                ps.addBatch();
            }
            ps.executeBatch();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Question> getQuestionsByLesson(int lessonId) {
        List<Question> list = new ArrayList<>();
        String sql = """
        SELECT * FROM Question
        WHERE lesson_id = ?
        ORDER BY question_id DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setLessonId(rs.getInt("lesson_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                q.setStatus(rs.getString("status"));
                q.setMediaUrl(rs.getString("media_url"));
                q.setReviewComment(rs.getString("review_comment"));
                list.add(q);
            }
        } catch (SQLException e) {
            System.err.println(" Lỗi khi lấy câu hỏi theo lesson: " + e.getMessage());
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
        String updateQuestion = "UPDATE Question SET content = ?, explanation = ?, media_url = ? WHERE question_id = ?";
        String deleteOldOptions = "DELETE FROM QuestionOption WHERE question_id = ?";
        String insertOption = "INSERT INTO QuestionOption (question_id, content, is_correct) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(updateQuestion)) {
                ps.setString(1, q.getContent());
                ps.setString(2, q.getExplanation());
                ps.setString(3, q.getMediaUrl());
                ps.setInt(4, q.getQuestionId());
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

    public boolean updateQuestionWithTextAnswer(Question q, String answerText) {
        String updateQuestion = "UPDATE Question SET content = ?, explanation = ?, media_url = ?  WHERE question_id = ?";
        String updateAnswer = "UPDATE QuestionTextKey SET answer_text = ? WHERE question_id = ?";
        String insertAnswer = "INSERT INTO QuestionTextKey (question_id, answer_text) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(updateQuestion)) {
                ps.setString(1, q.getContent());
                ps.setString(2, q.getExplanation());
                ps.setString(3, q.getMediaUrl());
                ps.setInt(4, q.getQuestionId());
                ps.executeUpdate();
            }

            int updatedRows;
            try (PreparedStatement ps = connection.prepareStatement(updateAnswer)) {
                ps.setString(1, answerText);
                ps.setInt(2, q.getQuestionId());
                updatedRows = ps.executeUpdate();
            }

            if (updatedRows == 0) {
                try (PreparedStatement ps = connection.prepareStatement(insertAnswer)) {
                    ps.setInt(1, q.getQuestionId());
                    ps.setString(2, answerText);
                    ps.executeUpdate();
                }
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

    public void assignTopicToQuestions(int topicId, List<Integer> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) {
            return;
        }

        String sql = "UPDATE Question SET topic_id = ? WHERE question_id = ?";

        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {

            for (Integer qid : questionIds) {
                ps.setInt(1, topicId);
                ps.setInt(2, qid);
                ps.addBatch();
            }
            ps.executeBatch();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<QuestionDTO> getQuestionByLessonId(int lessonId) {
        List<QuestionDTO> listQuestion = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE lesson_id = ? AND status = 'approved'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                QuestionDTO question = new QuestionDTO();
                question.setQuestionId(rs.getInt("question_id"));
                question.setLessonId((Integer) rs.getObject("lesson_id"));
                question.setContent(rs.getString("content"));
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
                    QuestionDTO question = new QuestionDTO();
                    question.setQuestionId(rs.getInt("question_id"));
                    question.setLessonId((Integer) rs.getObject("lesson_id"));
                    question.setContent(rs.getString("content"));
                    question.setMediaUrl(rs.getString("media_url"));
                    question.setType(rs.getString("type"));
                    question.setExplanation(rs.getString("explanation"));
                    question.setOptions(getOptionsByQuestionId(question.getQuestionId()));  // Lấy các lựa chọn
                    question.setAnswers(getAnswersByQuestionId(question.getQuestionId()));  // Lấy các câu trả lời kiểu text
                    return question;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<QuestionDTO> getQuestionByModuleId(int moduleId) {
        List<QuestionDTO> listQuestion = new ArrayList<>();
        String sql = "SELECT q.question_id, q.lesson_id, q.content, q.media_url, "
                + "q.type, q.explanation FROM ModuleQuestions mq "
                + "JOIN Question q ON q.question_id = mq.question_id  "
                + "WHERE mq.module_id = ? AND q.status = 'approved' ORDER BY q.question_id DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, moduleId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    QuestionDTO question = new QuestionDTO();
                    question.setQuestionId(rs.getInt("question_id"));
                    question.setLessonId((Integer) rs.getObject("lesson_id"));
                    question.setContent(rs.getString("content"));
                    question.setMediaUrl(rs.getString("media_url"));
                    question.setType(rs.getString("type"));
                    question.setExplanation(rs.getString("explanation"));
                    question.setOptions(getOptionsByQuestionId(question.getQuestionId()));  // Lấy các lựa chọn
                    question.setAnswers(getAnswersByQuestionId(question.getQuestionId()));  // Lấy các câu trả lời kiểu text
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
                option.setQuestionId(rs.getInt("question_id"));
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
                answer.setQuestionId(rs.getInt("question_id"));
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

    public List<Question> getDraftQuestionsByInstructorPaged(int instructorId, int offset, int pageSize) {
        List<Question> list = new ArrayList<>();
        String sql = """
        SELECT * FROM Question 
        WHERE status IN ('draft', 'rejected') 
          AND created_by = ?
        ORDER BY question_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                q.setTopicId(rs.getObject("topic_id") != null ? rs.getInt("topic_id") : null);
                q.setStatus(rs.getString("status"));
                q.setMediaUrl(rs.getString("media_url"));
                q.setReviewComment(rs.getString("review_comment"));
                list.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countDraftQuestionsByInstructor(int instructorId) {
        String sql = "SELECT COUNT(*) FROM Question WHERE status IN ('draft', 'rejected') AND created_by = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean removeQuestionFromModule(int moduleId, int questionId) {
        String sql = "DELETE FROM ModuleQuestions WHERE module_id = ? AND question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ps.setInt(2, questionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countSubmittedQuestions(int instructorId, String statusFilter, String topicFilter) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Question WHERE created_by = ? AND status IN ('submitted','approved')"
        );

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (topicFilter != null && !topicFilter.isEmpty()) {
            sql.append(" AND topic_id = ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, instructorId);

            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(index++, statusFilter);
            }
            if (topicFilter != null && !topicFilter.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(topicFilter));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Question> getSubmittedQuestionsPaged(int instructorId, String statusFilter, String topicFilter, int offset, int pageSize) {
        List<Question> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM Question WHERE created_by = ? AND status IN ('submitted','approved')"
        );

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (topicFilter != null && !topicFilter.isEmpty()) {
            sql.append(" AND topic_id = ?");
        }

        sql.append(" ORDER BY question_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, instructorId);

            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(index++, statusFilter);
            }
            if (topicFilter != null && !topicFilter.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(topicFilter));
            }

            ps.setInt(index++, offset);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                q.setTopicId(rs.getObject("topic_id") != null ? rs.getInt("topic_id") : null);
                q.setStatus(rs.getString("status"));
                q.setMediaUrl(rs.getString("media_url"));
                list.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countApprovedQuestions(String topicFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Question WHERE status = 'approved'");
        if (topicFilter != null && !topicFilter.isEmpty()) {
            sql.append(" AND topic_id = ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (topicFilter != null && !topicFilter.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(topicFilter));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Question> getApprovedQuestionsPaged(String topicFilter, int offset, int pageSize) {
        List<Question> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM Question WHERE status = 'approved'");
        if (topicFilter != null && !topicFilter.isEmpty()) {
            sql.append(" AND topic_id = ?");
        }
        sql.append(" ORDER BY question_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (topicFilter != null && !topicFilter.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(topicFilter));
            }

            ps.setInt(index++, offset);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                q.setTopicId(rs.getObject("topic_id") != null ? rs.getInt("topic_id") : null);
                q.setStatus(rs.getString("status"));
                q.setMediaUrl(rs.getString("media_url"));
                list.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Question> getQuestionsByModule(int moduleId) {
        List<Question> list = new ArrayList<>();

        String sql = """
        SELECT q.*
        FROM ModuleQuestions mq
        JOIN Question q ON mq.question_id = q.question_id
        WHERE mq.module_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setContent(rs.getString("content"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                q.setTopicId(rs.getObject("topic_id") != null ? rs.getInt("topic_id") : null);
                q.setStatus(rs.getString("status"));
                q.setMediaUrl(rs.getString("media_url"));
                list.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
