package service;

import dal.CourseDetailDAO;
import java.util.*;
import model.dto.AssignmentWorkDTO;
import model.entity.InstructorProfile;
import model.dto.ModuleItemDetailDTO;
import model.dto.QuestionDTO;
import model.dto.QuizDTO;
import model.entity.Module;

public class CourseDetailService {

    private final CourseDetailDAO dao = new CourseDetailDAO();

    public boolean isCourseValid(int courseId) {
        return courseId > 0 && dao.isCourseValid(courseId);
    }

    public Map<String, Object> getCourseDetail(int courseId) {
        Map<String, Object> data = new HashMap<>();

        if (courseId <= 0) {
            data.put("error", "Mã khóa học không hợp lệ.");
            return data;
        }
        if (!dao.isCourseValid(courseId)) {
            data.put("error", "Khóa học không tồn tại hoặc đã bị xóa.");
            return data;
        }

        try {

            List<Module> modules = dao.getModules(courseId);
            List<ModuleItemDetailDTO> items = dao.getModuleItems(courseId);
            if (modules == null) {
                modules = new ArrayList<>();
            }
            if (items == null) {
                items = new ArrayList<>();
            }

            List<QuestionDTO> questions = dao.getQuestionsByLesson(courseId);
            if (questions == null) {
                questions = new ArrayList<>();
            }

            List<QuizDTO> quizzes = dao.getQuizzesWithQuestions(courseId);
            if (quizzes == null) {
                quizzes = new ArrayList<>();
            }

            Map<String, Object> stats = dao.getStatistics(courseId);
            if (stats == null) {
                stats = new HashMap<>();
            }

            InstructorProfile instructor = dao.getInstructorInfo(courseId);
            if (instructor == null) {
                instructor = new InstructorProfile();
            }

            for (ModuleItemDetailDTO item : items) {
                if ("lesson".equalsIgnoreCase(item.getItemType())
                        && "video".equalsIgnoreCase(item.getContentType())
                        && item.getVideoUrl() != null
                        && item.getVideoUrl().contains("watch?v=")) {
                    item.setVideoUrl(item.getVideoUrl().replace("watch?v=", "embed/"));
                }
            }

            for (ModuleItemDetailDTO item : items) {
                if ("quiz".equalsIgnoreCase(item.getItemType())) {
                    for (QuizDTO qz : quizzes) {
                        if (qz.getQuizId() == item.getItemId()) {
                            item.setQuizQuestions(qz.getBank());
                            break;
                        }
                    }
                }
            }

            for (ModuleItemDetailDTO item : items) {
                if ("assignment".equalsIgnoreCase(item.getItemType())) {
                    AssignmentWorkDTO detail = dao.getAssignmentDetail(item.getItemId());
                    if (detail != null) {
                        item.setAssignmentTitle(detail.getTitle());
                        item.setSubmissionType(detail.getSubmissionType());
                        item.setMaxScore(detail.getMaxScore());
                        item.setAssignmentPassingPct(detail.getPassingScorePct());
                        item.setAssignmentContent(detail.getContent());
                        item.setAssignmentInstructions(detail.getInstructions());
                        item.setAttachmentUrl(detail.getAttachmentUrl());
                        item.setRubric(detail.getRubric());
                    }
                }
            }

            data.put("modules", modules);
            data.put("items", items);
            data.put("questions", questions);
            data.put("quizzes", quizzes);
            data.put("stats", stats);
            data.put("instructor", instructor);

        } catch (Exception e) {
            e.printStackTrace();
            data.put("error", "Lỗi khi tải dữ liệu chi tiết khóa học: " + e.getMessage());
        }

        return data;
    }

    public List<QuizDTO> getQuizzesWithQuestions(int courseId) {
        return dao.getQuizzesWithQuestions(courseId);
    }

}
