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
import service.QuestionService;

/**
 *
 * @author Lenovo
 */
public class DeleteQuestionFromModule extends HttpServlet {
   

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DeleteQuestionFromModule</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteQuestionFromModule at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 
    private QuestionService questionService = new QuestionService();
  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int questionId = Integer.parseInt(request.getParameter("questionId"));

            boolean success = questionService.removeQuestionFromModule(moduleId, questionId);

            if (success) {
                response.sendRedirect("updateQuestion?courseId=" + courseId + "&moduleId=" + moduleId + "&msg=deleted");
            } else {
                response.sendRedirect("updateQuestion?courseId=" + courseId + "&moduleId=" + moduleId + "&error=delete_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewModuleQuestions?error=invalid_params");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
