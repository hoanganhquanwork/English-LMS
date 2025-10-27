/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.entity.Question;
import model.entity.QuestionOption;
import model.entity.Topic;
import service.QuestionService;
import service.TopicService;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB - dung lượng tạm trong RAM
        maxFileSize = 1024 * 1024 * 50, // 50MB - dung lượng tối đa mỗi file
        maxRequestSize = 1024 * 1024 * 100 // 100MB - tổng dung lượng request
)
public class UpdateQuestion extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateQuestion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateQuestion at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private TopicService topicService = new TopicService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            Map<Question, Object> questionMap = questionService.getQuestionsByModuleWithAnswers(moduleId);
            List<Topic> topics = topicService.getAllTopics();

            request.setAttribute("topics", topics);

            request.setAttribute("questionMap", questionMap);
            request.setAttribute("courseId", courseId);
            request.getRequestDispatcher("teacher/view-questions.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }

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
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String questionText = request.getParameter("content");
            String explanation = request.getParameter("explanation");
            String type = request.getParameter("type");
            // Cập nhật Question
            Question q = new Question();
            q.setQuestionId(questionId);
            q.setContent(questionText);
            q.setExplanation(explanation);

            Part newFile = request.getPart("newFile");
            boolean deleteFile = Boolean.parseBoolean(request.getParameter("deleteFile"));
            String fileUrl = null;
            if (newFile != null && newFile.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_"
                        + Paths.get(newFile.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("/uploads/questions");
                Files.createDirectories(Paths.get(uploadDir));
                Path uploadPath = Paths.get(uploadDir, fileName);
                newFile.write(uploadPath.toString());
                fileUrl = "uploads/questions/" + fileName;
                q.setMediaUrl(fileUrl);
            } else if (deleteFile) {
                q.setMediaUrl(null);
            }
            boolean success = false;

            if ("mcq_single".equals(type)) {
               
                List<QuestionOption> options = new ArrayList<>();
                String[] corrects = request.getParameterValues("correct");

                for (int i = 1;; i++) {
                    String optContent = request.getParameter("optionContent_" + i);
                    if (optContent == null) {
                        break;
                    }
                    if (optContent.trim().isEmpty()) {
                        continue;
                    }

                    boolean isCorrect = false;
                    if (corrects != null) {
                        for (String c : corrects) {
                            if (c.equals(String.valueOf(i - 1))) {
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

                success = questionService.updateQuestionWithOptions(q, options);

            } else if ("text".equals(type)) {
               
                String correctAnswer = request.getParameter("correctAnswer");
                success = questionService.updateQuestionWithTextAnswer(q, correctAnswer);
            }

            // Điều hướng theo loại câu hỏi (module hoặc lesson)
            if (lessonId != null) {
                Integer module = (moduleId != null && !moduleId.isEmpty())
                        ? Integer.parseInt(moduleId) : null;
                response.sendRedirect("updateLesson?courseId=" + courseId
                        + "&lessonId=" + lessonId + "&moduleId=" + module);
            }else {
            response.sendRedirect("questions?tab=questions");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi cập nhật câu hỏi", e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
