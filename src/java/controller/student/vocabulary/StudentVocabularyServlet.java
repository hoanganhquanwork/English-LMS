/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.vocabulary;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.entity.StudentProfile;
import model.entity.Users;
import service.VocabularyService;

/**
 *
 * @author Admin
 */
@MultipartConfig
@WebServlet(name = "StudentVocabularyServlet", urlPatterns = {"/studentVocab"})
public class StudentVocabularyServlet extends HttpServlet {
    VocabularyService vocabService = new VocabularyService();
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
            out.println("<title>Servlet StudentVocabulary</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentVocabulary at " + request.getContextPath() + "</h1>");
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
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        StudentProfile student = (session != null) ? (StudentProfile) session.getAttribute("student") : null;

        if (user == null || student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = student.getUserId();

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        String sortKey = request.getParameter("sortKey");
        if (sortKey == null || sortKey.isBlank()) {
            sortKey = "created_desc";
        }

        int page = 1;
        try {
            String pageRaw = request.getParameter("page");
            if (pageRaw != null) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int pageSize = 10;

        int totalCount = vocabService.countVocabulary(studentId, keyword);
        int totalPages = (int) Math.ceil(totalCount * 1.0 / pageSize);

        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page < 1) {
            page = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<model.entity.StudentVocabulary> list = vocabService.listVocabulary(studentId, keyword, sortKey, page, pageSize);

        request.setAttribute("list", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortKey", sortKey);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/student/my-vocabulary.jsp").forward(request, response);
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
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        StudentProfile student = (StudentProfile) session.getAttribute("student");
        if (student == null) {
            response.sendRedirect("login");
            return;
        }

        int studentId = student.getUserId();
        String word = request.getParameter("word");
        String phonetic = emptyToNull(request.getParameter("phonetic"));
        String audioUrl = emptyToNull(request.getParameter("audioUrl"));
        String partOfSpeech = emptyToNull(request.getParameter("partOfSpeech"));
        String definition = emptyToNull(request.getParameter("definition"));
        String example = emptyToNull(request.getParameter("example"));
        String synonyms = emptyToNull(request.getParameter("synonyms"));
        String antonyms = emptyToNull(request.getParameter("antonyms"));

        boolean ok = vocabService.saveAVocabulary(studentId, word, phonetic, audioUrl,
                partOfSpeech, definition, example, synonyms, antonyms);
        System.out.println(ok);
        if (ok) {
            response.getWriter().write("{\"success\":true,\"message\":\"Saved\"}");
        } else {
            response.setStatus(400);
            response.getWriter().write("{\"success\":false,\"message\":\"Save failed\"}");
        }
    }

    private String emptyToNull(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
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
