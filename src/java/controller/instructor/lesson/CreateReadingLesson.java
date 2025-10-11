/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Lesson;
import service.LessonService;
import dal.ModuleItemDAO;
import java.util.List;
import java.util.Map;
import model.entity.ModuleItem;
import service.ModuleItemService;
import service.ModuleService;

/**
 *
 * @author Lenovo
 */
public class CreateReadingLesson extends HttpServlet {

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
            out.println("<title>Servlet CreateReadingLesson</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateReadingLesson at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private ModuleService service = new ModuleService();
    private ModuleItemService contentService = new ModuleItemService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        try {
            List<model.entity.Module> list = service.getModulesByCourse(courseId);
            Map<model.entity.Module, List<ModuleItem>> courseContent = contentService.getCourseContent(courseId);

            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("moduleList", list);
            request.setAttribute("content", courseContent);
            request.getRequestDispatcher("teacher/lesson-create-reading.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
       
    }

    private LessonService lessonService = new LessonService();
    private ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 🔹 Lấy dữ liệu từ form
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            // 🔹 Bước 1: Tạo module_item cho bài học mới (vì Lesson phụ thuộc vào ModuleItem)
            int orderIndex = moduleItemDAO.getNextOrderIndex(moduleId);

            ModuleItem newItem = new ModuleItem();
            newItem.setModuleId(moduleId);
            newItem.setItemType("lesson");
            newItem.setOrderIndex(orderIndex);
            newItem.setRequired(true);

            int moduleItemId = moduleItemDAO.insertModuleItem(newItem);

            if (moduleItemId <= 0) {
                throw new Exception("Không thể tạo ModuleItem mới cho bài học.");
            }

            Lesson lesson = new Lesson();
            lesson.setModuleItemId(moduleItemId);
            lesson.setTitle(title);
            lesson.setContentType("reading");
            lesson.setTextContent(content);

            boolean success = lessonService.addLesson(lesson);

            if (success) {

                response.sendRedirect("ManageLessonServlet?courseId=" + courseId + "&moduleId=" + moduleId + "&lessonId=" + moduleItemId);
            } else {
                request.setAttribute("error", "Không thể tạo bài học Reading. Vui lòng thử lại.");
                request.getRequestDispatcher("teacher/lesson-create-reading.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tạo bài học: " + e.getMessage());
            request.getRequestDispatcher("teacher/lesson-create-reading.jsp").forward(request, response);
        }
    }
}
