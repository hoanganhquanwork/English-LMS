package controller.parent.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;
import service.StudentService;
import service.UserService;

@WebServlet(name = "ParentUpdatePictureController", urlPatterns = {"/parentUpdatePicture"})
@MultipartConfig
public class ParentAvatarController extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        Users user = (Users) session.getAttribute("user");

        // tái sử dụng hàm upload avatar sẵn có trong StudentService
        boolean isUpload = studentService.updateAvatar(request, user);

        if (isUpload) {
            if (userService.updateProfilePicture(user)) {
                // cập nhật lại session với ảnh mới
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/parentUpdateProfile");
            } else {
                request.setAttribute("updateFail", "Cập nhật ảnh đại diện thất bại.");
                request.getRequestDispatcher("/parent/updateProfile.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("updateFail", "Tệp tải lên không hợp lệ hoặc vượt quá dung lượng cho phép.");
            request.getRequestDispatcher("/parent/updateProfile.jsp").forward(request, response);
        }
    }
}
