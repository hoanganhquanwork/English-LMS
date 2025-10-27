package controller.admin.manage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.Users;
import service.AdminReportTypeService;

@WebServlet("/AdminReportTypeStatus")
public class ReportTypeStatusController extends HttpServlet {

    private final AdminReportTypeService service = new AdminReportTypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-internal.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String idStr = request.getParameter("id");
        String action = request.getParameter("action");
        if (idStr != null && action != null) {
            int id = Integer.parseInt(idStr);
            service.changeStatus(id, action);
        }
        response.sendRedirect(request.getContextPath() + "/AdminReportTypeList");
    }
}
