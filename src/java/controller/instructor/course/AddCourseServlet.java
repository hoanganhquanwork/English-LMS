/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.course;

import dal.CategoryDAO;
import dal.InstructorProfileDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.math.BigDecimal;
import java.nio.file.Paths;
import model.Category;
import model.Course;
import model.InstructorProfile;
import model.Users;
import service.CourseService;

/**
 *
 * @author Lenovo
 */
@WebServlet("/addCourse")
public class AddCourseServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddCourseServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private CourseService courseService = new CourseService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {

            HttpSession session = request.getSession(false);
            Users user = (Users) session.getAttribute("user");

            if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("auth/login.jsp");
                return;
            }
            InstructorProfileDAO instructorDAO = new InstructorProfileDAO();
            InstructorProfile instructor = instructorDAO.getByUserId(user.getUserId());
            if (instructor == null) { 
                response.sendRedirect("manage");
            }
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String language = request.getParameter("language");
            String level = request.getParameter("level");

            int categoryId = Integer.parseInt(request.getParameter("category"));
            Category category = new CategoryDAO().getCategoryById(categoryId);

            Course course = new Course();
            course.setTitle(title);
            course.setDescription(description);
            course.setLanguage(language);
            course.setLevel(level);
            course.setCategory(category);
            course.setCreatedBy(instructor);
            boolean success = courseService.createCourse(course);
            if (success) {
                response.sendRedirect("manage");
            }

        } catch (Exception e) {
            e.printStackTrace();

        }

    }
}
