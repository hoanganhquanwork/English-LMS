/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.course.review;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.StudentProfile;
import model.entity.Users;
import service.ReviewService;
import util.ParseUtil;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ReviewActionServlet", urlPatterns = {"/reviewAction"})
public class ReviewActionServlet extends HttpServlet {

    private ReviewService reviewService = new ReviewService();

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
            out.println("<title>Servlet ReviewActionServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewActionServlet at " + request.getContextPath() + "</h1>");
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
        StudentProfile student = (StudentProfile) session.getAttribute("student");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int studentId = student.getUserId();
        String action = request.getParameter("action");
        Integer courseId = ParseUtil.parseIntOrNull(request.getParameter("courseId"));

        switch (action) {
            case "create": {
                Integer rating = ParseUtil.parseIntOrNull(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                if (rating != null) {
                    if (!reviewService.createReviewIfAllowed(courseId, studentId, rating, comment)) {
                        session.setAttribute("errorReview", "Tạo review thất bại");
                    }
                }
                break;
            }
            case "find": {
                Integer pageSize = ParseUtil.parseIntOrNull(request.getParameter("pageSize"));
                if (pageSize == null) {
                    pageSize = 5;
                }
                int myPage = reviewService.findMyPageReview(studentId, courseId, pageSize);
                session.setAttribute("myPage", myPage);
                break;
            }
            case "update": {
                Integer rating = ParseUtil.parseIntOrNull(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                if (rating != null) {
                    reviewService.editMyReview(courseId, studentId, rating, comment);
                }
                break;
            }
        }
        response.sendRedirect(request.getContextPath() + "/reviewCourse?courseId=" + courseId);
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
