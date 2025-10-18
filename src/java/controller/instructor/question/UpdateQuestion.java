/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.entity.Question;
import model.entity.QuestionOption;
import service.QuestionService;

/**
 *
 * @author Lenovo
 */
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

//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        int courseId = Integer.parseInt(request.getParameter("courseId"));
//        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
//
//        Map<Question, List<QuestionOption>> questionMap
//                = questionService.getQuestionsWithOptionsByModule(moduleId);
//
//        request.setAttribute("courseId", courseId);
//        request.setAttribute("moduleId", moduleId);
//        request.setAttribute("questionMap", questionMap);
//
//        request.getRequestDispatcher("teacher/view-questions.jsp").forward(request, response);
//    }

    private QuestionService questionService = new QuestionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String lessonIdStr = request.getParameter("lessonId");
            int questionId = Integer.parseInt(request.getParameter("questionId"));

            String questionText = request.getParameter("questionText");
            String explanation = request.getParameter("explanation");

            // Cập nhật Question
            Question q = new Question();
            q.setQuestionId(questionId);
            q.setContent(questionText);
            q.setExplanation(explanation);

            List<QuestionOption> options = new ArrayList<>();
            int i = 1;
            while (true) {
                String optContent = request.getParameter("optionContent_" + i);
                if (optContent == null) {
                    break;
                }
                if (optContent == null) {
                    break;
                }
                if (optContent.trim().isEmpty()) {
                    i++;
                    continue;
                }

                boolean isCorrect = false;
                String[] corrects = request.getParameterValues("correct");
                if (corrects != null) {
                    for (String c : corrects) {
                        if (Integer.parseInt(c) == i) {
                            isCorrect = true;
                            break;
                        }
                    }
                }

                QuestionOption opt = new QuestionOption();
                opt.setContent(optContent);
                opt.setCorrect(isCorrect);
                options.add(opt);
                i++;
            }

            boolean success = questionService.updateQuestionWithOptions(q, options);

            // Điều hướng theo loại câu hỏi (module hoặc lesson)
            if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
                response.sendRedirect("updateLesson?courseId=" + courseId + "&moduleId=" + moduleId
                        + "&lessonId=" + lessonIdStr + "&updateSuccess=" + (success ? "1" : "0"));
            } else {
                response.sendRedirect("ManageQuestionServlet?courseId=" + courseId
                        + "&moduleId=" + moduleId + "&updateSuccess=" + (success ? "1" : "0"));
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
