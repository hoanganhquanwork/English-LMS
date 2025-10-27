package controller.report;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.entity.Users;
import model.entity.UserReport;
import service.ReportService;

@WebServlet("/reportList")
public class UserReportListController extends HttpServlet {

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        int userId = user.getUserId();
        int size = parseIntOrDefault(request.getParameter("size"), 10);
        int page = Math.max(parseIntOrDefault(request.getParameter("page"), 1), 1);

        int totalRows = reportService.countReportsByUser(userId);
        int totalPages = (int) Math.ceil(totalRows / (double) size);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<UserReport> reports = reportService.getReportsByUserPaged(userId, page, size);

        request.setAttribute("reports", reports);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/report/report_list.jsp").forward(request, response);
    }

    private static int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
