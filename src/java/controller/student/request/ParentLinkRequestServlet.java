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
import model.StudentProfile;
import service.StudentRequestService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ParentLinkRequestServlet", urlPatterns = {"/parentLinkRequest"})
public class ParentLinkRequestServlet extends HttpServlet {

    private final StudentRequestService service = new StudentRequestService();

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
            out.println("<title>Servlet ParentLinkRequestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ParentLinkRequestServlet at " + request.getContextPath() + "</h1>");
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
        String status = service.getLatestStatus(studentId);
        request.setAttribute("requestStatus", status);
        String email = service.getLatestParentEmail(studentId);
        request.setAttribute("requestEmail", email);
        request.getRequestDispatcher("student/course-request.jsp").forward(request, response);
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
        String parentEmail = request.getParameter("parentEmail");
        String requestType = request.getParameter("requestType");
        String message;
        try {
            if ("link".equals(requestType)) {
                service.createLinkRequest(studentId, parentEmail);
            } else if ("unlink".equals(requestType)) {
                if (service.unlinkParentAccount(studentId)){
                    student.setParentId(null);
                    session.setAttribute("student", student);
                }
            } else {
                service.cancelPendingRequest(studentId);
            }
        } catch (IllegalArgumentException e) {
            message = e.getMessage();
            request.setAttribute("messageRequest", message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        String status = service.getLatestStatus(studentId);
        request.setAttribute("requestStatus", status);
        String email = service.getLatestParentEmail(studentId);
        request.setAttribute("requestEmail", email);
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
