package controller.admin.manage;

import service.AdminUserService;
import model.entity.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminUserEdit")
public class AdminUserEditServlet extends HttpServlet {

    private final AdminUserService userService = new AdminUserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-internal.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String idStr = request.getParameter("id");
        int id = Integer.parseInt(idStr);
        user = userService.getUserById(id);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-internal.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String idStr = request.getParameter("id");
        int id = Integer.parseInt(idStr);

        java.sql.Date dob = null;
        try {
            String dobStr = request.getParameter("date_of_birth");
            if (dobStr != null && !dobStr.isBlank()) {
                dob = java.sql.Date.valueOf(dobStr.trim());
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        userService.updateUser(
                id,
                request.getParameter("username"),
                request.getParameter("email"),
                request.getParameter("role"),
                request.getParameter("status"),
                request.getParameter("phone"),
                dob,
                request.getParameter("gender")
        );

        response.sendRedirect(request.getContextPath() + "/AdminUserList");
    }
}
