/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.lesson;

import dal.LessonDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.entity.Lesson;
import service.LessonService;
import service.ModuleService;
import model.entity.Module;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "ManageLessonServlet", urlPatterns = {"/ManageLessonServlet"})
public class ManageLessonServlet extends HttpServlet {

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
            out.println("<title>Servlet ManageLessonServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageLessonServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private ModuleService service = new ModuleService();
    private LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
     
        try {
            List<Module> list = service.getModulesByCourse(courseId);
            Map<Module, List<Lesson>> content = lessonService.getCourseContent(courseId);
            
            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("moduleList", list);
            request.setAttribute("content", content);
            request.getRequestDispatcher("teacher/lesson-create-video.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
