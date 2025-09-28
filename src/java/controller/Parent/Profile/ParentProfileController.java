package controller.Parent.Profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

import model.Users;
import model.ParentProfile;
import service.ParentProfileService;

public class ParentProfileController extends HttpServlet {

    private final ParentProfileService service = new ParentProfileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users parent = (Users) session.getAttribute("user");
        if (parent == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Integer parentId = parent.getUserId();
        String path = request.getServletPath();

        try {
            Users user = service.getUser(parentId);
            ParentProfile profile = service.getParentProfile(parentId);

            request.setAttribute("user", user);
            request.setAttribute("parent", profile);

            if (path.endsWith("/profile")) {
                request.getRequestDispatcher("/parent/profile.jsp").forward(request, response);
            } else if (path.endsWith("/settings")) {
                request.getRequestDispatcher("/parent/settings.jsp").forward(request, response);
            } else if (path.endsWith("/delete")) {
                request.getRequestDispatcher("/parent/delete.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

       HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users parent = (Users) session.getAttribute("user");
        if (parent == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Integer parentId = parent.getUserId();
        String path = request.getServletPath();

        try {
            if (path.endsWith("/settings")) {
                updateProfile(request, response, parentId);
            } else if (path.endsWith("/delete")) {
                deleteAccount(request, response, parentId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, Integer parentId)
            throws Exception {

        Users u = new Users();
        u.setUserId(parentId);
        u.setFullName(request.getParameter("full_name"));
        u.setEmail(request.getParameter("email"));
        u.setProfilePicture(request.getParameter("profile_picture"));
        u.setPhone(request.getParameter("phone"));
        u.setGender(request.getParameter("gender"));
        String dob = request.getParameter("date_of_birth");
        u.setDateOfBirth((dob == null || dob.isBlank()) ? null : LocalDate.parse(dob));

        ParentProfile p = new ParentProfile();
        p.setUserId(parentId);
        p.setAddress(request.getParameter("address"));
        p.setOccupation(request.getParameter("occupation"));

        try {
            service.updateProfile(u, p);
            response.sendRedirect(request.getContextPath() + "/parent/profile");
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("user", u);
            request.setAttribute("parent", p);
            request.getRequestDispatcher("/parent/settings.jsp").forward(request, response);
        }
    }

    private void deleteAccount(HttpServletRequest request, HttpServletResponse response, Integer parentId)
            throws Exception {

        String password = request.getParameter("password");
        boolean success = service.deleteAccount(parentId, password);

        if (success) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/parent/goodbye.jsp");
        } else {
            request.setAttribute("error", "Mật khẩu không đúng, vui lòng thử lại.");
            request.getRequestDispatcher("/parent/delete.jsp").forward(request, response);
        }
    }
}
