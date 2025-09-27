package controller;

import model.Users;
import model.ParentProfile;
import service.ParentProfileService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

public class ParentProfileController extends HttpServlet {

    private final ParentProfileService service = new ParentProfileService();

    private static final boolean DEV_MODE = true; // 

    // Session thật
    private int ensureSession(HttpServletRequest request) throws ServletException {
        HttpSession ss = request.getSession(false);
        if (ss == null || ss.getAttribute("userId") == null) {
            throw new ServletException("Bạn chưa đăng nhập");
        }
        return (int) ss.getAttribute("userId");
    }

    // Mock session (dùng để test)
    private int ensureMockSession(HttpServletRequest request) {
        HttpSession ss = request.getSession();
        if (ss.getAttribute("userId") == null) {
            ss.setAttribute("userId", 5);
            ss.setAttribute("role", "Parent");
        }
        return (int) ss.getAttribute("userId");
    }

    private int ensureUser(HttpServletRequest request) throws ServletException {
        if (DEV_MODE) {
            return ensureMockSession(request);
        } else {
            return ensureSession(request);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int uid = ensureUser(request);

        Users user = service.getUser(uid);
        ParentProfile parent = service.getParentProfile(uid);

        request.setAttribute("user", user);
        request.setAttribute("parent", parent);

        String path = request.getServletPath();
        if (path.endsWith("/profile")) {
            request.getRequestDispatcher("/WEB-INF/views/parent/profile.jsp").forward(request, response);
        } else if (path.endsWith("/settings")) {
            request.getRequestDispatcher("/WEB-INF/views/parent/settings.jsp").forward(request, response);
        } else if (path.endsWith("/delete")) {
            request.getRequestDispatcher("/WEB-INF/views/parent/delete.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int uid = ensureUser(request);
        String path = request.getServletPath();

        if (path.endsWith("/settings")) {
            Users u = new Users();
            u.setUserId(uid);
            u.setFullName(request.getParameter("full_name"));
            u.setEmail(request.getParameter("email"));
            u.setProfilePicture(request.getParameter("profile_picture"));
            u.setPhone(request.getParameter("phone"));
            u.setGender(request.getParameter("gender"));
            String dob = request.getParameter("date_of_birth");
            u.setDateOfBirth((dob == null || dob.isBlank()) ? null : LocalDate.parse(dob));

            ParentProfile p = new ParentProfile();
            p.setUserId(uid);
            p.setAddress(request.getParameter("address"));
            p.setOccupation(request.getParameter("occupation"));

            try {
                service.updateProfile(u, p);
                response.sendRedirect(request.getContextPath() + "/parent/profile");
            } catch (IllegalArgumentException ex) {
                request.setAttribute("error", ex.getMessage());
                request.setAttribute("user", u);
                request.setAttribute("parent", p);
                request.getRequestDispatcher("/WEB-INF/views/parent/settings.jsp").forward(request, response);
            }
        } else if (path.endsWith("/delete")) {
            String password = request.getParameter("password");
            boolean success = service.deleteAccount(uid, password);
            if (success) {
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/goodbye.jsp");
            } else {
                request.setAttribute("error", "Mật khẩu không đúng, vui lòng thử lại.");
                request.getRequestDispatcher("/WEB-INF/views/parent/delete.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
