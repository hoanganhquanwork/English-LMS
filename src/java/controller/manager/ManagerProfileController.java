package controller.manager;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.entity.ManagerProfile;
import model.entity.Users;
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
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginInternal");
            return;
        }
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/loginInternal");
            return;
        }

        int userId = currentUser.getUserId();
        ManagerProfile mp = managerService.getManagerProfile(userId);
        Users u = managerService.getUser(userId);
        request.setAttribute("today", java.time.LocalDate.now().toString());
        request.setAttribute("profile", mp);
        request.setAttribute("user", u);
        request.getSession().setAttribute("user", u);
        request.getRequestDispatcher("/views-manager/manager-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginInternal");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/loginInternal");
            return;
        }

        int userId = currentUser.getUserId();

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String position = request.getParameter("position");
        String specialization = request.getParameter("specialization");

        Users oldUser = managerService.getUser(userId);
        ManagerProfile oldProfile = managerService.getManagerProfile(userId);

        boolean changed = false;

        String oldFullName = oldUser.getFullName() == null ? "" : oldUser.getFullName();
        if (!oldFullName.equals(fullName)) {
            changed = true;
        }

        String oldEmail = oldUser.getEmail() == null ? "" : oldUser.getEmail();
        if (!oldEmail.equals(email)) {
            changed = true;
        }

        String oldDob = (oldUser.getDateOfBirth() == null) ? "" : oldUser.getDateOfBirth().toString();
        if (!oldDob.equals(dateOfBirth)) {
            changed = true;
        }

        String oldPosition = oldProfile.getPosition() == null ? "" : oldProfile.getPosition();
        if (!oldPosition.equals(position)) {
            changed = true;
        }

        String oldSpec = oldProfile.getSpecialization() == null ? "" : oldProfile.getSpecialization();
        if (!oldSpec.equals(specialization)) {
            changed = true;
        }
        if (!changed) {
            request.setAttribute("error", "No changes saved");
        } else {
            oldUser.setFullName(fullName);
            oldUser.setEmail(email);

            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                oldUser.setDateOfBirth(LocalDate.parse(dateOfBirth));
            } else {
                oldUser.setDateOfBirth(null);
            }

            oldProfile.setPosition(position);
            oldProfile.setSpecialization(specialization);

            managerService.updateUser(oldUser);
            managerService.updateProfile(oldProfile);

            request.setAttribute("message", "Update successful!");
        }

        request.setAttribute("today", java.time.LocalDate.now().toString());
        request.setAttribute("user", oldUser);
        request.setAttribute("profile", oldProfile);
        request.getRequestDispatcher("/views-manager/manager-profile.jsp").forward(request, response);
    }
}
