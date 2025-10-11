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
import service.DiscussionService;

/**
 *
 * @author Lenovo
 */
public class CreateDiscussion extends HttpServlet {

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
            out.println("<title>Servlet CreateDiscussion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateDiscussion at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        request.setAttribute("moduleId", moduleId);
        request.getRequestDispatcher("teacher/create-discussion.jsp").forward(request, response);
    }
    private DiscussionService discussionService = new DiscussionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        boolean success = discussionService.createDiscussion(moduleId, title, description);

        if (success) {
            response.sendRedirect("moduleDetail?moduleId=" + moduleId + "&msg=discussion_created");
        } else {
            request.setAttribute("error", "Không thể tạo thảo luận, vui lòng thử lại!");
            request.getRequestDispatcher("instructor/module/createDiscussion.jsp").forward(request, response);
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
