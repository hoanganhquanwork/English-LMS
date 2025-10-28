/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import model.entity.Question;
import service.QuestionAIService;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "GenerateQuestionAIServlet", urlPatterns = {"/generateQuestionAI"})
public class GenerateQuestionAIServlet extends HttpServlet {

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
            out.println("<title>Servlet GenerateQuestionAIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GenerateQuestionAIServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        String topic = request.getParameter("topicId");
        String type = request.getParameter("type");
        int count = Integer.parseInt(request.getParameter("count"));

        QuestionAIService aiService = new QuestionAIService();
        List<Question> questions = aiService.generateQuestions(topic, type, count);

        Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> null)
            .registerTypeAdapter(java.time.LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> null)
            .setLenient()
            .serializeNulls()
            .create();

    String json = gson.toJson(questions);
        response.getWriter().write(json);
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
