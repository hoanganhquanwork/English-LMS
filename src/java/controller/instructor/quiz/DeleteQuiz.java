/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.instructor.quiz;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.QuizService;

/**
 *
 * @author Lenovo
 */
@WebServlet( urlPatterns = {"/deleteQuiz"})
public class DeleteQuiz extends HttpServlet {

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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int quizId = Integer.parseInt(request.getParameter("quizId"));

            boolean deleted = quizService.deleteQuiz(quizId);

            if (deleted) {
                response.sendRedirect("manageQuizServlet?courseId=" + courseId + "&moduleId=" + moduleId + "&deleted=true");
            } else {
                request.setAttribute("error", "Không thể xóa quiz.");
                request.getRequestDispatcher("updateQuiz.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi xóa quiz: " + e.getMessage(), e);
        }
    }
}

