package controller.admin.manage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.entity.ReportType;
import service.AdminReportTypeService;

@WebServlet("/AdminReportTypeList")
public class AdminReportTypeController extends HttpServlet {

    private final AdminReportTypeService service = new AdminReportTypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");

        int page = 1, size = 10;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("size") != null) size = Integer.parseInt(request.getParameter("size"));
        } catch (NumberFormatException ignored) {}

        List<ReportType> list = service.getPagedTypes(role, status, keyword, page, size);
        int totalPages = service.getTotalPages(role, status, keyword, size);

        request.setAttribute("reportTypes", list);
        request.setAttribute("roles", service.getAvailableRoles());
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/report_type_list.jsp").forward(request, response);
    }
}
