/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import service.AuthService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "ChangeManagerPassword", urlPatterns = {"/changeManagerPassword"})
public class ChangeManagerPassword extends HttpServlet {

    private final AuthService authService = new AuthService();

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
            out.println("<title>Servlet ChangeManagerPassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangeManagerPassword at " + request.getContextPath() + "</h1>");
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
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-internal.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"Manager".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/views-manager/manager-password.jsp").forward(request, response);
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

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login-internal");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (user == null || !"Manager".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("home");
            return;
        }

        boolean isOAuthUser = authService.isOAuthUser(user.getUserId());
        if (isOAuthUser) {
            request.setAttribute("errorOAuth", "Tài khoản OAuth (Google) không thể đổi mật khẩu trong hệ thống này.");
            request.getRequestDispatcher("/views-manager/manager-password.jsp").forward(request, response);
            return;
        }

        Users verify = authService.getUserByLogin(user.getUsername(), currentPassword);
        if (verify == null) {
            request.setAttribute("errorPassword", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("/views-manager/manager-password.jsp").forward(request, response);
            return;
        }

        int change = authService.updatePasswordByUserId(user.getUserId(), newPassword);
        if (change > 0) {
            request.setAttribute("successMessage", "Mật khẩu của bạn đã được đổi thành công!");
            request.getRequestDispatcher("/views-manager/manager-password.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Có lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/views-manager/manager-password.jsp").forward(request, response);
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
