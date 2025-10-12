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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.dto.QuestionDTO;
import model.entity.Users;
import service.ProgressService;
import service.QuestionService;
import static util.ParseUtil.parseIntOrNull;

/**
 *
 * @author Admin
 */
@WebServlet(name = "QuesionVideoServlet", urlPatterns = {"/checkVideoQuiz"})
public class QuesionVideoServlet extends HttpServlet {

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
            out.println("<title>Servlet QuesionVideoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuesionVideoServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private QuestionService questionService = new QuestionService();
    private ProgressService progressSevice = new ProgressService();

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
        if (itemId != null) {
            List<QuestionDTO> listQuestion = questionService.getQuestionByLessonId(itemId);

            //doc ket qua gui tu client
            Map<Integer, String> mcqAnswer = new HashMap<>(); //qid -> option id
            Map<Integer, String> textAnswer = new HashMap<>(); // qid -> text

            for (QuestionDTO q : listQuestion) {
                if ("mcq_single".equalsIgnoreCase(q.getType())) {
                    String value = request.getParameter("answers[" + q.getQuestionId() + "]");
                    if (value != null) {
                        mcqAnswer.put(q.getQuestionId(), value);
                    }
                } else if ("text".equalsIgnoreCase(q.getType())) {
                    String value = request.getParameter("answersText[" + q.getQuestionId() + "]");
                    if (value != null) {
                        textAnswer.put(q.getQuestionId(), value);
                    }
                }
            }

            //cham bai
            Map<Integer, Boolean> resultMap = new HashMap<>();
            int correct = 0;

            for (QuestionDTO q : listQuestion) {
                boolean isCorrect = false;
                if ("mcq_single".equalsIgnoreCase(q.getType())) {
                    String choosen = mcqAnswer.get(q.getQuestionId());
                    if (choosen != null) {
                        isCorrect = questionService.isCorrectOption(q.getQuestionId(), Integer.parseInt(choosen));
                    }
                } else {
                    String answer = textAnswer.get(q.getQuestionId());
                    if (answer != null) {
                        isCorrect = questionService.isCorrectTextAnswer(q.getQuestionId(), answer);
                    }
                }
                resultMap.put(q.getQuestionId(), isCorrect);
                if (isCorrect) {
                    correct++;
                }
            }

            boolean passed = (correct == listQuestion.size());
            if (passed) {
                progressSevice.markLessonVideoCompleted(userId, itemId);
            }
            HttpSession ss = session;
            ss.setAttribute("flashShowResult", true); //xac nhan hien thi ket qua
            ss.setAttribute("flashQuizResult", resultMap);
            ss.setAttribute("flashAnswers", mcqAnswer);
            ss.setAttribute("flashTextAnswers", textAnswer);
            session.setAttribute("flashPassed", passed);
            response.sendRedirect(request.getContextPath() + "/coursePage?itemId=" + itemId + "&courseId=" + courseId);

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
