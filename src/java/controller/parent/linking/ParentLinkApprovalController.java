package controller.parent.linking;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.entity.ParentLinkRequest;
import model.entity.Users;
import service.ParentLinkApprovalService;

@WebServlet(name = "ParentLinkApprovalController", urlPatterns = {"/parentlinkstudent"})

public class ParentLinkApprovalController extends HttpServlet {

    private final ParentLinkApprovalService service = new ParentLinkApprovalService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users parent = (Users) session.getAttribute("user");
        int parentId = parent.getUserId();

        String filter = request.getParameter("filter");
        if (filter == null || filter.isEmpty()) {
            filter = "approved";
        }

        List<ParentLinkRequest> requests = new ArrayList<>();

        switch (filter) {
            case "approved":
                requests = service.getRequestsByStatus(parentId, "approved");
                break;
            case "closed": 
                requests.addAll(service.getRequestsByStatus(parentId, "rejected"));
                requests.addAll(service.getRequestsByStatus(parentId, "unlink"));
                break;
            default:
                requests = service.getRequestsByStatus(parentId, "pending");
                break;
        }

        int pendingCount = service.getRequestsByStatus(parentId, "pending").size();
        int approvedCount = service.getRequestsByStatus(parentId, "approved").size();
        int closedCount = service.getRequestsByStatus(parentId, "rejected").size()
                + service.getRequestsByStatus(parentId, "unlink").size();

        request.setAttribute("requests", requests);
        request.setAttribute("filter", filter);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("closedCount", closedCount);

        request.getRequestDispatcher("/parent/parent_link_approval.jsp").forward(request, response);
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    int requestId = Integer.parseInt(request.getParameter("requestId"));
    String note = request.getParameter("note");

    if ("approve".equalsIgnoreCase(action)) {
        service.approveRequest(requestId, note);
    } else if ("reject".equalsIgnoreCase(action)) {
        service.rejectRequest(requestId, note);
    } else if ("cancel".equalsIgnoreCase(action)) {
        service.cancelRequest(requestId, note);
    }

    response.sendRedirect(request.getContextPath() + "/parentlinkstudent");
}
}
