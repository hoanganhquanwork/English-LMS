package controller.admin.manage;

import service.AdminUserService;
import model.entity.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminUserList")
public class AdminUserListServlet extends HttpServlet {

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
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        int size = parseIntOrDefault(request.getParameter("size"), 10);
        int page = Math.max(parseIntOrDefault(request.getParameter("page"), 1), 1);

        int totalRows = userService.countSearchUsers(keyword, role, status);
        int totalPages = (int) Math.ceil(totalRows / (double) size);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<Users> users = userService.searchUsersPaged(keyword, role, status, page, size);

        request.setAttribute("users", users);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("totalUsers", userService.countAllUsers());
        request.setAttribute("totalActiveUsers", userService.countUsersByStatus("active"));
        request.setAttribute("totalDeactivatedUsers", userService.countUsersByStatus("deactivated"));
        
        request.setAttribute("availableRoles", userService.getDistinctRoles());
        request.setAttribute("availableStatuses", userService.getDistinctStatuses());
        request.setAttribute("size", size);
        request.getRequestDispatcher("/admin/admin_dashboard.jsp").forward(request, response);
    }

    private static int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }
}
