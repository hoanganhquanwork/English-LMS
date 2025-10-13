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
import model.entity.Course;
import service.CourseManagerService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CoursePublishController", urlPatterns = {"/coursepublish"})
public class CoursePublishController extends HttpServlet {

    private CourseManagerService courseService = new CourseManagerService();

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

        if (status == null) status = "all";
        if (sort == null) sort = "newest";

        List<Course> courseList = courseService.getFilterPublishCourse(status, keyword, sort);

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

        if (action == null || ids == null) {
            response.sendRedirect("coursepublish");
            return;
        }
        for (String idStr : ids) {
            int id = Integer.parseInt(idStr.trim());

            switch (action) {
                case "publish":
                    courseService.publishNow(id);
                    request.getSession().setAttribute("message", "Đã đăng khóa học ngay lập tức.");
                    break;

                case "unpublish":
                    courseService.unpublishCourse(id);
                    request.getSession().setAttribute("message", "Đã gỡ đăng khóa học.");
                    break;

                case "republish":
                    courseService.republishCourse(id);
                    request.getSession().setAttribute("message", "Đã đăng lại khóa học.");
                    break;

                case "schedule": {
                    String dateStr = request.getParameter("publishDate");
                    if (dateStr == null || dateStr.isEmpty()) {
                        request.getSession().setAttribute("errorMessage", "Vui lòng chọn ngày đăng hợp lệ.");
                        break;
                    }
                    try {
                        LocalDate chosenDate = LocalDate.parse(dateStr);
                        LocalDate today = LocalDate.now();

                        if (chosenDate.isBefore(today)) {
                            request.getSession().setAttribute("errorMessage", "Không thể chọn ngày trong quá khứ.");
                            break;
                        }
                        if (chosenDate.isAfter(today.plusYears(1))) {
                            request.getSession().setAttribute("errorMessage", "Không thể đặt lịch xa hơn 1 năm.");
                            break;
                        }

                        LocalDateTime dateTime = chosenDate.atStartOfDay();
                        boolean success = courseService.schedulePublish(id, dateTime);

                        if (success) {
                            request.getSession().setAttribute("message", "Đã đặt lịch đăng vào ngày " + dateStr + ".");
                        } else {
                            request.getSession().setAttribute("errorMessage", "Không thể lưu lịch đăng khóa học.");
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                        request.getSession().setAttribute("errorMessage", "Ngày không hợp lệ. Định dạng: yyyy-MM-dd.");
                    }
                    break;
                }
            }
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
