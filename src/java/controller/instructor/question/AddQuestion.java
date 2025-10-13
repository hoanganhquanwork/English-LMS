/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import dal.ModuleDAO;
import dal.QuestionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.entity.Question;
import model.entity.QuestionOption;
import model.entity.Module;
import java.sql.*;
import model.entity.Course;
import service.CourseService;
import service.QuestionService;

/**
 *
 * @author Lenovo
 */
public class AddQuestion extends HttpServlet {

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
            out.println("<title>Servlet AddQuestion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddQuestion at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
     private CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Course course = courseService.getCourseById(courseId);
        ModuleDAO mDao = new ModuleDAO();
        List<Module> modules = mDao.getModulesByCourse(courseId);
        request.setAttribute("moduleList", modules);
        request.setAttribute("course", course);
        request.getRequestDispatcher("teacher/add-questions.jsp").forward(request, response);
    }

    private QuestionService questionService = new QuestionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String courseId = request.getParameter("courseId");
            String lessonIdStr = request.getParameter("lessonId");
            Integer lessonId = null;
            if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
                lessonId = Integer.parseInt(lessonIdStr);
            }

            int i = 1;
            while (true) {
                String text = request.getParameter("questionText" + i);
                if (text == null || text.isEmpty()) {
                    break;
                }

                String type = request.getParameter("questionType" + i);
                String explanation = request.getParameter("explanation" + i);
                System.out.println("===> Câu " + i + " có explanation: " + explanation);

                Question q = new Question();
                q.setModuleId(moduleId);
                q.setLessonId(lessonId);
                q.setContent(text);
                q.setType(type);
                q.setExplanation(explanation);

                List<QuestionOption> options = new ArrayList<>();
                for (int j = 1; j <= 10; j++) {
                    String content = request.getParameter("optionContent" + i + "_" + j);
                    if (content == null || content.isEmpty()) {
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
                    opt.setContent(content);
                    opt.setCorrect(isCorrect);
                    options.add(opt);
                }

                questionService.addQuestionWithOptions(q, options);
                i++;
            }

            if (lessonId != null) {
                response.sendRedirect("updateLesson?courseId=" + request.getParameter("courseId")
                        + "&moduleId=" + moduleId
                        + "&lessonId=" + lessonId
                        );
            } else {
                response.sendRedirect("ManageQuestionServlet?moduleId=" + moduleId );
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi khi thêm câu hỏi hàng loạt", e);
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
