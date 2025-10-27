package controller.admin.manage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.Users;
import service.AuthService;

@WebServlet("/adminCreateUsers")
public class AdminCreateUserServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Users current = (Users) req.getSession().getAttribute("user");
        if (current == null || !"Admin".equalsIgnoreCase(current.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/loginInternal");
            return;
        }
        req.getRequestDispatcher("/admin/admin_create_user.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Users current = (Users) req.getSession().getAttribute("user");
        if (current == null || !"Admin".equalsIgnoreCase(current.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/loginInternal");
            return;
        }

        String username = req.getParameter("username");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String gender   = req.getParameter("gender"); // nếu có trên form
        String role     = req.getParameter("role");   // Admin/Manager/Instructor/Student/Parent

        Users newUser = new Users();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(password); // hash ở AuthService.register()
        newUser.setGender(gender);
        newUser.setRole(role);

        String result = authService.register(newUser);
        switch (result) {
            case "success":
                req.setAttribute("success", "Tạo tài khoản thành công cho vai trò: " + role);
                // ở lại form → không redirect
                break;
            case "Email đã được sử dụng!":
            case "Tên đăng nhập tồn tại":
                req.setAttribute("error", result);
                // giữ lại input để user không phải gõ lại
                req.setAttribute("username", username);
                req.setAttribute("email", email);
                req.setAttribute("role", role);
                break;
            default:
                req.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
        }

        req.getRequestDispatcher("/admin/admin_create_user.jsp").forward(req, resp);
    }
}
