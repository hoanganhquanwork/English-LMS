/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.flashcard.crud;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.FlashcardAIService;
import model.entity.Flashcard;
import model.entity.FlashcardSet;
import model.entity.Users;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "FlashcardAIServlet", urlPatterns = {"/flashcard-ai"})
public class FlashcardAIServlet extends HttpServlet {

     private final FlashcardAIService service = new FlashcardAIService();

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
            out.println("<title>Servlet FlashcardAIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlashcardAIServlet at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Lấy setId nếu có (từ createSet.jsp truyền qua)
        String setId = req.getParameter("setId");
        req.setAttribute("setId", setId);
        req.getRequestDispatcher("/flashcard/flashcard-ai.jsp").forward(req, resp);
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String title = req.getParameter("set_title");
        String prompt = req.getParameter("prompt");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        int studentId = user.getUserId();

        // ✅ Tạo mới hoàn toàn — không cần setId
        List<Flashcard> cards = service.generateAndSave(prompt, null, studentId, title);

        if (cards == null || cards.isEmpty()) {
            req.setAttribute("error", "❌ AI không thể tạo flashcard. Hãy thử mô tả khác!");
        } else {
            int newSetId = cards.get(0).getSetId();
            req.setAttribute("message", "✅ Đã tạo bộ flashcard \"" + title + "\" gồm " + cards.size() + " thẻ!");
            req.setAttribute("generatedCards", cards);
            req.setAttribute("setId", newSetId);
        }

        req.getRequestDispatcher("/flashcard/flashcard-ai.jsp").forward(req, resp);
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
