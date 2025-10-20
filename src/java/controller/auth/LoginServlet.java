/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.UUID;
import model.entity.StudentProfile;
import model.entity.Users;
import service.AuthService;
import service.StudentService;
import service.TokenService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private final AuthService authService = new AuthService();
    private final TokenService tokenService = new TokenService();
    private final StudentService studentService = new StudentService();

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession s = request.getSession(false);
        if (s != null && s.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }
        Cookie cookies[] = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberToken".equalsIgnoreCase(c.getName())) {
                    String rawToken = c.getValue();
                    if (rawToken != null && !rawToken.isBlank()) {
                        Users user = tokenService.getUserByRememberToken(rawToken);
                        if (user != null && "active".equalsIgnoreCase(user.getStatus())) {
                            HttpSession session = request.getSession(true);
                            session.setAttribute("user", user);
                            response.sendRedirect("home");
                            return;
                        } else {
                            //Wrong or expired token -> remove
                            tokenService.deleteRememberToken(rawToken);
                            c.setValue("");
                            c.setPath("/");
                            c.setMaxAge(0);
                            response.addCookie(c);
                        }
                    }
                }
            }
        }
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
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
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember-me");
        
        Users user = authService.getUserByLogin(username, password);
        if (user != null) {
            HttpSession session = request.getSession(true);
            String role = user.getRole();
            if (!role.equalsIgnoreCase("Student") && !role.equalsIgnoreCase("Parent")) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp?errorRole=true");
                return;
            }
            session.setAttribute("user", user);
            session.setAttribute("role", role);
            if (role.equalsIgnoreCase("Student")) {
                StudentProfile s = studentService.getStudentProfile(user.getUserId());
                session.setAttribute("student", s);
            }
            
            if (rememberMe != null) {
                authService.createRememberMe(user, response);
            }
            
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        boolean isInactive = authService.isInactiveUser(username, password);
        if (isInactive) {
            request.setAttribute("inactive", "Tài khoản đã bị vô hiệu hóa");
        } else {
            request.setAttribute("errorLogin", "Tên đăng nhập hoặc mật khẩu sai");
            request.setAttribute("username", username);
        }
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
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
