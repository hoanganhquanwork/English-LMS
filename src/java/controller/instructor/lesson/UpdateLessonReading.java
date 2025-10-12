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

/**
 *
 * @author Lenovo
 */
public class UpdateLessonReading extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateLessonReading</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateLessonReading at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    private LessonService lessonService = new LessonService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            Lesson lesson = new Lesson();
            lesson.setModuleItemId(lessonId);
            lesson.setTitle(title);
            lesson.setTextContent(content);
            lesson.setContentType("reading");

            boolean success = lessonService.updateLesson(lesson);

            if (success) {
                response.sendRedirect("updateLesson?courseId=" + courseId + "&moduleId=" + moduleId + "&lessonId=" + lessonId );
            } 

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi cập nhật bài học Reading", e);
        }
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
