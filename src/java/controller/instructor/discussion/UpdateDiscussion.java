/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.discussion;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.entity.Discussion;
import model.entity.DiscussionComment;
import model.entity.DiscussionPost;
import model.entity.ModuleItem;
import service.DiscussionService;
import service.ModuleItemService;
import service.ModuleService;

/**
 *
 * @author Lenovo
 */
public class UpdateDiscussion extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateDiscussion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateDiscussion at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private ModuleService service = new ModuleService();
    private ModuleItemService contentService = new ModuleItemService();
    private DiscussionService dservice = new DiscussionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int discussionId = Integer.parseInt(request.getParameter("discussionId"));
        try {
         
            Map<model.entity.Module, List<ModuleItem>> courseContent = contentService.getCourseContent(courseId);
            Map<DiscussionPost, List<DiscussionComment>> postCommentMap = dservice.getPostCommentMap(discussionId);
            Discussion discussion = dservice.getDiscussion(discussionId);
            request.setAttribute("courseId", courseId);
            request.setAttribute("discussion", discussion);
            request.setAttribute("content", courseContent);
            request.setAttribute("postCommentMap", postCommentMap);
            request.getRequestDispatcher("teacher/discussion.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int discussionId = Integer.parseInt(request.getParameter("discussionId"));

            String title = request.getParameter("title");
            String description = request.getParameter("description");

            Discussion d = new Discussion();
            d.setDiscussionId(discussionId);
            d.setTitle(title);
            d.setDescription(description);

            boolean updated = dservice.updateDiscussion(d);

            if (updated) {
                response.sendRedirect("updateDiscussion?courseId=" + courseId + "&moduleId=" + moduleId + "&discussionId=" + discussionId + "&success=1");
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi khi cập nhật thảo luận", e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
