package controller.manager.course;

import controller.manager.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Course;
import service.CourseManagerService;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.Users;
import service.ManagerService;

@WebServlet(name = "CourseManagerServlet", urlPatterns = {"/coursemanager"})
public class CourseManagerController extends HttpServlet {

    private final CourseManagerService courseService = new CourseManagerService();
    private final ManagerService managerService = new ManagerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            String idStr = request.getParameter("courseId");
            if (idStr != null) {
                int courseId = Integer.parseInt(idStr);
                Course course = courseService.getCourseById(courseId);
                request.setAttribute("course", course);
            }
            request.getRequestDispatcher("/views.manager/course-detail.jsp").forward(request, response);
            return;
        }

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        if (status == null) {
            status = "all";
        }
        if (sort == null) {
            sort = "newest";
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

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/coursemanager");
            return;
        }

        switch (action) {
            case "approve":
            case "reject":
                String[] courseIds = request.getParameterValues("courseIds");
                if (courseIds != null) {
                    for (String id : courseIds) {
                        int courseId = Integer.parseInt(id);
                        courseService.updateCourseStatus(courseId,
                                "approve".equals(action) ? "approved" : "rejected");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/coursemanager");
                return;

            case "setPrice":
                String idStr = request.getParameter("courseId");
                String priceStr = request.getParameter("price");
                String source = request.getParameter("source");

                if (idStr != null && priceStr != null && !priceStr.isEmpty()) {
                    int courseId = Integer.parseInt(idStr);
                    BigDecimal price = new BigDecimal(priceStr);
                    courseService.updateCoursePrice(courseId, price);

                    if ("detail".equals(source)) {
                        response.sendRedirect(request.getContextPath()
                                + "/coursemanager?action=detail&courseId=" + courseId);
                    } else {
                        String status = request.getParameter("status");
                        String keyword = request.getParameter("keyword");
                        String sort = request.getParameter("sort");

                        response.sendRedirect(request.getContextPath() + "/coursemanager"
                                + "?status=" + (status != null ? status : "all")
                                + "&keyword=" + (keyword != null ? keyword : "")
                                + "&sort=" + (sort != null ? sort : "newest"));
                    }
                    return;
                }
                break;
        }
        response.sendRedirect(request.getContextPath() + "/coursemanager");
    }
}
