/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import dal.InstructorProfileDAO;
import dal.ModuleDAO;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.ArrayList;
import java.util.List;
import model.entity.Question;
import model.entity.QuestionOption;
import model.entity.Module;
import java.io.*;
import java.nio.file.*;
import java.util.Map;
import model.entity.Course;
import model.entity.InstructorProfile;
import model.entity.QuestionTextKey;
import model.entity.Topic;
import model.entity.Users;
import service.CourseService;
import service.QuestionService;
import service.TopicService;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddQuestion extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddQuestion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddQuestion at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private CourseService courseService = new CourseService();
    private TopicService topicService = new TopicService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String topicFilter = request.getParameter("topicFilter");

        Course course = courseService.getCourseById(courseId);
        ModuleDAO mDao = new ModuleDAO();
        List<Module> modules = mDao.getModulesByCourse(courseId);

        List<Topic> topics = topicService.getAllTopics();

        int pageSize = 5;
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalApproved = questionService.countApprovedQuestions(topicFilter);
        int totalPages = (int) Math.ceil((double) totalApproved / pageSize);

        Map<Question, Object> approvedQuestionMap = questionService.getApprovedQuestionsWithAnswersPaged(topicFilter, currentPage, pageSize);

        request.setAttribute("course", course);
        request.setAttribute("moduleList", modules);
        request.setAttribute("topics", topics);
        request.setAttribute("approvedQuestionMap", approvedQuestionMap);
        request.setAttribute("selectedTopic", topicFilter);

        request.setAttribute("page", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("teacher/add-questions.jsp").forward(request, response);
    }

    private QuestionService questionService = new QuestionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String moduleId = request.getParameter("moduleId");
            String courseId = request.getParameter("courseId");
            String lessonIdStr = request.getParameter("lessonId");
            Integer lessonId = (lessonIdStr != null && !lessonIdStr.isEmpty())
                    ? Integer.parseInt(lessonIdStr) : null;

            String uploadDir = getServletContext().getRealPath("/uploads/questions");
            Files.createDirectories(Paths.get(uploadDir));

            int i = 1;
            while (true) {
                String text = request.getParameter("questionText" + i);
                if (text == null || text.isEmpty()) {
                    break;
                }

                String type = request.getParameter("questionType" + i);
                String explanation = request.getParameter("explanation" + i);

                Part filePart = request.getPart("file" + i);
                String fileUrl = null;
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName();
                    Path uploadPath = Paths.get(uploadDir, fileName);
                    filePart.write(uploadPath.toString());
                    fileUrl = "uploads/questions/" + fileName;
                }
                HttpSession session = request.getSession(false);
                Users user = (Users) session.getAttribute("user");
                if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("auth/login.jsp");
                    return;
                }
                InstructorProfileDAO instructorDAO = new InstructorProfileDAO();
                InstructorProfile instructor = instructorDAO.getByUserId(user.getUserId());

                Question q = new Question();
                q.setLessonId(lessonId);
                q.setContent(text);
                q.setType(type);
                q.setExplanation(explanation);
                q.setMediaUrl(fileUrl);
                if (lessonId != null) {
                    q.setStatus("submitted");
                } else {
                    q.setStatus("draft");
                }

                q.setTopicId(null);
                q.setCreatedBy(instructor);

                if ("mcq_single".equals(type)) {
                    List<QuestionOption> options = new ArrayList<>();

                    for (int j = 1; j <= 10; j++) {
                        String optContent = request.getParameter("optionContent" + i + "_" + j);
                        if (optContent == null || optContent.isEmpty()) {
                            continue;
                        }

                        boolean isCorrect = false;
                        String[] corrects = request.getParameterValues("correct" + i);
                        if (corrects != null) {
                            for (String c : corrects) {
                                if (Integer.parseInt(c) == j) {
                                    isCorrect = true;
                                    break;
                                }
                            }
                        }

                        QuestionOption opt = new QuestionOption();
                        opt.setContent(optContent);
                        opt.setCorrect(isCorrect);
                        options.add(opt);
                    }

                    questionService.addQuestionWithOptions(q, options);
                } else if ("text".equals(type)) {
                    String correctAnswer = request.getParameter("correctAnswer" + i);
                    if (correctAnswer != null && !correctAnswer.trim().isEmpty()) {
                        QuestionTextKey key = new QuestionTextKey();
                        key.setAnswerText(correctAnswer.trim());
                        questionService.addQuestionWithTextKey(q, key);
                    } else {

                        questionService.addQuestionWithTextKey(q, null);
                    }
                }

                i++;
            }
//            response.sendRedirect("questions?tab=questions");
            if (lessonId != null) {
                Integer module = (moduleId != null && !moduleId.isEmpty())
                        ? Integer.parseInt(moduleId) : null;
                response.sendRedirect("updateLesson?courseId=" + courseId
                        + "&lessonId=" + lessonId + "&moduleId=" + module);
            } else {
                response.sendRedirect("questions?tab=questions");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(" Lỗi khi thêm câu hỏi hàng loạt", e);
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
