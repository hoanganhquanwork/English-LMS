package controller.parent.linking;

import service.ParentDashboardService;
import model.entity.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/parent/dashboard")
public class ParentDashboardController extends HttpServlet {

    private final ParentDashboardService service = new ParentDashboardService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Users user = (Users) session.getAttribute("user");

        if (user == null || !"Parent".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Map<String, Object> dashboard = service.buildDashboard(user);
        req.setAttribute("vm", dashboard);
        req.getRequestDispatcher("/parent/dashboard.jsp").forward(req, resp);
    }
}
