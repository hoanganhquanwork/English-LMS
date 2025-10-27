package service;

import dal.CourseDetailDAO;
import dal.QuestionDAO;
import java.util.*;
import model.dto.*;
import model.entity.*;
import service.QuestionManagerService;
import model.entity.Module;

public class CourseDetailService {

    private final CourseDetailDAO dao = new CourseDetailDAO();
    private final QuestionManagerService qService = new QuestionManagerService();

    public boolean isCourseValid(int courseId) {
        return courseId > 0 && dao.isCourseValid(courseId);
    }

    public Map<String, Object> getCourseDetail(int courseId) {
        Map<String, Object> data = new HashMap<>();

        try {
            if (courseId <= 0) {
                data.put("error", "Mã khóa học không hợp lệ.");
                return data;
            }
            if (!dao.isCourseValid(courseId)) {
                data.put("error", "Khóa học không tồn tại hoặc đã bị xóa.");
                return data;
            }

            List<Module> modules = dao.getModules(courseId);
            List<ModuleItemDetailDTO> items = dao.getModuleItems(courseId);
            List<QuestionDTO> questions = dao.getQuestionsByLesson(courseId);
            List<QuizDTO> quizzes = dao.getQuizzesWithQuestions(courseId);
            Map<String, Object> stats = dao.getStatistics(courseId);
            InstructorProfile instructor = dao.getInstructorInfo(courseId);

            if (modules == null) modules = new ArrayList<>();
            if (items == null) items = new ArrayList<>();
            if (questions == null) questions = new ArrayList<>();
            if (quizzes == null) quizzes = new ArrayList<>();
            if (stats == null) stats = new HashMap<>();
            if (instructor == null) instructor = new InstructorProfile();

            for (ModuleItemDetailDTO item : items) {
                if ("lesson".equalsIgnoreCase(item.getItemType())
                        && "video".equalsIgnoreCase(item.getContentType())
                        && item.getVideoUrl() != null
                        && item.getVideoUrl().contains("watch?v=")) {
                    item.setVideoUrl(item.getVideoUrl().replace("watch?v=", "embed/"));
                    List<QuestionDTO> lessonQuestions = dao.getQuestionsByLesson(courseId);
                    item.setLessonQuestions(lessonQuestions);
                }
            }

            Map<Integer, QuizDTO> quizMap = new HashMap<>();
            for (QuizDTO qz : quizzes) {
                quizMap.put(qz.getQuizId(), qz);
            }

            for (ModuleItemDetailDTO item : items) {
                String type = item.getItemType();

                if ("quiz".equalsIgnoreCase(type)) {
                    QuizDTO quiz = quizMap.get(item.getItemId());
                    if (quiz != null) {
                        item.setQuizTitle(quiz.getTitle());
                        item.setQuizPassingPct(quiz.getPassingScorePct());
                        item.setPickCount(quiz.getPickCount());
                        item.setTimeLimitMin(quiz.getTimeLimitMin());
                    }
                }

                if ("assignment".equalsIgnoreCase(type) && item.getAssignmentTitle() == null) {
                    AssignmentDetailDTO a = dao.getAssignmentDetail(item.getItemId());
                    if (a != null) {
                        item.setAssignmentTitle(a.getTitle());
                        item.setAssignmentContent(a.getContent());
                        item.setAssignmentInstructions(a.getInstructions());
                        item.setSubmissionType(a.getSubmissionType());
                        item.setAttachmentUrl(a.getAttachmentUrl());
                        item.setRubric(a.getRubric());
                        item.setAssignmentPassingPct(a.getPassingScorePct());
                        item.setMaxScore(a.getMaxScore());
                    }
                }
            }

            data.put("modules", modules);
            data.put("items", items);
            data.put("quizzes", quizzes);
            data.put("stats", stats);
            data.put("instructor", instructor);
            data.put("questions", questions);

        } catch (Exception e) {
            e.printStackTrace();
            data.put("error", "Đã xảy ra lỗi khi tải dữ liệu chi tiết khóa học.");
        }

        return data;
    }
}