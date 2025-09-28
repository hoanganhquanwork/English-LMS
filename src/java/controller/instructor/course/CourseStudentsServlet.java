/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.course;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;
import model.Enrollment;
import service.CourseService;
import service.EnrollmentService;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "CourseStudentsServlet", urlPatterns = {"/courseStudents"})
public class CourseStudentsServlet extends HttpServlet {

    private EnrollmentService enrollmentService = new EnrollmentService();
    private CourseService courseService = new CourseService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseStudentsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseStudentsServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         int courseId = Integer.parseInt(request.getParameter("courseId"));
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        if (status == null) status = "all";

        Course course = courseService.getCourseById(courseId);
        List<Enrollment> studentList = enrollmentService.getEnrollments(courseId, keyword, status);

        request.setAttribute("course", course);
        request.setAttribute("studentList", studentList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        request.getRequestDispatcher("teacher1/student.jsp").forward(request, response);
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
