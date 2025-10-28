/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
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
import java.util.List;
import java.util.Map;
import model.entity.ModuleItem;
import service.ModuleItemService;
import service.ModuleService;
import model.entity.Module;
import service.QuizService;
import model.dto.QuizDTO;
import model.entity.Quiz;

/**
 *
 * @author Lenovo
 */
public class UpdateQuiz extends HttpServlet {

    private ModuleService service = new ModuleService();
    private ModuleItemService contentService = new ModuleItemService();
    private QuizService quizService = new QuizService();

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
            out.println("<title>Servlet UpdateQuiz</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateQuiz at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int quizId = Integer.parseInt(request.getParameter("quizId"));

        try {
            // Lấy thông tin quiz
            Quiz quiz = quizService.getQuiz(quizId);
            if (quiz == null) {
                request.setAttribute("error", "Không tìm thấy quiz với ID: " + quizId);
                request.getRequestDispatcher("teacher/update-quiz.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin course content
            List<Module> list = service.getModulesByCourse(courseId);
            Map<Module, List<ModuleItem>> courseContent = contentService.getCourseContent(courseId);

            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("quizId", quizId);
            request.setAttribute("moduleList", list);
            request.setAttribute("content", courseContent);
            request.setAttribute("quiz", quiz);
            request.getRequestDispatcher("teacher/update-quiz.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải thông tin quiz: " + e.getMessage());
            request.getRequestDispatcher("teacher/update-quiz.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            String title = request.getParameter("title");

          
            String scoreStr = request.getParameter("passing_score_pct");
            String pickStr = request.getParameter("pick_count");
            String timeStr = request.getParameter("time_limit");

       
            Double score = (scoreStr == null || scoreStr.isEmpty()) ? null : Double.parseDouble(scoreStr);
            Integer pick = (pickStr == null || pickStr.isEmpty()) ? null : Integer.parseInt(pickStr);
            Integer timeLimit = (timeStr == null || timeStr.isEmpty()) ? null : Integer.parseInt(timeStr);

            // Cập nhật quiz
            boolean success = quizService.updateQuiz(quizId, title, score, pick, timeLimit);

            if (success) {
                request.setAttribute("success", "Cập nhật quiz thành công!");
                // Redirect để tránh resubmit
                response.sendRedirect("updateQuiz?courseId=" + courseId + "&moduleId=" + moduleId + "&quizId=" + quizId + "&success=1");
            } else {
                request.setAttribute("error", "Không thể cập nhật quiz. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật quiz: " + e.getMessage());
            doGet(request, response);
        }
    }
}
