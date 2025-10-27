package controller.admin.manage;

import service.AdminUserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.Users;

@WebServlet("/AdminUserStatus")
public class AdminUserStatusServlet extends HttpServlet {

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
        String action = request.getParameter("action");

        if ("deactivate".equals(action)) {
            // Deactivate user
            userService.updateUserStatus(id, "deactivated");
        } else if ("activate".equals(action)) {
            // Activate user
            userService.updateUserStatus(id, "active");
        }

        response.sendRedirect(request.getContextPath() + "/AdminUserList");
    }
}
