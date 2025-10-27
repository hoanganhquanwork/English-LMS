package controller.report;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.Users;
import service.ReportService;

@WebServlet("/createReport")
public class ReportController extends HttpServlet {

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        String role = user.getRole();
        request.setAttribute("reportTypes", reportService.getReportTypesForRole(role));
        request.getRequestDispatcher("/report/create_request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        int reporterId = user.getUserId();
        int typeId = Integer.parseInt(request.getParameter("typeId"));
        String description = request.getParameter("description");
        String pageUrl = request.getParameter("pageUrl");

        boolean success = reportService.submitReport(reporterId, typeId, description, pageUrl);

        if (success) {
        response.sendRedirect(request.getContextPath() + "/reportList");
        } else {
            request.setAttribute("error", "⚠️ Nội dung không hợp lệ, vui lòng nhập lại.");
            request.setAttribute("reportTypes", reportService.getReportTypesForRole(user.getRole()));
            request.getRequestDispatcher("/report/create_request.jsp").forward(request, response);
        }
    }
}
