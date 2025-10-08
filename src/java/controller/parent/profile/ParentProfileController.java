package controller.parent.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.entity.Users;
import model.entity.ParentProfile;
import service.AuthService;
import service.ParentProfileService;

public class ParentProfileController extends HttpServlet {
    private final ParentProfileService service = new ParentProfileService();    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users parent = (Users) session.getAttribute("user");
        if (parent == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Integer parentId = parent.getUserId();

         
            Users user = service.getUser(parentId);
            ParentProfile profile = service.getParentProfile(parentId);

            request.setAttribute("user", user);
            request.setAttribute("parent", profile);

            
            request.getRequestDispatcher("/parent/profile.jsp").forward(request, response);
            
    }

}
