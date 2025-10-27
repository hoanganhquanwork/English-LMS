package controller.admin.manage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.entity.ReportType;
import model.entity.Users;
import service.AdminReportTypeService;

@WebServlet("/AdminReportTypeEdit")
public class ReportTypeEditController extends HttpServlet {

    private final AdminReportTypeService service = new AdminReportTypeService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        String idStr = request.getParameter("typeId");
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        boolean isActive = request.getParameter("isActive") != null;

        ReportType t = new ReportType();
        if (idStr != null && !idStr.isEmpty()) {
            t.setTypeId(Integer.parseInt(idStr));
        }
        t.setName(name);
        t.setRole(role);
        t.setActive(isActive);

        boolean ok = service.save(t);
        session.setAttribute("flash", ok ? "✅ Lưu thành công!" : "⚠️ Lưu thất bại!");
        response.sendRedirect(request.getContextPath() + "/AdminReportTypeList");
    }
}
