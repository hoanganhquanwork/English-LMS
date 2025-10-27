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
import java.util.List;
import model.dto.RatingSummaryDTO;
import model.dto.ReviewDTO;
import model.entity.StudentProfile;
import service.CourseService;
import service.ReviewService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CourseReviewServlet", urlPatterns = {"/reviewCourse"})
public class CourseReviewServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();
    private final CourseService courseService = new CourseService();

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
            out.println("<title>Servlet CourseReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseReviewServlet at " + request.getContextPath() + "</h1>");
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
        StudentProfile student = (session != null) ? (StudentProfile) session.getAttribute("student") : null;
        Integer studentId = (student != null) ? student.getUserId() : null;

        String courseIdRaw = request.getParameter("courseId");
        String starRaw = request.getParameter("star");
        String pageRaw = request.getParameter("page");
        String sizeRaw = request.getParameter("size");
        String keyword = request.getParameter("keyword");
        int courseId;
        try {
            courseId = Integer.parseInt(courseIdRaw);
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        Integer star = null;
        if (starRaw != null && !starRaw.isBlank()) {
            try {
                star = Integer.valueOf(starRaw);
            } catch (NumberFormatException ignore) {
            }
        }
        int page = 1;
        int pageSize = 5;
        try {
            page = Integer.parseInt(pageRaw);
        } catch (Exception ignore) {
        }
        if (page <= 0) {
            page = 1;
        }

        try {
            pageSize = Integer.parseInt(sizeRaw);
        } catch (Exception ignore) {
        }

        if (session != null) {
            Integer myPage = (Integer) session.getAttribute("myPage");
            if (myPage != null && myPage > 0) {
                page = myPage;
                session.removeAttribute("myPage");
            }
            Object error = session.getAttribute("errorReview");
            if (error != null) {
                request.setAttribute("errorReview", error);
                session.removeAttribute("errorReview");
            }
        }

        try {
            RatingSummaryDTO summary = reviewService.getRatingSummary(courseId);

            int total = reviewService.countByStars(courseId, star, keyword);
            int totalPages = (total == 0) ? 1 : (int) Math.ceil(total * 1.0 / pageSize);
            if (page > totalPages) {
                page = totalPages;
            }

            List<ReviewDTO> reviews = reviewService.getListReviewByStar(courseId, star, keyword, page, pageSize);

            String enrollmentStatus = null;
            if (studentId != null) {
                enrollmentStatus = courseService.getEnrollmentStatus(studentId, courseId);
                if ("completed".equalsIgnoreCase(enrollmentStatus)) {
                    boolean existReview = reviewService.existsReview(studentId, courseId);
                    request.setAttribute("existReview", existReview);
                }
            }
            request.setAttribute("keyword", keyword);
            request.setAttribute("courseId", courseId);
            request.setAttribute("summary", summary);
            request.setAttribute("reviews", reviews);
            request.setAttribute("selectedStar", star); // null = ALL
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("total", total);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("enrollmentStatus", enrollmentStatus);
            request.setAttribute("studentId", studentId);
            request.getRequestDispatcher("/course/course-review.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
        processRequest(request, response);
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
