/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager.flashcard;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.entity.FlashcardSet;
import service.FlashcardManagerService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "FlashcardManagerController", urlPatterns = {"/manager-flashcard"})
public class FlashcardManagerController extends HttpServlet {

    private final FlashcardManagerService service = new FlashcardManagerService();

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
            out.println("<title>Servlet FlashcardManagerCotroller</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlashcardManagerCotroller at " + request.getContextPath() + "</h1>");
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

        try {
            String keyword = request.getParameter("keyword");
            String sortType = request.getParameter("sort");
            if (keyword == null) {
                keyword = "";
            }
            if (sortType == null) {
                sortType = "newest";
            }

            List<FlashcardSet> sets = service.getAllSets(keyword, sortType);
            request.setAttribute("sets", sets);
            request.setAttribute("keyword", keyword);
            request.setAttribute("sortType", sortType);

            request.getRequestDispatcher("/views-manager/flashcard/manager-flashcard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách flashcard.");
            request.getRequestDispatcher("/views-manager/flashcard/manager-flashcard.jsp").forward(request, response);
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

        try {
            String action = request.getParameter("action");

            if ("hide".equalsIgnoreCase(action)) {
                int setId = Integer.parseInt(request.getParameter("setId"));
                service.hideSet(setId);
            } else if ("activate".equalsIgnoreCase(action)) {
                int setId = Integer.parseInt(request.getParameter("setId"));
                service.activateSet(setId);
            }

            response.sendRedirect("manager-flashcard");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể thực hiện thao tác.");
            doGet(request, response);
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
    }

}
