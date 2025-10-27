package controller.parent.linking;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.dto.CoursePageDTO;
import model.dto.CourseProgressDTO;
import service.CoursePageService;
import service.ParentProgressService;

@WebServlet(name = "ParentProgressDetailController", urlPatterns = {"/parent/progress_detail"})

public class ParentProgressDetailController extends HttpServlet {

    private final CoursePageService service = new CoursePageService();
    private final ParentProgressService progress = new ParentProgressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            
            CoursePageDTO dto = service.getCourseProgressForParent(studentId, courseId);        
            List<CourseProgressDTO> courseProgress = progress.getCourseProgressByStudent(studentId);
            request.setAttribute("courses", courseProgress);
            request.setAttribute("coursePage", dto);
            request.getRequestDispatcher("/parent/progress_detail.jsp").forward(request,response);

        } catch (Exception e) {
            e.printStackTrace();
           response.sendError(500, "Lỗi tải dữ liệu tiến độ học tập");
        }
    }
}
