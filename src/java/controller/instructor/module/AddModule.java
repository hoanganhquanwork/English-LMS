/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.module;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.Module;
import service.CourseService;
import service.ModuleService;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "AddModule", urlPatterns = {"/addModule"})
public class AddModule extends HttpServlet {

    private ModuleService moduleService = new ModuleService();
    private CourseService courseService = new CourseService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddModule</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddModule at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String title = request.getParameter("moduleName");
        String description = request.getParameter("moduleDescription");

        Course course = courseService.getCourseById(courseId);
        Module module = new Module();
        module.setCourse(course);
        module.setTitle(title);
        module.setDescription(description);

        boolean success = moduleService.createModule(module);

        if (success) {
            response.sendRedirect("manageModule?courseId=" + courseId);
        }
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
