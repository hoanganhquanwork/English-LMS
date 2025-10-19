package controller.admin.profile;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import model.entity.Users;
import service.AdminProfileService;
import service.UserService;

@WebServlet("/admin/avatar")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class AdminAvatarController extends HttpServlet {

    private final AdminProfileService profileService = new AdminProfileService();
    private final UserService userService = new UserService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        boolean isUpload = profileService.updateAvatar(request, user);
        if (isUpload) {
            if (userService.updateProfilePicture(user)) {
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/admin/profile");
            } else {
                request.setAttribute("updateFail", "Cập nhật avatar thất bại");
                request.getRequestDispatcher("/parent/admin_profile.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("updateFail", "Tệp tải lên không hợp lệ");
            request.getRequestDispatcher("/parent/admin_profile.jsp").forward(request, response);
        }
    }

}
