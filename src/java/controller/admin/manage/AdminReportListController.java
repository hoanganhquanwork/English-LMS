package controller.admin.manage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.entity.Users;
import model.entity.UserReport;
import model.entity.ReportType;
import service.ReportService;

@WebServlet("/admin/report-list")
public class AdminReportListController extends HttpServlet {

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/loginInternal");
            return;
        }

        // --- Lấy tham số filter ---
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String typeIdStr = request.getParameter("typeId");
        Integer typeId = (typeIdStr != null && !typeIdStr.isBlank()) ? Integer.parseInt(typeIdStr) : null;

        int size = parseIntOrDefault(request.getParameter("size"), 10);
        int page = Math.max(parseIntOrDefault(request.getParameter("page"), 1), 1);

        // --- Tính tổng trang ---
        int totalRows = reportService.countAllReports(role, typeId, status);
        int totalPages = (int) Math.ceil(totalRows / (double) size);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<UserReport> reports = reportService.getAllReportsPaged(role, typeId, status, page, size);
        List<String> roles = reportService.getDistinctRoles();
        List<ReportType> reportTypes = reportService.getAllReportTypes();

        request.setAttribute("reports", reports);
        request.setAttribute("availableRoles", roles);
        request.setAttribute("availableTypes", reportTypes);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/report_list.jsp").forward(request, response);
    }

    private static int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }
}
