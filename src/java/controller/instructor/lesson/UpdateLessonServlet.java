/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.instructor.lesson;

import dal.LessonDAO;
import dal.ModuleItemDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.Lesson;
import model.ModuleItem;
import service.LessonService;
import service.ModuleService;
import util.YouTubeApiClient;

/**
 *
 * @author Lenovo
 */
public class UpdateLessonServlet extends HttpServlet {
   
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateLessonServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateLessonServlet at " + request.getContextPath () + "</h1>");
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
        String lessonIdStr = request.getParameter("lessonId");
        try {
            List<model.Module> list = service.getModulesByCourse(courseId);
            Map<model.Module, List<Lesson>> content = lessonService.getCourseContent(courseId);

            Lesson currentLesson = null;
            if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
                            LessonDAO lDao = new LessonDAO();
                int lessonId = Integer.parseInt(lessonIdStr);
                currentLesson = lDao.getLessonById(lessonId);
            }
             request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("moduleList", list);
            request.setAttribute("content", content);
            request.setAttribute("lesson", currentLesson); 
            request.getRequestDispatcher("teacher/lesson-video-content.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    } 

      private YouTubeApiClient ytClient;
       public void init() {

        String apiKey = "AIzaSyB6ElDUHgL8NL8Lf3DjIJxhwdXlQ2GyZho";
        ytClient = new YouTubeApiClient(apiKey);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
      try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String youtubeUrl = request.getParameter("videoUrl");

            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.getLessonById(lessonId);

            if (lesson == null) {
                throw new ServletException("Không tìm thấy bài học với ID = " + lessonId);
            }

            lesson.setTitle(title);

            // Nếu người dùng nhập link YouTube mới
            if (youtubeUrl != null && !youtubeUrl.trim().isEmpty()) {
                // Lấy videoId từ URL
                String videoId = YouTubeApiClient.extractVideoId(youtubeUrl);

                // Gọi YouTube API để lấy thời lượng mới
                String isoDuration = ytClient.fetchIsoDuration(videoId);
                int durationSec = YouTubeApiClient.isoDurationToSeconds(isoDuration);

                // Cập nhật lại videoUrl và thời lượng
                lesson.setVideoUrl(YouTubeApiClient.toEmbedUrl(videoId));
                lesson.setDurationSec(durationSec);
            }

            // Cập nhật Lesson
            lessonDAO.updateLesson(lesson);


            // Quay lại trang cập nhật bài học
            response.sendRedirect("updateLesson?courseId=" + courseId
                    + "&moduleId=" + moduleId
                    + "&lessonId=" + lessonId);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi cập nhật bài học: " + e.getMessage(), e);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
