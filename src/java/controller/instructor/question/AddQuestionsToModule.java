/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import service.QuestionService;

/**
 *
 * @author Lenovo
 */
public class AddQuestionsToModule extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddQuestionsToModule</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddQuestionsToModule at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private QuestionService questionService = new QuestionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseId = request.getParameter("courseId");
        String moduleIdStr = request.getParameter("moduleId");
        String questionIdsStr = request.getParameter("questionIds");

        if (moduleIdStr == null || questionIdsStr == null || questionIdsStr.trim().isEmpty()) {
            response.sendRedirect("addBulkQuestions?courseId=" + courseId + "&error=missing_data");
            return;
        }

        try {
            int moduleId = Integer.parseInt(moduleIdStr);
            String[] ids = questionIdsStr.split(",");
            List<Integer> questionIds = new ArrayList<>();
            for (String id : ids) {
                questionIds.add(Integer.parseInt(id.trim()));
            }

            int addedCount = questionService.addQuestionsToModule(moduleId, questionIds);

            response.sendRedirect("addQuestion?courseId=" + courseId + "&success=" + addedCount);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addQuestion?courseId=" + courseId + "&error=server_error");
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
