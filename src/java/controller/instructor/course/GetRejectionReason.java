/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.course;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.entity.Category;
import model.entity.Course;
import model.entity.Users;
import service.CategoryService;
import service.CourseManagerService;
import service.CourseService;

/**
 *
 * @author Lenovo
 */
public class GetRejectionReason extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GetRejectionReason</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetRejectionReason at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private CourseService courseService = new CourseService();
    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null) {
            response.sendRedirect("manage?error=missing_id");
            return;
        }

        int courseId = Integer.parseInt(courseIdParam);
        CourseManagerService service = new CourseManagerService();
        String reason = service.getRejectionReason(courseId);

        // Lấy thêm danh sách cần thiết
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        int instructorId = user.getUserId();

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Category> cateList = categoryService.getAllCategories();
        List<Course> courseList = courseService.searchAndFilterCourses(instructorId, keyword, status);

        // Truyền dữ liệu ra view
        request.setAttribute("courseList", courseList);
        request.setAttribute("cateList", cateList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        // Quan trọng: thêm 2 thuộc tính modal
        request.setAttribute("rejectedCourseId", courseId);
        request.setAttribute("rejectionReason", reason);

        request.getRequestDispatcher("teacher/courses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
