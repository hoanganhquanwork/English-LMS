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
import java.util.ArrayList;
import java.util.List;
import model.entity.FlashcardSet;
import model.entity.Flashcard;
import service.FlashcardService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name="FlashcardStudyControllerServlet", urlPatterns={"/flashcard-study"})
public class FlashcardStudyControllerServlet extends HttpServlet {
     private final FlashcardService fService = new FlashcardService();
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
            out.println("<title>Servlet FlashcardStudyControllerServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlashcardStudyControllerServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
  @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String raw = request.getParameter("setId");
            if (raw == null || raw.isEmpty()) {
                response.sendRedirect("dashboard?action=listSets");
                return;
            }

            int setId = Integer.parseInt(raw);
            FlashcardSet set = fService.getSetById(setId);

            if (set == null) {
                request.setAttribute("error", "Không tìm thấy bộ flashcard này.");
                request.getRequestDispatcher("/flashcard/viewSet.jsp").forward(request, response);
                return;
            }

            List<Flashcard> cards = fService.getCardsBySet(setId);
            if (cards == null) cards = new ArrayList<>();

            request.setAttribute("set", set);
            request.setAttribute("cards", cards);

            request.getRequestDispatcher("/flashcard/flashcard-study.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard?action=listSets");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải chế độ học.");
            request.getRequestDispatcher("/flashcard/viewSet.jsp").forward(request, response);
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
