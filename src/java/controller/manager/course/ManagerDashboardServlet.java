/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager.course;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.entity.Course;
import model.entity.Users;
import service.CourseManagerService;
import service.ManagerDashboardService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/dashboard-manager"})
public class ManagerDashboardServlet extends HttpServlet {

    private final ManagerDashboardService service = new ManagerDashboardService();
    private final CourseManagerService cService = new CourseManagerService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManagerDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManagerDashboardServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    Users manager = (Users) (session != null ? session.getAttribute("user") : null);

    if (manager == null || !"Manager".equalsIgnoreCase(manager.getRole())) {
        response.sendRedirect(request.getContextPath() + "/loginIternal");
        return;
    }

    int currentYear = java.time.LocalDate.now().getYear();
    request.setAttribute("currentYear", currentYear);
    request.setAttribute("totalCourses", service.getTotalCourses());
    request.setAttribute("totalInstructors", service.getTotalInstructor());
    request.setAttribute("pendingCourses", service.getPendingCourses());
    request.setAttribute("totalRevenue", service.getTotalRevenue());
    request.setAttribute("monthlyRevenue", service.getMonthlyRevenue(currentYear));

    List<String> statuses = new ArrayList<>();
    List<Integer> counts = new ArrayList<>();
    service.getCourseStatusCounts(statuses, counts);
    request.setAttribute("statusLabels", statuses);
    request.setAttribute("statusValues", counts);

 
    List<Course> approvedRejected = service.getApprovedOrRejectedCourses();
    List<String> createdDateList = new ArrayList<>();
    List<String> createdTimeList = new ArrayList<>();

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    for (Course c : approvedRejected) {
        if (c.getCreatedAt() != null) {
            createdDateList.add(c.getCreatedAt().format(dateFormatter));
            createdTimeList.add(c.getCreatedAt().format(timeFormatter));
        } else {
            createdDateList.add("N/A");
            createdTimeList.add("");
        }
    }
    request.setAttribute("approvedRejected", approvedRejected);
    request.setAttribute("createdDateList", createdDateList);
    request.setAttribute("createdTimeList", createdTimeList);

    List<Course> publishedUnpublished = service.getPublishedOrUnpublishedCourses();
    List<String> publishDateList = new ArrayList<>();

    for (Course c : publishedUnpublished) {
        if (c.getPublishAt() != null) {
            publishDateList.add(c.getPublishAt().format(dateFormatter));
        } else {
            publishDateList.add("—");
        }
    }
    request.setAttribute("publishedUnpublished", publishedUnpublished);
    request.setAttribute("publishDateList", publishDateList);

    request.setAttribute("topInstructors", null);


    request.getRequestDispatcher("/views-manager/dashboard-manager.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            session = request.getSession(true);
            session.setAttribute("errorMessage", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
            response.sendRedirect("loginInternal");
            return;
        }

        Users manager = (Users) session.getAttribute("user");
        if (manager == null || !"Manager".equalsIgnoreCase(manager.getRole())) {
            session.setAttribute("errorMessage", "Bạn không có quyền truy cập chức năng này.");
            response.sendRedirect("home");
            return;
        }

        Integer managerIdObj = (Integer) session.getAttribute("managerId");
        int managerId = (managerIdObj != null) ? managerIdObj : manager.getUserId();
        session.setAttribute("managerId", managerId);

        String action = request.getParameter("action");
        String idStr = request.getParameter("courseId");

        if (action == null || idStr == null || idStr.isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu tham số xử lý yêu cầu.");
            response.sendRedirect("dashboard-manager");
            return;
        }

        try {
            int courseId = Integer.parseInt(idStr);
            String message = null;

            switch (action) {
                case "approve":
                     cService.updateCourseStatus(courseId, "approved");
                    message = "Khóa học đã được duyệt thành công!";
                    break;

                case "reject": {
                    String reason = request.getParameter("rejectReason");
                    if (reason == null || reason.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Vui lòng nhập lý do từ chối!");
                    } else {
                        cService.rejectCourseWithReason(courseId, managerId, reason.trim());
                        message = "Khóa học đã bị từ chối và phản hồi đã được gửi cho giảng viên.";
                    }
                    break;
                }

                case "publish": {
                  cService.publishNow(courseId);
                    message = "Khóa học đã được lên lịch đăng thành công!";
                    break;
                }

                case "unpublish":
                    cService.unpublishCourse(courseId);
                    message = "Khóa học đã được gỡ đăng thành công.";
                    break;

                default:
                    session.setAttribute("errorMessage", "Hành động không hợp lệ: " + action);
                    break;
            }

            if (message != null) {
                session.setAttribute("message", message);
            }

            response.sendRedirect("dashboard-manager");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Định dạng mã khóa học không hợp lệ!");
            response.sendRedirect("dashboard-manager");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình xử lý yêu cầu!");
            response.sendRedirect("dashboard-manager");
        }
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
