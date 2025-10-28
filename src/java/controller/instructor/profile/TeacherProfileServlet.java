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

@WebServlet(name = "TeacherProfileServlet", urlPatterns = {"/teacher-profile"})
public class TeacherProfileServlet extends HttpServlet {

    private final InstructorProfileService instructorProfileService = new InstructorProfileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null || !"Instructor".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            InstructorProfile instructorProfile = instructorProfileService.getInstructorProfile(user.getUserId());
            request.setAttribute("instructorProfile", instructorProfile);
            request.getRequestDispatcher("/teacher/teacher-profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải thông tin hồ sơ");
            request.getRequestDispatcher("/teacher/teacher-profile.jsp").forward(request, response);
        }
    }
}

