/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.course;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import service.InstructorService;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "InstructorDashboardController", urlPatterns = {"/instructorDashboard"})
public class InstructorDashboardController extends HttpServlet {

    private InstructorService instructorService = new InstructorService();

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
            out.println("<title>Servlet InstructorDashboardController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorDashboardController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("auth/login.jsp"); 
            return;
        }

        Users user = (Users) session.getAttribute("user");

        
        if (!"Instructor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("home.jsp");
            return;
        }

        int instructorId = user.getUserId(); 

        int courseCount = instructorService.getCourseCount(instructorId);
        int studentCount = instructorService.getActiveStudentCount(instructorId);

        request.setAttribute("courseCount", courseCount);
        request.setAttribute("studentCount", studentCount);

        request.getRequestDispatcher("teacher/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
