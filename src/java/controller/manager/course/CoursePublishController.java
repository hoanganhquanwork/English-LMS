/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager.course;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.entity.Category;
import model.entity.Course;
import service.CategoryService;
import service.CourseManagerService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CoursePublishController", urlPatterns = {"/coursepublish"})
public class CoursePublishController extends HttpServlet {

    private CourseManagerService courseService = new CourseManagerService();
    private final CategoryService caService = new CategoryService();


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
            out.println("<title>Servlet CoursePublishController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CoursePublishController at " + request.getContextPath() + "</h1>");
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
        courseService.autoPublishIfDue();

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        String categoryParam = request.getParameter("categoryId");
        if (status == null) {
            status = "all";
        }
        if (sort == null) {
            sort = "newest";
        }

        if (categoryParam == null) {
            categoryParam = "0";
        }
        int categoryId = 0;
        try {
            if (categoryParam != null && !categoryParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryParam);
            }
        } catch (NumberFormatException e) {
            categoryId = 0;
        }

        List<Course> courseList = courseService.getFilterPublishCourse(status, keyword, sort, categoryParam);
        List<Category> cate = caService.getAllCategories();
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter tf = DateTimeFormatter.ofPattern("HH:mm");
        List<String> createdDateList = new ArrayList<>();
        List<String> createdTimeList = new ArrayList<>();

        for (Course c : courseList) {
            if (c.getPublishAt() != null) {
                createdDateList.add(c.getPublishAt().format(df));
                createdTimeList.add(c.getPublishAt().format(tf));
            } else {
                createdDateList.add("N/A");
                createdTimeList.add("");
            }
        }
        request.setAttribute("courseList", courseList);
        request.setAttribute("createdDateList", createdDateList);
        request.setAttribute("createdTimeList", createdTimeList);

        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("categoryList", cate);
        request.setAttribute("message", request.getSession().getAttribute("message"));
        request.setAttribute("errorMessage", request.getSession().getAttribute("errorMessage"));
        request.getSession().removeAttribute("message");
        request.getSession().removeAttribute("errorMessage");

        request.getRequestDispatcher("/views-manager/course-publish.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        String[] ids = request.getParameterValues("courseIds");

        if (ids == null) {
            String singleId = request.getParameter("courseIds");
            if (singleId != null) {
                ids = new String[]{singleId};
            }
        }
        String dateStr = request.getParameter("publishDate");

        String message = courseService.handlePublishAction(action, ids, dateStr);

        if (message.contains("Đã") || message.contains("thành công")) {
            request.getSession().setAttribute("message", message);
        } else {
            request.getSession().setAttribute("errorMessage", message);
        }

        response.sendRedirect("coursepublish");
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
