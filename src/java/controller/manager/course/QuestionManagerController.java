/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager.course;

import jakarta.servlet.RequestDispatcher;
import java.util.*;
import model.dto.QuestionDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import model.dto.QuestionListItemDTO;
import model.entity.Topic;
import model.entity.Users;
import service.QuestionManagerService;
import service.TopicService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "QuestionManagerController", urlPatterns = {"/question-manager"})
public class QuestionManagerController extends HttpServlet {

    private QuestionManagerService qService = new QuestionManagerService();
    private TopicService tService = new TopicService();

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
            out.println("<title>Servlet QuestionManagerController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuestionManagerController at " + request.getContextPath() + "</h1>");
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

        HttpSession session = request.getSession();
        Users manager = (Users) session.getAttribute("user");
        if (manager == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect("loginInternal");
            return;
        }

        String action = request.getParameter("action");

        if ("instructor-suggest".equalsIgnoreCase(action)) {
            response.setContentType("text/html;charset=UTF-8");
            String keyword = request.getParameter("q");

            List<String> names = qService.searchInstructorNames(keyword);

            try (PrintWriter out = response.getWriter()) {
                if (names == null || names.isEmpty()) {
                    out.println("<div class='suggest-item muted'>Không có kết quả</div>");
                } else {
                    for (String name : names) {
                        out.println("<div class='suggest-item'>" + name + "</div>");
                    }
                }
            }
            return;
        }
        if ("detail".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                QuestionListItemDTO question = qService.getQuestionDetail(id);
                request.setAttribute("q", question);
                RequestDispatcher rd = request.getRequestDispatcher("/views-manager/question/question-detail.jsp");
                rd.forward(request, response);
            } catch (Exception e) {
                response.getWriter().write("<p>Lỗi khi tải chi tiết câu hỏi.</p>");
            }
            return;
        }

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String instructor = request.getParameter("instructor");
        String type = request.getParameter("type");
        String topicId = request.getParameter("topicId");

        if (topicId == null || topicId.isBlank()) {
            topicId = "all";
        }

        List<Topic> topics = tService.getAllTopics();
        request.setAttribute("topics", topics);

        List<QuestionListItemDTO> questions = qService.getFilteredQuestions(status, keyword, instructor, type, topicId);
        request.setAttribute("questions", questions);

        RequestDispatcher rd = request.getRequestDispatcher("/views-manager/question/question-manager.jsp");
        rd.forward(request, response);
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

        HttpSession session = request.getSession();
        Users manager = (Users) session.getAttribute("user");
        if (manager == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect("loginInternal");
            return;
        }

        String action = request.getParameter("action");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String instructor = request.getParameter("instructor");
        String type = request.getParameter("type");

        String redirectUrl = "question-manager?status=" + (status != null ? status : "all")
                + "&keyword=" + (keyword != null ? URLEncoder.encode(keyword, StandardCharsets.UTF_8) : "")
                + "&instructor=" + (instructor != null ? URLEncoder.encode(instructor, StandardCharsets.UTF_8) : "")
                + "&type=" + (type != null ? URLEncoder.encode(type, StandardCharsets.UTF_8) : "");

        String[] questionIds;
        String joinedIds = request.getParameter("questionIds");
        if (joinedIds != null && joinedIds.contains(",")) {
            questionIds = joinedIds.split(",");
        } else {
            questionIds = request.getParameterValues("questionIds");
            if (questionIds == null) {
                String idStr = request.getParameter("questionId");
                if (idStr != null && !idStr.isBlank()) {
                    questionIds = new String[]{idStr};
                }
            }
        }

        String reason = request.getParameter("reason");

        try {
            qService.handleManagerAction(action, questionIds, reason, manager);
            session.setAttribute("message", "Đã xử lý thành công!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", e.getMessage());
        }
        response.sendRedirect(redirectUrl);
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
