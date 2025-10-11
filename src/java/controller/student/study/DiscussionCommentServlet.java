/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.study;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import service.DiscussionService;
import static util.ParseUtil.parseIntOrNull;

/**
 *
 * @author Admin
 */
@WebServlet(name = "DiscussionCommentServlet", urlPatterns = {"/discussionComment"})
public class DiscussionCommentServlet extends HttpServlet {

    private DiscussionService discussionService = new DiscussionService();

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
            out.println("<title>Servlet DiscussionCommentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DiscussionCommentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = user.getUserId();
        Integer courseId = parseIntOrNull(request.getParameter("courseId"));
        Integer itemId = parseIntOrNull(request.getParameter("itemId"));
        Integer postId = parseIntOrNull(request.getParameter("postId"));
        Integer pageNumber = parseIntOrNull(request.getParameter("pageNumber"));
        String userReply = request.getParameter("userReply");
        if (discussionService.addDiscussionComment(postId, userReply, userId)) {
            response.sendRedirect(request.getContextPath() + "/coursePage?itemId=" + itemId + "&courseId=" + courseId + "&pageNumber=" + pageNumber);
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
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = user.getUserId();
        Integer courseId = parseIntOrNull(request.getParameter("courseId"));
        Integer itemId = parseIntOrNull(request.getParameter("itemId"));
        Integer commentId = parseIntOrNull(request.getParameter("commentId"));
        Integer pageNumber = parseIntOrNull(request.getParameter("pageNumber"));

        String userReply = request.getParameter("userReply");
        if (discussionService.updateDiscussionComment(commentId, userReply)) {
            response.sendRedirect(request.getContextPath() + "/coursePage?itemId=" + itemId + "&courseId=" + courseId + "&pageNumber=" + pageNumber);
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
