package dal;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.dto.AssignmentWorkDTO;
import model.dto.DiscussionCommentDTO;
import model.dto.DiscussionPostDTO;
import model.dto.ModuleItemDetailDTO;
import model.dto.QuestionDTO;
import model.dto.QuestionOptionDTO;
import model.dto.QuizDTO;
import model.entity.Users;
import model.entity.InstructorProfile;
import model.entity.Module;

public class CourseDetailDAO extends DBContext {

    public boolean isCourseValid(int courseId) {
        String sql = "SELECT COUNT(*) FROM Course WHERE course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Module> getModules(int courseId) {
        List<Module> list = new ArrayList<>();
        String sql
                = "SELECT m.module_id, m.title, m.description, m.order_index "
                + "FROM Module m "
                + "WHERE m.course_id = ? "
                + "ORDER BY m.order_index";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Module m = new Module();
                m.setModuleId(rs.getInt("module_id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setOrderIndex(rs.getInt("order_index"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ModuleItemDetailDTO> getModuleItems(int courseId) {
        List<ModuleItemDetailDTO> list = new ArrayList<>();

        String sql = "SELECT "
                + " mi.module_item_id, mi.item_type, mi.order_index, "
                + " m.module_id, m.title AS module_title, "
                + " l.title AS lesson_title, l.content_type, l.video_url, l.text_content, l.duration_sec, "
                + " q.title AS quiz_title, q.attempts_allowed, q.passing_score_pct AS quiz_pass_pct, q.pick_count, "
                + " a.assignment_id, a.title AS assignment_title, a.submission_type, "
                + " a.max_score, a.passing_score_pct AS assign_pass_pct, "
                + " d.title AS discussion_title, d.description AS discussion_desc "
                + "FROM ModuleItem mi "
                + "JOIN Module m ON mi.module_id = m.module_id "
                + "LEFT JOIN Lesson l ON mi.module_item_id = l.lesson_id "
                + "LEFT JOIN Quiz q ON mi.module_item_id = q.quiz_id "
                + "LEFT JOIN Assignment a ON mi.module_item_id = a.assignment_id "
                + "LEFT JOIN Discussion d ON mi.module_item_id = d.discussion_id "
                + "WHERE m.course_id = ? "
                + "ORDER BY m.order_index, mi.order_index";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ModuleItemDetailDTO dto = new ModuleItemDetailDTO();
                dto.setModuleId(rs.getInt("module_id"));
                dto.setModuleTitle(rs.getString("module_title"));
                dto.setItemId(rs.getInt("module_item_id"));
                dto.setItemType(rs.getString("item_type"));
                dto.setOrderIndex(rs.getInt("order_index"));

                String type = rs.getString("item_type");
                if ("lesson".equalsIgnoreCase(type)) {
                    dto.setLessonTitle(rs.getString("lesson_title"));
                    dto.setContentType(rs.getString("content_type"));
                    dto.setVideoUrl(rs.getString("video_url"));
                    dto.setTextContent(rs.getString("text_content"));
                    Object dur = rs.getObject("duration_sec");
                    dto.setDurationSec(dur != null ? rs.getInt("duration_sec") : 0);
                } else if ("quiz".equalsIgnoreCase(type)) {
                    dto.setQuizTitle(rs.getString("quiz_title"));
                    dto.setAttemptsAllowed((Integer) rs.getObject("attempts_allowed"));
                    Object quizPass = rs.getObject("quiz_pass_pct");
                    dto.setQuizPassingPct(quizPass instanceof BigDecimal
                            ? ((BigDecimal) quizPass).doubleValue() : null);
                    dto.setPickCount((Integer) rs.getObject("pick_count"));
                } else if ("assignment".equalsIgnoreCase(type)) {
                    AssignmentWorkDTO assignment = getAssignmentDetail(rs.getInt("assignment_id"));
                    if (assignment != null) {
                        dto.setAssignmentTitle(assignment.getTitle());
                        dto.setSubmissionType(assignment.getSubmissionType());
                        dto.setMaxScore(assignment.getMaxScore());
                        dto.setAssignmentPassingPct(assignment.getPassingScorePct());
                        dto.setAssignmentContent(assignment.getContent());
                        dto.setAssignmentInstructions(assignment.getInstructions());
                        dto.setAttachmentUrl(assignment.getAttachmentUrl());
                        dto.setRubric(assignment.getRubric());
                    }
                } else if ("discussion".equalsIgnoreCase(type)) {
                    dto.setDiscussionTitle(rs.getString("discussion_title"));
                    dto.setDiscussionDescription(rs.getString("discussion_desc"));
                    dto.setDiscussionPosts(getDiscussionPosts(dto.getItemId()));
                }
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public AssignmentWorkDTO getAssignmentDetail(int assignmentId) {
        AssignmentWorkDTO dto = null;
        String sql = "SELECT assignment_id, title, content, instructions, "
                + "submission_type, attachment_url, max_score, passing_score_pct, rubric "
                + "FROM Assignment WHERE assignment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                dto = new AssignmentWorkDTO();
                dto.setAssignmentId(rs.getInt("assignment_id"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setInstructions(rs.getString("instructions"));
                dto.setSubmissionType(rs.getString("submission_type"));
                dto.setAttachmentUrl(rs.getString("attachment_url"));
                Object maxScore = rs.getObject("max_score");
                dto.setMaxScore(maxScore instanceof BigDecimal
                        ? ((BigDecimal) maxScore).doubleValue() : 0);
                Object passPct = rs.getObject("passing_score_pct");
                dto.setPassingScorePct(passPct instanceof BigDecimal
                        ? ((BigDecimal) passPct).doubleValue() : null);
                dto.setRubric(rs.getString("rubric"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dto;
    }

    public List<AssignmentWorkDTO> getAssignmentWorks(int assignmentId) {
        List<AssignmentWorkDTO> list = new ArrayList<>();
        String sql = "SELECT a.assignment_id, a.title, a.submission_type, "
                + "a.max_score, a.passing_score_pct "
                + "FROM Assignment a "
                + "WHERE a.assignment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AssignmentWorkDTO dto = new AssignmentWorkDTO();
                dto.setAssignmentId(rs.getInt("assignment_id"));
                dto.setTitle(rs.getString("title"));
                dto.setSubmissionType(rs.getString("submission_type"));
                Object maxScore = rs.getObject("max_score");
                dto.setMaxScore(maxScore instanceof BigDecimal
                        ? ((BigDecimal) maxScore).doubleValue() : 0);
                Object passPct = rs.getObject("passing_score_pct");
                dto.setPassingScorePct(passPct instanceof BigDecimal
                        ? ((BigDecimal) passPct).doubleValue() : null);
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DiscussionPostDTO> getDiscussionPosts(int discussionId) {
        List<DiscussionPostDTO> posts = new ArrayList<>();

        String sql = "SELECT dp.post_id, dp.content, dp.created_at, dp.edited_at, "
                + "u.full_name, u.role, u.profile_picture "
                + "FROM DiscussionPosts dp "
                + "JOIN Users u ON dp.author_user_id = u.user_id "
                + "WHERE dp.discussion_id = ? "
                + "ORDER BY dp.created_at ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, discussionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DiscussionPostDTO post = new DiscussionPostDTO();
                post.setPostId(rs.getLong("post_id"));
                post.setContent(rs.getString("content"));
                post.setCreatedAt(rs.getString("created_at"));
                post.setEditedAt(rs.getString("edited_at"));
                post.setFullName(rs.getString("full_name"));
                post.setRole(rs.getString("role"));
                post.setAvatar(rs.getString("profile_picture"));

                post.setComments(getDiscussionComments(post.getPostId()));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public List<DiscussionCommentDTO> getDiscussionComments(long postId) {
        List<DiscussionCommentDTO> comments = new ArrayList<>();
        String sql = "SELECT dc.comment_id, dc.content, dc.created_at, dc.edited_at, "
                + "u.full_name, u.role, u.profile_picture "
                + "FROM DiscussionComments dc "
                + "JOIN Users u ON dc.author_user_id = u.user_id "
                + "WHERE dc.post_id = ? "
                + "ORDER BY dc.created_at ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DiscussionCommentDTO c = new DiscussionCommentDTO();
                c.setCommentId(rs.getLong("comment_id"));
                c.setContent(rs.getString("content"));
                c.setCreatedAt(rs.getString("created_at"));
                c.setEditedAt(rs.getString("edited_at"));
                c.setFullName(rs.getString("full_name"));
                c.setRole(rs.getString("role"));
                c.setAvatar(rs.getString("profile_picture"));
                comments.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    public List<QuestionDTO> getQuestionsByLesson(int courseId) {
        List<QuestionDTO> list = new ArrayList<>();
        String sql
                = "SELECT q.question_id, q.lesson_id, q.content, q.media_url, q.type, q.explanation, "
                + "t.topic_id, t.name AS topic_name "
                + "FROM Question q "
                + "JOIN Lesson l ON q.lesson_id = l.lesson_id "
                + "JOIN ModuleItem mi ON l.lesson_id = mi.module_item_id "
                + "JOIN Module m ON mi.module_id = m.module_id "
                + "LEFT JOIN Topics t ON q.topic_id = t.topic_id "
                + "WHERE m.course_id = ? "
                + "ORDER BY m.order_index, l.lesson_id, q.question_id";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionDTO q = new QuestionDTO();
                q.setQuestionId(rs.getInt("question_id"));
                q.setLessonId(rs.getInt("lesson_id"));
                q.setContent(rs.getString("content"));
                q.setMediaUrl(rs.getString("media_url"));
                q.setType(rs.getString("type"));
                q.setExplanation(rs.getString("explanation"));
                list.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getStatistics(int courseId) {
        Map<String, Object> stats = new HashMap<>();
        String sql
                = "SELECT "
                + "(SELECT COUNT(*) FROM Module WHERE course_id = ?) AS moduleCount, "
                + "(SELECT COUNT(*) FROM Lesson l "
                + " JOIN ModuleItem mi ON l.lesson_id = mi.module_item_id "
                + " JOIN Module m ON mi.module_id = m.module_id "
                + " WHERE m.course_id = ?) AS lessonCount, "
                + "(SELECT COUNT(*) FROM Quiz q "
                + " JOIN ModuleItem mi ON q.quiz_id = mi.module_item_id "
                + " JOIN Module m ON mi.module_id = m.module_id "
                + " WHERE m.course_id = ?) AS quizCount, "
                + "(SELECT COUNT(*) FROM Assignment a "
                + " JOIN ModuleItem mi ON a.assignment_id = mi.module_item_id "
                + " JOIN Module m ON mi.module_id = m.module_id "
                + " WHERE m.course_id = ?) AS assignmentCount, "
                + "(SELECT COUNT(*) FROM Discussion d "
                + " JOIN ModuleItem mi ON d.discussion_id = mi.module_item_id "
                + " JOIN Module m ON mi.module_id = m.module_id "
                + " WHERE m.course_id = ?) AS discussionCount ";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 1; i <= 5; i++) {
                ps.setInt(i, courseId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("moduleCount", rs.getInt("moduleCount"));
                stats.put("lessonCount", rs.getInt("lessonCount"));
                stats.put("quizCount", rs.getInt("quizCount"));
                stats.put("assignmentCount", rs.getInt("assignmentCount"));
                stats.put("discussionCount", rs.getInt("discussionCount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public InstructorProfile getInstructorInfo(int courseId) {
        InstructorProfile instructor = null;
        String sql
                = "SELECT u.user_id, u.username, u.email, u.full_name, u.profile_picture, "
                + "u.gender, u.phone, u.role, u.status, "
                + "i.bio, i.expertise, i.qualifications "
                + "FROM Course c "
                + "JOIN InstructorProfile i ON c.created_by = i.user_id "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "WHERE c.course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setProfilePicture(rs.getString("profile_picture"));
                u.setGender(rs.getString("gender"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));

                instructor = new InstructorProfile();
                instructor.setUser(u);
                instructor.setBio(rs.getString("bio"));
                instructor.setExpertise(rs.getString("expertise"));
                instructor.setQualifications(rs.getString("qualifications"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return instructor;
    }

   public List<QuizDTO> getQuizzesWithQuestions(int courseId) {
    List<QuizDTO> quizzes = new ArrayList<>();

    String sql = "SELECT qz.quiz_id, mi.module_item_id, qz.title, qz.attempts_allowed, "
            + "qz.passing_score_pct, qz.pick_count, qz.time_limit_min, "  
            + "qu.question_id, qu.content AS question_content, qu.media_url, qu.type, qu.explanation, "
            + "qo.option_id, qo.content AS option_content, qo.is_correct "
            + "FROM Quiz qz "
            + "JOIN ModuleItem mi ON qz.quiz_id = mi.module_item_id "
            + "JOIN Module m ON mi.module_id = m.module_id "
            + "LEFT JOIN ModuleQuestions mq ON mq.module_id = m.module_id "
            + "LEFT JOIN Question qu ON mq.question_id = qu.question_id "
            + "LEFT JOIN QuestionOption qo ON qo.question_id = qu.question_id "
            + "WHERE m.course_id = ? "
            + "ORDER BY qz.quiz_id, qu.question_id, qo.option_id";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, courseId);
        ResultSet rs = ps.executeQuery();

        int lastQuizId = -1;
        int lastQuestionId = -1;
        QuizDTO currentQuiz = null;
        QuestionDTO currentQuestion = null;

        while (rs.next()) {
            int quizId = rs.getInt("quiz_id");

            if (quizId != lastQuizId) {
                currentQuiz = new QuizDTO();
                currentQuiz.setQuizId(quizId);
                currentQuiz.setModuleId(rs.getInt("module_item_id"));
                currentQuiz.setTitle(rs.getString("title"));
                currentQuiz.setAttemptsAllowed((Integer) rs.getObject("attempts_allowed"));

                BigDecimal passScore = rs.getBigDecimal("passing_score_pct");
                currentQuiz.setPassingScorePct(passScore != null ? passScore.doubleValue() : null);
                currentQuiz.setPickCount((Integer) rs.getObject("pick_count"));

                currentQuiz.setTimeLimitMin((Integer) rs.getObject("time_limit_min"));

                currentQuiz.setBank(new ArrayList<>());
                quizzes.add(currentQuiz);

                lastQuizId = quizId;
                lastQuestionId = -1;
            }

            int questionId = rs.getInt("question_id");
            if (questionId > 0) {
                if (questionId != lastQuestionId) {
                    currentQuestion = new QuestionDTO();
                    currentQuestion.setQuestionId(questionId);
                    currentQuestion.setContent(rs.getString("question_content"));
                    currentQuestion.setMediaUrl(rs.getString("media_url"));
                    currentQuestion.setType(rs.getString("type"));
                    currentQuestion.setExplanation(rs.getString("explanation"));
                    currentQuestion.setOptions(new ArrayList<>());
                    currentQuiz.getBank().add(currentQuestion);
                    lastQuestionId = questionId;
                }

                int optId = rs.getInt("option_id");
                if (optId > 0 && currentQuestion != null) {
                    QuestionOptionDTO opt = new QuestionOptionDTO();
                    opt.setOptionId(optId);
                    opt.setContent(rs.getString("option_content"));
                    opt.setIsCorrect(rs.getBoolean("is_correct"));
                    currentQuestion.getOptions().add(opt);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return quizzes;
}

}
