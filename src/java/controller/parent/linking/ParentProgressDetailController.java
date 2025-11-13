package controller.parent.linking;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.dto.CoursePageDTO;
import service.CoursePageService;

@WebServlet(name = "ParentProgressDetailController", urlPatterns = {"/parent/progress_detail"})

public class ParentProgressDetailController extends HttpServlet {

    private final CoursePageService service = new CoursePageService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            
            CoursePageDTO dto = service.getCourseProgressForParent(studentId, courseId);        
            request.setAttribute("coursePage", dto);
            request.getRequestDispatcher("/parent/progress_detail.jsp").forward(request,response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
