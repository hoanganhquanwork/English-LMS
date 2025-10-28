package controller.instructor.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.InstructorProfileService;
import model.entity.Users;

import java.io.IOException;
import service.StudentService;
import service.UserService;

@MultipartConfig
@WebServlet(name = "UpdateTeacherPictureProfileServlet", urlPatterns = {"/updateTeacherPictureProfile"})
public class UpdateTeacherPictureProfileServlet extends HttpServlet {

    private final InstructorProfileService instructorProfileService = new InstructorProfileService();
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");

        if (user == null || !"Instructor".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }

        try {
            boolean success = instructorProfileService.updateAvatar(request, user);

            if (success) {
                // Update user in database
                userService.updateProfilePicture(user);
                // Update session
                session.setAttribute("user", user);
                request.setAttribute("updateSuccess", "Cập nhật ảnh đại diện thành công!");
            } else {
                request.setAttribute("updateFail", "Có lỗi xảy ra khi cập nhật ảnh đại diện!");
            }

            // Redirect back to profile page
            response.sendRedirect("teacher-profile");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("updateFail", "Có lỗi xảy ra khi cập nhật ảnh đại diện!");
            request.getRequestDispatcher("/teacher/teacher-profile.jsp").forward(request, response);
        }
    }
}

