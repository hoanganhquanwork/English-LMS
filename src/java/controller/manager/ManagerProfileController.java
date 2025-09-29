package controller.manager;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.ManagerProfile;
import model.Users;
import service.ManagerService;

@WebServlet(name = "ManagerProfileController", urlPatterns = {"/manager-profile"})
public class ManagerProfileController extends HttpServlet {

    private ManagerService managerService;

    @Override
    public void init() throws ServletException {
        managerService = new ManagerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = currentUser.getUserId();
        ManagerProfile mp = managerService.getManagerProfile(userId);
        Users u = managerService.getUser(userId);

        request.setAttribute("profile", mp);
        request.setAttribute("user", u);
        request.getSession().setAttribute("user", u);
        request.getRequestDispatcher("/views-manager/manager-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = currentUser.getUserId();

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String dobStr = request.getParameter("dateOfBirth");
        LocalDate dob = (dobStr != null && !dobStr.isEmpty()) ? LocalDate.parse(dobStr) : null;

        String position = request.getParameter("position");
        String specialization = request.getParameter("specialization");

        Users u = managerService.getUser(userId);
        u.setFullName(fullName);
        u.setEmail(email);
        u.setDateOfBirth(dob);
        boolean updatedUser = managerService.updateUser(u);

        ManagerProfile mp = new ManagerProfile();
        mp.setUserId(userId);
        mp.setPosition(position);
        mp.setSpecialization(specialization);
        boolean updatedProfile = managerService.updateProfile(mp);

        Users newUser = managerService.getUser(userId);
        ManagerProfile newProfile = managerService.getManagerProfile(userId);

        request.setAttribute("user", newUser);
        request.setAttribute("profile", newProfile);
        request.setAttribute("message", "Cập nhật thành công!");

        if (updatedUser || updatedProfile) {
            request.setAttribute("message", "Cập nhật thành công!");
        } else {
            request.setAttribute("error", "Không có thay đổi nào được lưu!");
        }
        request.getSession().setAttribute("user", newUser);

        request.getRequestDispatcher("/views-manager/manager-profile.jsp").forward(request, response);
    }
}
