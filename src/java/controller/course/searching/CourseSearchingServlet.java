/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.course.searching;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.entity.Category;
import model.entity.Course;
import service.CourseSearchingService;
import service.ReviewService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CourseSearchingServlet", urlPatterns = {"/courseSearching"})
public class CourseSearchingServlet extends HttpServlet {

    CourseSearchingService courseSearchingService = new CourseSearchingService();
    ReviewService reviewService = new ReviewService();

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
            out.println("<title>Servlet CourseSearchingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseSearchingServlet at " + request.getContextPath() + "</h1>");
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
        String keyWord = request.getParameter("keyWord");
        String sortBy = request.getParameter("sortBy");
        String page = request.getParameter("page");
        int pageSize = 9;

        String[] categoryIDRaw = request.getParameterValues("categoryIDs");
        String[] languageRaw = request.getParameterValues("language");
        String[] levelRaw = request.getParameterValues("level");

        try {
            int[] categoryIDs = parseIntArray(categoryIDRaw);
            Set<Integer> selectedCategorySet = new HashSet<>();
            for (Integer id : categoryIDs) {
                if (id > 0) {
                    selectedCategorySet.add(id);
                }
            }
            Set<String> selectedLanguageSet = toStringSet(languageRaw);
            Set<String> selectedLevelSet = toStringSet(levelRaw);

            List<Category> listCategories = courseSearchingService.getAllCategories();
            List<String> languages = courseSearchingService.getAllLanguages();
            List<String> levels = courseSearchingService.getAllLevels();

            int total = courseSearchingService.countCourse(categoryIDs, languageRaw, levelRaw, keyWord);
            int totalPages = (int) Math.ceil(total / (double) pageSize);

            int pageIndex = parsePositiveInt(page, 1);
            List<Course> courses = courseSearchingService.searchCourse(categoryIDs, languageRaw, levelRaw, keyWord, sortBy, pageIndex, pageSize);

            request.setAttribute("courses", courses);
            request.setAttribute("listCategories", listCategories);
            request.setAttribute("languages", languages);
            request.setAttribute("levels", levels);

            request.setAttribute("selectedCategorySet", selectedCategorySet);
            request.setAttribute("selectedLanguageSet", selectedLanguageSet);
            request.setAttribute("selectedLevelSet", selectedLevelSet);

            request.setAttribute("keyWord", keyWord);
            request.setAttribute("sortBy", sortBy);

            request.setAttribute("page", pageIndex);
            request.setAttribute("totalPages", totalPages);
        } catch (NumberFormatException e) {
            System.out.println("Loi tham so");
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/student/search-course.jsp").forward(request, response);

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
        processRequest(request, response);
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

    private int[] parseIntArray(String[] values) {
        if (values == null || values.length == 0) {
            return new int[0];
        }
        int[] result = new int[values.length];
        for (int i = 0; i < values.length; i++) {
            try {
                result[i] = Integer.parseInt(values[i]);
            } catch (NumberFormatException e) {
                result[i] = -1;
            }
        }
        return result;
    }

    //tranh page loi khi load lan dau, doi filter bi dinh null gay ra exception
    private static int parsePositiveInt(String s, int defaultValue) {
        try {
            int v = Integer.parseInt(s);
            return v > 0 ? v : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private static Set<String> toStringSet(String[] arr) {
        Set<String> set = new HashSet<>();
        if (arr == null) {
            return set;
        }
        for (String s : arr) {
            if (s != null && !s.isBlank()) {
                set.add(s);
            }
        }
        return set;
    }
}
