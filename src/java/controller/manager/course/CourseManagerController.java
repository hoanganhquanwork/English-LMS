package controller.manager.course;

import controller.manager.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Course;
import service.CourseManagerService;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.entity.Users;

@WebServlet(name = "CourseManagerServlet", urlPatterns = {"/coursemanager"})
public class CourseManagerController extends HttpServlet {

    private final CourseManagerService courseService = new CourseManagerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        if (status == null) {
            status = "all";
        }
        if (sort == null) {
            sort = "newest";
        }
        if (keyword == null) {
            keyword = "";
        }
        
        List<Course> courseList = courseService.getFilteredCourses(status, keyword, sort);

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

        List<String> createdDateList = new ArrayList<>();
        List<String> createdTimeList = new ArrayList<>();

        for (Course course : courseList) {
            if (course.getCreatedAt() != null) {
                createdDateList.add(course.getCreatedAt().format(dateFormatter));
                createdTimeList.add(course.getCreatedAt().format(timeFormatter));
            } else {
                createdDateList.add("N/A");
                createdTimeList.add("");
            }
        }

        if (!keyword.isEmpty() && courseList.isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy khóa học nào khớp với từ khóa: " + keyword);
        }

        request.setAttribute("courseList", courseList);
        request.setAttribute("createdDateList", createdDateList);
        request.setAttribute("createdTimeList", createdTimeList);
        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect("coursemanager");
            return;
        }

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        String redirectUrl = "coursemanager?status=" + (status != null ? status : "all")
                + "&keyword=" + (keyword != null ? URLEncoder.encode(keyword, "UTF-8") : "")
                + "&sort=" + (sort != null ? sort : "newest");

        Users manager = (Users) session.getAttribute("user");
        if (manager == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect("loginInternal");
            return;
        }

        try {
            switch (action) {
                case "approve":
                case "bulkApprove": {
                    String[] courseIds = request.getParameterValues("courseIds");
                    if (courseIds == null || courseIds.length == 0) {
                        session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một khóa học!");
                        break;
                    }
                    for (String id : courseIds) {
                        courseService.updateCourseStatus(Integer.parseInt(id), "approved");
                    }
                    session.setAttribute("message", "Đã duyệt thành công " + courseIds.length + " khóa học.");
                    break;
                }

                case "reject": {
                    String idStr = request.getParameter("courseIds");
                    String reason = request.getParameter("rejectReason");

                    if (idStr == null || idStr.isBlank()) {
                        session.setAttribute("errorMessage", "Thiếu mã khóa học để từ chối!");
                        break;
                    }
                    if (reason == null || reason.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Vui lòng nhập lý do từ chối.");
                        break;
                    }
                    
                    int courseId = Integer.parseInt(idStr);
                    boolean success = courseService.rejectCourseWithReason(courseId, manager.getUserId(), reason);
                    if (success) {
                        session.setAttribute("message", "Đã từ chối khóa học thành công!");
                    } else {
                        session.setAttribute("errorMessage", "Không thể cập nhật lý do từ chối.");
                    }
                    break;
                }

                case "bulkReject": {
                    String reason = request.getParameter("rejectReason");
                    String idsRaw = request.getParameter("courseIds");

                    if (reason == null || reason.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Vui lòng nhập lý do từ chối.");
                        break;
                    }
                    if (idsRaw == null || idsRaw.isBlank()) {
                        session.setAttribute("errorMessage", "Không tìm thấy danh sách khóa học để từ chối.");
                        break;
                    }

                    String[] courseIds = idsRaw.split(",");
                    boolean allSuccess = true;
                    for (String id : courseIds) {
                        if (!courseService.rejectCourseWithReason(Integer.parseInt(id), manager.getUserId(), reason)) {
                            allSuccess = false;
                        }
                    }

                    if (allSuccess) {
                        session.setAttribute("message", "Đã từ chối " + courseIds.length + " khóa học.");
                    } else {
                        session.setAttribute("errorMessage", "Một số khóa học bị lỗi khi cập nhật lý do.");
                    }
                    break;
                }

                case "setPrice": {
                    int courseId = Integer.parseInt(request.getParameter("courseId"));
                    BigDecimal price = new BigDecimal(request.getParameter("price"));
                    if (price.compareTo(BigDecimal.ZERO) < 0) {
                        session.setAttribute("errorMessage", "Giá không được nhỏ hơn 0.");
                        break;
                    }

                    courseService.updateCoursePrice(courseId, price);
                    session.setAttribute("message", "Cập nhật giá thành công!");
                    break;
                }

                default: {
                    session.setAttribute("errorMessage", "Hành động không hợp lệ.");
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }
}
