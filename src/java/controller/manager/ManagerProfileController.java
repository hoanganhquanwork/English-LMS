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
            response.sendRedirect(request.getContextPath() + "/loginInternal");
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

    HttpSession session = request.getSession(false);
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

    if (!oldUser.getFullName().equals(fullName)) changed = true;
    if (!oldUser.getEmail().equals(email)) changed = true;
    if (!oldUser.getDateOfBirth().toString().equals(dateOfBirth)) changed = true;
    if (!oldProfile.getPosition().equals(position)) changed = true;
    if (!oldProfile.getSpecialization().equals(specialization)) changed = true;

    if (!changed) {
        request.setAttribute("message", "No changes saved");
    } else {
        oldUser.setFullName(fullName);
        oldUser.setEmail(email);
        oldUser.setDateOfBirth(LocalDate.parse(dateOfBirth));
        oldProfile.setPosition(position);
        oldProfile.setSpecialization(specialization);

        managerService.updateUser(oldUser);
        managerService.updateProfile(oldProfile);

        request.setAttribute("message", "Update successful!");
    }

    request.setAttribute("user", oldUser);
    request.setAttribute("profile", oldProfile);

    request.getRequestDispatcher("/views-manager/manager-profile.jsp")
           .forward(request, response);
}
}
