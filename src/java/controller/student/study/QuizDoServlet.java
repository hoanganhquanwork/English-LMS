/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.study;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.ZoneId;
import model.dto.QuizAttemptDTO;
import model.dto.QuizDTO;
import model.entity.Users;
import service.QuizService;
import util.ParseUtil;
import static util.ParseUtil.parseIntOrNull;

/**
 *
 * @author Admin
 */
@WebServlet(name = "QuizDoServlet", urlPatterns = {"/doQuiz"})
public class QuizDoServlet extends HttpServlet {

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
            out.println("<title>Servlet QuizDoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizDoServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = user.getUserId();
        Integer courseId = parseIntOrNull(request.getParameter("courseId"));
        Integer itemId = parseIntOrNull(request.getParameter("itemId"));
        Long attemptId = ParseUtil.parseLongOrNull(request.getParameter("attemptId"));
        if (courseId == null || itemId == null || attemptId == null) {
            request.setAttribute("errorMessage", "Không xác được bài học hiện tại");
        }
        QuizAttemptDTO attempt = quizService.loadAttempt(attemptId);
        if (attempt == null) {
            request.setAttribute("errorMessage", "Không xác được bài học hiện tại");
        }
        if (attempt.getStudentId() != userId) {
            request.setAttribute("errorMessage", "Bạn không có quyền truy cập bài quiz này");
        }
        QuizDTO quiz = quizService.getQuizById(attempt.getQuizId());

        Long timeNow = System.currentTimeMillis();
        Long deadline = null;
        Long remain = null;
        if (attempt.getDeadlineAt() != null) {
            deadline = attempt.getDeadlineAt().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
            remain = Math.max(0L, deadline - timeNow);
        }

        boolean isGraded = (quiz.getPassingScorePct() != null);
        boolean isSubmitted = "submitted".equalsIgnoreCase(attempt.getStatus());

        request.setAttribute("quiz", quiz);
        request.setAttribute("attempt", attempt);
        request.setAttribute("courseId", courseId);
        request.setAttribute("itemId", itemId);

        request.setAttribute("isGraded", isGraded);
        request.setAttribute("isSubmitted", isSubmitted);
        request.setAttribute("timeNow", timeNow);
        request.setAttribute("deadlineTime", deadline);
        request.setAttribute("remainTime", remain);
        if (isGraded) {
            request.getRequestDispatcher("/course/quiz-grade.jsp").forward(request, response);

        } else {
            request.getRequestDispatcher("/course/quiz-practice.jsp").forward(request, response);
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long attemptId = ParseUtil.parseLongOrNull(request.getParameter("attemptId"));
        Integer courseId = ParseUtil.parseIntOrNull(request.getParameter("courseId"));
        Integer itemId = ParseUtil.parseIntOrNull(request.getParameter("itemId"));
        String action = request.getParameter("action");

        if (courseId == null || itemId == null || attemptId == null) {
            request.setAttribute("errorMessage", "Không xác được bài học hiện tại");
        }
        QuizAttemptDTO attempt = quizService.loadAttempt(attemptId);
        //for practice quiz
        QuizDTO quiz = quizService.getQuizById(attempt.getQuizId());
        boolean isGraded = (quiz.getPassingScorePct() != null);
        //
        boolean isDraft = "draft".equalsIgnoreCase(attempt.getStatus());
        if ("save".equalsIgnoreCase(action)) {
            if (isDraft) {
                quizService.saveDraftAnswer(attemptId, request.getParameterMap());
            }
            response.sendRedirect(request.getContextPath()
                    + "/doQuiz?attemptId=" + attemptId + "&courseId=" + courseId + "&itemId=" + itemId);
            return;
        }

        if ("submit".equalsIgnoreCase(action)) {
            //finalize thì không cần
            if (!isDraft) {
                if (isGraded) {
                    response.sendRedirect(request.getContextPath()
                            + "/coursePage?courseId=" + courseId + "&itemId=" + itemId);
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/doQuiz?attemptId=" + attemptId
                            + "&courseId=" + courseId + "&itemId=" + itemId);
                }
                return;
            }

            quizService.gradeAndSubmitAttempt(attemptId, request.getParameterMap());

            if (isGraded) {
                response.sendRedirect(request.getContextPath()
                        + "/coursePage?courseId=" + courseId + "&itemId=" + itemId);
            } else {
                //quay ve hien thi ket qua
                response.sendRedirect(request.getContextPath()
                        + "/doQuiz?attemptId=" + attemptId
                        + "&courseId=" + courseId + "&itemId=" + itemId);
            }
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
