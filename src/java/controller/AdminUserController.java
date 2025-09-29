package controller;

import service.AdminUserService;
import service.AdminCourseService;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminUserController")
public class AdminUserController extends HttpServlet {

    private final AdminUserService userService = new AdminUserService();
    private final AdminCourseService courseService = new AdminCourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "getUserJson": {
                String idStr = req.getParameter("id");
                if (idStr == null || !idStr.matches("\\d+")) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                Users u = userService.getUserById(Integer.parseInt(idStr));
                if (u == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                resp.setContentType("application/json; charset=UTF-8");
                String json = "{"
                        + "\"userId\":" + u.getUserId() + ","
                        + "\"username\":\"" + safe(u.getUsername()) + "\","
                        + "\"email\":\"" + safe(u.getEmail()) + "\","
                        + "\"role\":\"" + safe(u.getRole()) + "\","
                        + "\"status\":\"" + safe(u.getStatus()) + "\","
                        + "\"phone\":\"" + safe(u.getPhone()) + "\","
                        + "\"gender\":\"" + safe(u.getGender()) + "\","
                        + "\"dateOfBirth\":\"" + (u.getDateOfBirth() != null ? u.getDateOfBirth().toString() : "") + "\""
                        + "}";

                resp.getWriter().write(json);
                return;
            }

            case "delete": {
                String idStr = req.getParameter("id");
                if (idStr != null && idStr.matches("\\d+")) {
                    userService.deleteUser(Integer.parseInt(idStr));
                }
                resp.sendRedirect(req.getContextPath() + "/AdminUserController?action=list");
                return;
            }

            case "list":
            default: {
                String role = req.getParameter("role");
                String status = req.getParameter("status");
                String keyword = req.getParameter("keyword");

                int size = parseIntOrDefault(req.getParameter("size"), 4);
                int page = Math.max(parseIntOrDefault(req.getParameter("page"), 1), 1);

                int totalRows = userService.countSearchUsers(keyword, role, status);
                int totalPages = (int) Math.ceil(totalRows / (double) size);
                if (totalPages == 0) {
                    totalPages = 1;
                }
                if (page > totalPages) {
                    page = totalPages;
                }

                List<Users> users = userService.searchUsersPaged(keyword, role, status, page, size);

                req.setAttribute("users", users);
                req.setAttribute("page", page);
                req.setAttribute("size", size);
                req.setAttribute("totalPages", totalPages);

                req.setAttribute("totalUsers", userService.countAllUsers());
                req.setAttribute("totalTeachers", userService.countInstructors());
                req.setAttribute("totalActiveCourses", courseService.countActiveCourses());

                req.getRequestDispatcher("admin_dashboard.jsp").forward(req, resp);
                return;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

//        if ("add".equals(action)) {
//            Users u = new Users();
//            u.setUsername(req.getParameter("username"));
//            u.setEmail(req.getParameter("email"));
//            u.setPassword(req.getParameter("password"));
//            u.setRole(req.getParameter("role"));
//            u.setStatus(req.getParameter("status"));
//            u.setCreatedAt(java.time.LocalDateTime.now());
//
//            userService.addUser(u);
//            resp.sendRedirect(req.getContextPath() + "/AdminUserController?action=list");
//            return;
//        }
        if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));

            java.sql.Date dob = null;
            try {
                String dobStr = req.getParameter("date_of_birth");
                if (dobStr != null && !dobStr.isBlank()) {
                    // đảm bảo input type="date" sẽ gửi đúng yyyy-MM-dd
                    dob = java.sql.Date.valueOf(dobStr.trim());
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            userService.updateUser(
                    id,
                    req.getParameter("username"),
                    req.getParameter("email"),
                    req.getParameter("role"),
                    req.getParameter("status"),
                    req.getParameter("phone"),
                    dob,
                    req.getParameter("gender")
            );
            resp.sendRedirect(req.getContextPath() + "/AdminUserController?action=list");
            return;
        }

    }

    private static String safe(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }
}
