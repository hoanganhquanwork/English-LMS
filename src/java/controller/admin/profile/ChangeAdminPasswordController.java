package controller.admin.profile;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import service.AuthService;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/admin/changePassword"})
public class ChangeAdminPasswordController extends HttpServlet {

    AuthService authService = new AuthService();

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            request.getRequestDispatcher("/admin/change_password.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

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

        Users verify = authService.getUserByLogin(user.getUsername(), currentPassword);
        if (verify == null) {
            request.setAttribute("errorPassword", "Mật khẩu hiện tại sai");
            request.getRequestDispatcher("/admin/change_password.jsp").forward(request, response);
            return;
        }
        int change = authService.updatePasswordByUserId(user.getUserId(), newPassword);
        if (change > 0) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/auth/login-internal.jsp?resetSuccess=true");
            return;
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/admin/change_password.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
