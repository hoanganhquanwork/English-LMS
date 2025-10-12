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
import model.entity.Lesson;
import model.entity.ModuleItem;
import service.LessonService;
import util.YouTubeApiClient;

/**
 *
 * @author Lenovo
 */
public class CreateVideoLessonServlet extends HttpServlet {

    private YouTubeApiClient ytClient;

    public void init() {

        String apiKey = "AIzaSyB6ElDUHgL8NL8Lf3DjIJxhwdXlQ2GyZho";
        ytClient = new YouTubeApiClient(apiKey);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
     private LessonService lessonService = new LessonService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String youtubeUrl = request.getParameter("youtubeUrl");

            // Extract videoId và lấy duration
            String videoId = YouTubeApiClient.extractVideoId(youtubeUrl);

            // 2. Gọi YouTube API để lấy duration
            String isoDuration = ytClient.fetchIsoDuration(videoId);
            int durationSec = YouTubeApiClient.isoDurationToSeconds(isoDuration);
            Lesson lesson = new Lesson();
            lesson.setTitle(title);
            lesson.setContentType("video");
            lesson.setVideoUrl(YouTubeApiClient.toEmbedUrl(videoId));
            lesson.setDurationSec(durationSec);
            lesson.setTextContent(null);

            boolean success = lessonService.addLesson(lesson, moduleId);
            response.sendRedirect("ManageLessonServlet?courseId=" + courseId + "&moduleId=" + moduleId );
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
