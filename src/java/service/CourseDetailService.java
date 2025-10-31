package service;

import dal.CourseDetailDAO;
import java.util.*;
import model.dto.*;
import model.entity.*;
import model.entity.Module;

public class CourseDetailService {

    private final CourseDetailDAO dao = new CourseDetailDAO();

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

            if (modules == null) {
                modules = new ArrayList<>();
            }
            if (items == null) {
                items = new ArrayList<>();
            }
            if (questions == null) {
                questions = new ArrayList<>();
            }
            if (quizzes == null) {
                quizzes = new ArrayList<>();
            }
            if (stats == null) {
                stats = new HashMap<>();
            }
            if (instructor == null) {
                instructor = new InstructorProfile();
            }

            for (ModuleItemDetailDTO item : items) {
                if ("lesson".equalsIgnoreCase(item.getItemType())) {

                    if ("video".equalsIgnoreCase(item.getContentType())) {
                        String rawUrl = item.getVideoUrl();

                        if (rawUrl != null && !rawUrl.isBlank()) {
                            String videoId = null;

                            if (rawUrl.contains("watch?v=")) {
                                videoId = rawUrl.substring(rawUrl.indexOf("watch?v=") + 8);
                                int amp = videoId.indexOf("&");
                                if (amp > 0) {
                                    videoId = videoId.substring(0, amp);
                                }
                            } else if (rawUrl.contains("youtu.be/")) {
                                videoId = rawUrl.substring(rawUrl.lastIndexOf("/") + 1);
                            } else if (rawUrl.contains("embed/")) {
                                videoId = rawUrl.substring(rawUrl.lastIndexOf("/") + 1);
                            } else {
                                videoId = rawUrl.trim();
                            }
                            if (videoId != null && !videoId.isBlank()) {
                                item.setVideoUrl("https://www.youtube.com/embed/" + videoId);
                            }
                        }
                    }

                    List<QuestionDTO> lessonQuestions = new ArrayList<>();
                    for (QuestionDTO q : questions) {
                        if (q.getLessonId() == item.getItemId()) {
                            lessonQuestions.add(q);
                        }
                    }
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

                if ("assignment".equalsIgnoreCase(type) ) {
                    AssignmentDTO a = dao.getAssignmentDetail(item.getItemId());
                    if (a != null) {
                        item.setAssignmentTitle(a.getTitle());
                        item.setAssignmentContent(a.getContent());
                        item.setAssignmentInstructions(a.getInstructions());
                        item.setSubmissionType(a.getSubmissionType());
                        item.setAttachmentUrl(a.getAttachmentUrl());
                        item.setAssignmentPassingPct(a.getPassingScorePct());
                    }
                }
            }

            data.put(
                    "modules", modules);
            data.put(
                    "items", items);
            data.put(
                    "quizzes", quizzes);
            data.put(
                    "stats", stats);
            data.put(
                    "instructor", instructor);
            data.put(
                    "questions", questions);

        } catch (Exception e) {
            e.printStackTrace();
            data.put("error", "Đã xảy ra lỗi khi tải dữ liệu chi tiết khóa học.");
        }

        return data;
    }
}
