package controller.parent.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

import model.entity.Users;
import model.entity.ParentProfile;
import service.AuthService;
import service.ParentProfileService;
import service.UserService;

public class ParentProfileController extends HttpServlet {
    AuthService authService = new AuthService();
    UserService userService = new UserService();
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
            } else if (path.endsWith("/updateProfile")) {
                request.getRequestDispatcher("/parent/updateProfile.jsp").forward(request, response);
            } else if (path.endsWith("/deactiveAccount")) {
                request.getRequestDispatcher("/parent/deactiveAccount.jsp").forward(request, response);
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
            if (path.endsWith("/updateProfile")) {
                updateProfile(request, response, parentId);
            } else if (path.endsWith("/deactiveAccount")) {
                deactiveAccount(request, response, parentId);
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
            request.getRequestDispatcher("/parent/updateProfile.jsp").forward(request, response);
        }
    }

    private void deactiveAccount(HttpServletRequest request, HttpServletResponse response, Integer parentId)
            throws Exception {

        String password = request.getParameter("password");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("home");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("home");
            return;
        }
        Users verify = authService.getUserByLogin(user.getUsername(), password);
        if (verify == null) {
            request.setAttribute("error", "Mật khẩu hiện tại sai");
            request.getRequestDispatcher("/parent/deactiveAccount.jsp").forward(request, response);
            return;
        }
        int change = userService.deactivateAccount(user.getUserId());
        if (change > 0) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?deactiveSuccess=true");
            return;
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi vô hiệu hóa tài khoản. Vui lòng thử lại.");
            request.getRequestDispatcher("/parent/deactiveAccount.jsp").forward(request, response);
        }
    }
}
