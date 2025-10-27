package controller.admin.profile;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import model.entity.Users;
import service.AdminProfileService;

@WebServlet("/admin/updateprofile")
@MultipartConfig
public class AdminUpdateProfileController extends HttpServlet {

    private final AdminProfileService profileService = new AdminProfileService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users admin = (Users) session.getAttribute("user");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("date_of_birth");

        // Cập nhật vào đối tượng
        admin.setFullName(fullName);
        admin.setPhone(phone);
        admin.setGender(gender);
        admin.setDateOfBirth((dob == null || dob.isBlank()) ? null : LocalDate.parse(dob));
        
        boolean success = profileService.updateProfile(admin);
        if (success) {
            session.setAttribute("user", admin);
            request.setAttribute("success", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("error", "Không thể cập nhật. Vui lòng thử lại!");
        }

        request.setAttribute("adminProfile", admin);
        request.getRequestDispatcher("/admin/admin_profile.jsp").forward(request, response);
    }
}
