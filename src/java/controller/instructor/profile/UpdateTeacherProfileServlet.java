package controller.instructor.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.InstructorProfileService;
import model.entity.InstructorProfile;
import model.entity.Users;

import java.io.IOException;
import java.time.LocalDate;
import service.UserService;

@WebServlet(name = "UpdateTeacherProfileServlet", urlPatterns = {"/updateTeacherProfile"})
public class UpdateTeacherProfileServlet extends HttpServlet {

    private final InstructorProfileService instructorProfileService = new InstructorProfileService();
     private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null || !"Instructor".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String dobRaw = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String bio = request.getParameter("bio");
        String expertise = request.getParameter("expertise");
        String qualifications = request.getParameter("qualifications");
        try {
            LocalDate dob = null;
            if (!dobRaw.isBlank()) {
                dob = LocalDate.parse(dobRaw);
            }

            boolean ok = instructorProfileService.updateAll(
                    user,
                    fullName,
                    phone,
                    dob,
                    gender,
                    bio,
                    expertise,
                    qualifications
            );

            // Update instructor profile
        

            if (ok) {
                user = userService.getUserById(user.getUserId());
                session.setAttribute("user", user);
                request.setAttribute("updateSuccess", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("updateFail", "Có lỗi xảy ra khi cập nhật thông tin!");
            }

            // Reload the profile page
            InstructorProfile updatedProfile = instructorProfileService.getInstructorProfile(user.getUserId());
            request.setAttribute("instructorProfile", updatedProfile);
            request.getRequestDispatcher("/teacher/teacher-profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("updateFail", "Có lỗi xảy ra khi cập nhật thông tin!");
            request.getRequestDispatcher("/teacher/teacher-profile.jsp").forward(request, response);
        }
    }
}

