package controller.parent.linking;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import model.entity.Users;
import model.dto.CourseProgressDTO;
import service.ParentProgressService;

@WebServlet("/parent/progress")
public class ParentProgressController extends HttpServlet {

    private ParentProgressService service = new ParentProgressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users parent = (Users) request.getSession().getAttribute("user");
        if (parent == null || !"Parent".equalsIgnoreCase(parent.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int parentId = parent.getUserId();

        List<Users> children = service.getChildrenByParent(parentId);
        request.setAttribute("children", children);

        Integer studentId = null;
        try {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        } catch (Exception e) {
            if (!children.isEmpty()) {
                studentId = children.get(0).getUserId(); // con đầu tiên
            }
        }

        if (studentId != null) {
            List<CourseProgressDTO> courseProgress = service.getCourseProgressByStudent(studentId);
            Map<String, Object> overview = service.getOverview(studentId);

            request.setAttribute("courses", courseProgress);
            request.setAttribute("overview", overview);
            request.setAttribute("selectedStudentId", studentId);
        }

        request.getRequestDispatcher("/parent/progress.jsp").forward(request, response);
    }
}
