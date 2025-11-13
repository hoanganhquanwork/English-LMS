/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Lesson;
import service.LessonService;
import dal.ModuleItemDAO;
import java.util.List;
import java.util.Map;
import model.entity.ModuleItem;
import service.ModuleItemService;
import service.ModuleService;

/**
 *
 * @author Lenovo
 */
public class CreateReadingLesson extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateReadingLesson</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateReadingLesson at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private ModuleService service = new ModuleService();
    private ModuleItemService contentService = new ModuleItemService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        try {
           
            Map<model.entity.Module, List<ModuleItem>> courseContent = contentService.getCourseContent(courseId);

            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            
            request.setAttribute("content", courseContent);
            request.getRequestDispatcher("teacher/lesson-create-reading.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
       
    }

    private LessonService lessonService = new LessonService();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");

           Lesson lesson = new Lesson();
            lesson.setTitle(title);
            lesson.setContentType("reading");
            lesson.setTextContent(content);
            lesson.setVideoUrl(null);
            lesson.setDurationSec(0);

            
            boolean success = lessonService.addLesson(lesson, moduleId);

            if (success) {
                response.sendRedirect("ManageLessonServlet?courseId=" + courseId + "&moduleId=" + moduleId);
            } else {
                request.setAttribute("error", "Không thể tạo bài học Reading. Vui lòng thử lại.");
                doGet(request, response);
            }

            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tạo bài học: " + e.getMessage());
            request.getRequestDispatcher("teacher/lesson-create-reading.jsp").forward(request, response);
        }
    }
}
