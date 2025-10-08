package controller.parent.profile;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import model.ParentProfile;
import model.Users;
import service.ParentProfileService;
import service.UserService;

@WebServlet(name = "ParentUpdateProfileController", urlPatterns = {"/parentUpdateProfile"})
public class ParentUpdateProfileController extends HttpServlet {

    private final ParentProfileService parentProfileService = new ParentProfileService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        ParentProfile parent = parentProfileService.getParentProfile(user.getUserId());

        request.setAttribute("user", user);
        request.setAttribute("parent", parent);
        request.getRequestDispatcher("/parent/updateProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        Integer parentId = currentUser.getUserId();

        Users updatedUser = new Users();
        updatedUser.setUserId(parentId);
        updatedUser.setFullName(request.getParameter("full_name"));
        updatedUser.setEmail(request.getParameter("email"));
        updatedUser.setPhone(request.getParameter("phone"));
        updatedUser.setGender(request.getParameter("gender"));
        String dob = request.getParameter("date_of_birth");
        updatedUser.setDateOfBirth((dob == null || dob.isBlank()) ? null : LocalDate.parse(dob));

        updatedUser.setProfilePicture(currentUser.getProfilePicture());

        ParentProfile updatedParent = new ParentProfile();
        updatedParent.setUserId(parentId);
        updatedParent.setAddress(request.getParameter("address"));
        updatedParent.setOccupation(request.getParameter("occupation"));

        try {
            parentProfileService.updateProfile(updatedUser, updatedParent);

            Users refreshedUser = userService.getUserById(parentId);
            session.setAttribute("user", refreshedUser);

            response.sendRedirect(request.getContextPath() + "/parent/profile");

        } catch (IllegalArgumentException ex) {
            request.setAttribute("updateFail", ex.getMessage());
            request.setAttribute("user", updatedUser);
            request.setAttribute("parent", updatedParent);
            request.getRequestDispatcher("/parent/updateProfile.jsp").forward(request, response);
        }
    }
}
