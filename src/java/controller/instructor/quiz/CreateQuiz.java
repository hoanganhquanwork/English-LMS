/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.quiz;

import dal.ModuleItemDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.entity.ModuleItem;
import service.ModuleItemService;
import service.ModuleService;
import model.entity.Module;
import model.entity.Quiz;
import service.QuizService;

/**
 *
 * @author Lenovo
 */
public class CreateQuiz extends HttpServlet {

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
            out.println("<title>Servlet CreateQuiz</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateQuiz at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private ModuleService service = new ModuleService();
    private ModuleItemService contentService = new ModuleItemService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        try {
            List<Module> list = service.getModulesByCourse(courseId);
            Map<Module, List<ModuleItem>> courseContent = contentService.getCourseContent(courseId);

            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("moduleList", list);
            request.setAttribute("content", courseContent);
            request.getRequestDispatcher("teacher/create-quiz.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    private QuizService quizService = new QuizService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");

         
            String scoreStr = request.getParameter("passing_score_pct");
            String pickStr = request.getParameter("pickCount");
            String timeStr = request.getParameter("time_limit");

           
            Double score = (scoreStr == null || scoreStr.isEmpty()) ? null : Double.parseDouble(scoreStr);
            Integer pick = (pickStr == null || pickStr.isEmpty()) ? null : Integer.parseInt(pickStr);
            Integer timeLimit = (timeStr == null || timeStr.isEmpty()) ? null : Integer.parseInt(timeStr);

            int newQuizId = quizService.createQuiz(moduleId, title, score, pick, timeLimit);

            if (newQuizId != -1) {
                response.sendRedirect("updateQuiz?courseId=" + courseId + "&moduleId=" + moduleId + "&quizId=" + newQuizId);
            } else {
                request.setAttribute("error", "Không thể tạo quiz mới.");
                request.getRequestDispatcher("teacher/create-quiz.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi tạo quiz: " + e.getMessage(), e);
        }
    }
}
