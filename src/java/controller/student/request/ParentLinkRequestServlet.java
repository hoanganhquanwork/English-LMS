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
import model.entity.StudentProfile;
import service.StudentRequestService;
import service.StudentService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ParentLinkRequestServlet", urlPatterns = {"/parentLinkRequest"})
public class ParentLinkRequestServlet extends HttpServlet {

    private final StudentRequestService studentLinkService = new StudentRequestService();
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
        response.sendRedirect(request.getContextPath() + "/courseRequest");
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
        try {
            if ("link".equals(requestType)) {
                studentLinkService.createLinkRequest(studentId, parentEmail);
            } else if ("unlink".equals(requestType)) {
                if (studentLinkService.unlinkParentAccount(studentId)) {
//                    student.setParentId(null);
//                    session.setAttribute("student", student);
                } else {
                    session.setAttribute("flash_error", "Không thể hủy liên kết.");
                }
            } else if ("cancel".equals(requestType)) {
                studentLinkService.cancelPendingRequest(studentId);
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("flash_error", e.getMessage());
        } catch (IllegalStateException e) {
            session.setAttribute("flash_error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Có lỗi xảy ra. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/courseRequest");

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
