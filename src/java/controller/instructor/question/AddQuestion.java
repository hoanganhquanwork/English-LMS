/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.instructor.question;

import dal.ModuleDAO;
import dal.QuestionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.entity.Question;
import model.entity.QuestionOption;
import model.entity.Module;
import java.sql.*;
/**
 *
 * @author Lenovo
 */
public class AddQuestion extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet AddQuestion</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddQuestion at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         int courseId = Integer.parseInt(request.getParameter("courseId"));
        ModuleDAO mDao = new ModuleDAO();
        List<Module> modules = mDao.getModulesByCourse(courseId);
        request.setAttribute("moduleList", modules);
      
        request.getRequestDispatcher("teacher/add-questions.jsp").forward(request, response);
    } 

 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            QuestionDAO dao = new QuestionDAO();

            // Lặp qua các câu hỏi
            int i = 1;
            while (true) {
                String text = request.getParameter("questionText" + i);
                if (text == null || text.isEmpty()) break;

                String type = request.getParameter("questionType" + i);
                String explanation = request.getParameter("explanation" + i);

                Question q = new Question();
                q.setModuleId(moduleId);
                q.setQuestionText(text);
                q.setQuestionType(type);
                q.setExplanation(explanation);
                int qid = dao.insertQuestion(q);

                // Đọc 4 option
                for (int j = 1; j <= 4; j++) {
                    String content = request.getParameter("optionContent" + i + "_" + j);
                    if (content == null || content.isEmpty()) continue;

                    boolean isCorrect = false;
                    String[] corrects = request.getParameterValues("correct" + i);
                    if (corrects != null) {
                        for (String c : corrects) {
                            if (Integer.parseInt(c) == j) {
                                isCorrect = true;
                                break;
                            }
                        }
                    }

                    QuestionOption opt = new QuestionOption();
                    opt.setQuestionId(qid);
                    opt.setContent(content);
                    opt.setCorrect(isCorrect);
                    dao.insertOption(opt);
                }

                i++;
            }

            response.sendRedirect("ManageQuestionServlet?moduleId=" + moduleId);

        } catch (Exception e) {
            throw new ServletException("Lỗi khi thêm câu hỏi hàng loạt", e);
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
