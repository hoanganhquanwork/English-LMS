/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.profile;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import service.AuthService;
import service.UserService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "DeactivateStudentAccount", urlPatterns = {"/deactiveStudentAccount"})
public class DeactivateStudentAccount extends HttpServlet {

    AuthService authService = new AuthService();
    UserService userService = new UserService();

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
            out.println("<title>Servlet DeactivateStudentAccount</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeactivateStudentAccount at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        String password = request.getParameter("password");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("home");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("home");
            return;
        }
        Users verify = authService.getUserByLogin(user.getUsername(), password);
        if (verify == null) {
            request.setAttribute("errorDeactiveMessage", "Mật khẩu hiện tại sai");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }
        int change = userService.deactivateAccount(user.getUserId());
        if (change > 0) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?deactiveSuccess=true");
            return;
        } else {
            request.setAttribute("errorDeactiveMessage", "Có lỗi xảy ra khi vô hiệu hóa tài khoản. Vui lòng thử lại.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
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
