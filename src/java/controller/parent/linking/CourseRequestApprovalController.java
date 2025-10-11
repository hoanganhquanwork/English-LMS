package controller.parent.linking;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;
import model.entity.CourseRequest;
import model.entity.Users;
import service.CourseRequestService;

@WebServlet("/parent/approvals")
public class CourseRequestApprovalController extends HttpServlet {

    private final CourseRequestService service = new CourseRequestService();

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


        String status = request.getParameter("status"); 
        if(status==null) status = "pending";
        List<CourseRequest> requests = service.getRequests(parentId, status);
        Map<String, Integer> counts = service.getStatusCounts(parentId);

        request.setAttribute("requests", requests);
        request.setAttribute("counts", counts);
        request.setAttribute("selectedStatus", status == null ? "pending" : status);

        request.getRequestDispatcher("/parent/approvals.jsp").forward(request, response);
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String action = request.getParameter("action");
    int requestId = Integer.parseInt(request.getParameter("requestId"));
    String note = request.getParameter("note");

    boolean result = false;

    if ("approved".equals(action)) {
        result = service.parentCourseRequestAction(requestId,"approved");
    } else if ("rejected".equals(action)) {
        result = service.parentCourseRequestAction(requestId, "rejected");
        service.updateNoteForRequest(requestId, note);
    }

    if (result) {
        response.sendRedirect(request.getContextPath() + "/parent/approvals?status=pending");
    } else {
        request.setAttribute("error", "Xử lý thất bại!");
        doGet(request, response);
    }
}

}
