package controller.admin.manage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.UserReport;
import model.entity.Users;
import service.ReportService;

@WebServlet("/admin/report-detail")
public class AdminReportDetailController extends HttpServlet {

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users admin = (session != null) ? (Users) session.getAttribute("user") : null;

        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        int reportId = Integer.parseInt(request.getParameter("id"));
        UserReport report = reportService.getReportDetail(reportId);

        if (report == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("report", report);
        request.getRequestDispatcher("/admin/report_detail.jsp").forward(request, response);
    }
}
