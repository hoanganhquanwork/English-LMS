/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.course;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import model.entity.Category;
import model.entity.Course;
import service.CourseService;

/**
 *
 * @author Lenovo
 */
@WebServlet("/updateCourse")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateCourseServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdateCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateCourseServlet at " + request.getContextPath() + "</h1>");
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
    private CourseService courseService = new CourseService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String language = request.getParameter("language");
            String level = request.getParameter("level");
            String oldThumbnail = request.getParameter("oldThumbnail");
            int categoryId = Integer.parseInt(request.getParameter("category"));
            Category category = new CategoryDAO().getCategoryById(categoryId);

            Part filePart = request.getPart("thumbnail");
            String newThumbnail = oldThumbnail;

            if (filePart != null && filePart.getSize() > 0) {
                // Upload ảnh mới
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("/image/thumbnail/course");
                File folder = new File(uploadDir);
                if (!folder.exists()) {
                    folder.mkdirs();
                }

                String savedName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadDir + File.separator + savedName);
                newThumbnail = "image/thumbnail/course/" + savedName;

                if (oldThumbnail != null && !oldThumbnail.isEmpty()) {
                    File oldFile = new File(getServletContext().getRealPath("/") + oldThumbnail);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
            }

            Course course = new Course();
            course.setCourseId(courseId);
            course.setTitle(title);
            course.setDescription(description);
            course.setLanguage(language);
            course.setLevel(level);
            course.setCategory(category);
            course.setThumbnail(newThumbnail);

            boolean updated = courseService.updateCourse(course);

            if (updated) {
                response.sendRedirect("manage");
            } else {

            }
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
}
