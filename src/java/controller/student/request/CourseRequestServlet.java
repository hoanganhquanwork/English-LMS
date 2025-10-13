/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.request;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.entity.CourseRequest;
import model.entity.StudentProfile;
import service.CourseRequestService;
import service.StudentRequestService;
import service.StudentService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CourseRequestServlet", urlPatterns = {"/courseRequest"})
public class CourseRequestServlet extends HttpServlet {

    private final StudentRequestService linkService = new StudentRequestService();
    private final CourseRequestService courseRequestService = new CourseRequestService();
    private final StudentService studentService = new StudentService();

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
            out.println("<title>Servlet CourseRequestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseRequestServlet at " + request.getContextPath() + "</h1>");
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
        StudentProfile student = (StudentProfile) session.getAttribute("student");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int studentId = student.getUserId();

        String error = (String) session.getAttribute("flash_error");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("flash_error");
        }
        //for parent link
        String linkStatus = linkService.getLatestStatus(studentId);
        request.setAttribute("requestStatus", linkStatus);
        String linkEmail = linkService.getLatestParentEmail(studentId);
        request.setAttribute("requestEmail", linkEmail);
        StudentProfile s = studentService.getStudentProfile(studentId);
        request.setAttribute("student", s);
        //for course request
        String status = request.getParameter("status");
        String sort = request.getParameter("sort");
        if (sort == null || sort.isBlank()) {
            sort = "created";
        }
        String keyword = request.getParameter("keyword");

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }
        int pageSize = 10;
        int total = courseRequestService.countCourseRequest(studentId, status, keyword);
        int totalPages = courseRequestService.computeTotalPage(total, pageSize);
        List<CourseRequest> listCourse = courseRequestService.getListCourseRequest(studentId, status, sort,
                keyword, page, pageSize);
        request.setAttribute("courses", listCourse);
        request.setAttribute("status", status);
        request.setAttribute("sort", sort);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("page", page);
        request.getRequestDispatcher("student/course-request.jsp").forward(request, response);
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
        //for parent link
        String linkStatus = linkService.getLatestStatus(studentId);
        request.setAttribute("requestStatus", linkStatus);
        String linkEmail = linkService.getLatestParentEmail(studentId);
        request.setAttribute("requestEmail", linkEmail);
        StudentProfile s = studentService.getStudentProfile(studentId);
        request.setAttribute("student", s);
        //for request action
        String requestIdRaw = request.getParameter("requestId");
        String requestAction = request.getParameter("requestAction");
        String note = request.getParameter("note");
        boolean ok = true;
        try {
            int requestId = Integer.parseInt(requestIdRaw);
            if ("resend".equalsIgnoreCase(requestAction)) {
                ok = courseRequestService.resendCourseRequest(requestId, studentId);
                if (!ok) {
                    request.setAttribute("errorMessage", "Có lỗi khi thực hiện hành động");
                }
            } else if ("cancel".equalsIgnoreCase(requestAction)) {
                ok = courseRequestService.cancelPendingRequest(requestId, studentId, note);
                if (!ok) {
                    request.setAttribute("errorMessage", "Có lỗi khi thực hiện hành động");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Có lỗi khi thực hiện hành đông");
            System.out.println(e);
        }

        //for course request
        String status = request.getParameter("status");
        String sort = request.getParameter("sort");
        if (sort == null || sort.isBlank()) {
            sort = "created";
        }
        String keyword = request.getParameter("keyword");
        int page;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }
        int pageSize = 10;
        int total = courseRequestService.countCourseRequest(studentId, status, keyword);
        int totalPages = courseRequestService.computeTotalPage(total, pageSize);
        List<CourseRequest> listCourse = courseRequestService.getListCourseRequest(studentId, status, sort,
                keyword, page, pageSize);
        request.setAttribute("courses", listCourse);
        request.setAttribute("status", status);
        request.setAttribute("sort", sort);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("page", page);
        request.getRequestDispatcher("student/course-request.jsp").forward(request, response);

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
