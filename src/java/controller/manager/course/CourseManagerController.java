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
import model.entity.Category;
import model.entity.Users;
import service.CategoryService;

@WebServlet(name = "CourseManagerServlet", urlPatterns = {"/coursemanager"})
public class CourseManagerController extends HttpServlet {

    private final CourseManagerService courseService = new CourseManagerService();
    private final CategoryService caService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users manager = (Users) session.getAttribute("user");
        if (manager == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect("loginInternal");
            return;
        }
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        String categoryParam = request.getParameter("categoryId");
        if (status == null) {
            status = "all";
        }
        if (keyword == null) {
            keyword = "";
        }
        if (sort == null) {
            sort = "newest";
        }
        if (categoryParam == null) {
            categoryParam = "0";
        }

        int categoryId = 0;
        try {
            if (categoryParam != null && !categoryParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryParam);
            }
        } catch (NumberFormatException e) {
            categoryId = 0;
        }

        List<Course> courseList = courseService.getFilteredCourses(status, keyword, sort, categoryParam);

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

        List<Category> cate = caService.getAllCategories();

        request.setAttribute("courseList", courseList);
        request.setAttribute("createdDateList", createdDateList);
        request.setAttribute("createdTimeList", createdTimeList);
        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("categoryList", cate);
        request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users manager = (Users) session.getAttribute("user");
        if (manager == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect("loginInternal");
            return;
        }

        String action = request.getParameter("action");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        String redirectUrl = "coursemanager?status=" + (status != null ? status : "all")
                + "&keyword=" + (keyword != null ? URLEncoder.encode(keyword, "UTF-8") : "")
                + "&sort=" + (sort != null ? sort : "newest");

        String[] courseIds = request.getParameterValues("courseIds");
        if (courseIds == null) {
            String idStr = request.getParameter("courseId");
            if (idStr != null && !idStr.isBlank()) {
                courseIds = new String[]{idStr};
            }
        }

        String reason = request.getParameter("rejectReason");
        String priceStr = request.getParameter("price");
        BigDecimal price = null;
        if (priceStr != null && !priceStr.isBlank()) {
            try {
                price = new BigDecimal(priceStr);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Giá không hợp lệ.");
                response.sendRedirect(redirectUrl);
                return;
            }
        }

        try {
            String resultMessage = courseService.handleManagerAction(action, courseIds, reason, price, manager);
            if (resultMessage.startsWith("Đã") || resultMessage.contains("thành công")) {
                session.setAttribute("message", resultMessage);
            } else {
                session.setAttribute("errorMessage", resultMessage);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }
}
