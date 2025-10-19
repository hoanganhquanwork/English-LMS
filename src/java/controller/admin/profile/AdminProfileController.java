package controller.admin.profile;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.entity.Users;
import service.AdminProfileService;

@WebServlet("/admin/profile")
public class AdminProfileController extends HttpServlet {

    private final AdminProfileService profileService = new AdminProfileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users admin = (Users) session.getAttribute("user");

        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("adminProfile", profileService.getProfile(admin.getUserId()));
        request.getRequestDispatcher("/admin/admin_profile.jsp").forward(request, response);
    }
}
