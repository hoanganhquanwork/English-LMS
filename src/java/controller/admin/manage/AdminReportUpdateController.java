package controller.admin.manage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.Users;
import service.ReportService;

@WebServlet("/admin/report-update")
public class AdminReportUpdateController extends HttpServlet {

    private final ReportService reportService = new ReportService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users admin = (session != null) ? (Users) session.getAttribute("user") : null;

        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        int reportId = Integer.parseInt(request.getParameter("reportId"));
        String status = request.getParameter("status");
        String adminNote = request.getParameter("adminNote");

        boolean success = reportService.updateReportStatus(reportId, status, adminNote);

        if (success) {
            request.getSession().setAttribute("flash", "✅ Cập nhật thành công!");
        } else {
            request.getSession().setAttribute("flash", "⚠️ Cập nhật thất bại, vui lòng thử lại!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/report-list");
    }
}
