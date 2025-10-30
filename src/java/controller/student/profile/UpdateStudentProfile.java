/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.profile;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import model.entity.Users;
import service.StudentService;
import service.UserService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "UpdateStudentProfile", urlPatterns = {"/updateStudentProfile"})
public class UpdateStudentProfile extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private UserService userService = new UserService();

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
            out.println("<title>Servlet UpdateStudentProfile</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateStudentProfile at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String success = (String) session.getAttribute("updateSuccess");
        if(success != null){
            request.setAttribute("updateSuccess", success);
            session.removeAttribute("updateSuccess");
        }
        request.setAttribute("student", studentService.getStudentProfile(user.getUserId()));
        request.getRequestDispatcher("/student/student-profile.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String dobRaw = request.getParameter("dob");
        String gender = request.getParameter("gender");

        String address = request.getParameter("address");
        String gradeLevel = request.getParameter("gradeLevel");
        String institution = request.getParameter("institution");
        try {
            LocalDate dob = null;
            if (!dobRaw.isBlank()) {
                dob = LocalDate.parse(dobRaw);
            }
            boolean ok = studentService.updateAll(user.getUserId(), fullName,
                    phone, dob, gender, address,
                    gradeLevel, institution
            );
            if (ok) {
                user = userService.getUserById(user.getUserId());
                session.setAttribute("user", user);
                request.setAttribute("updateSuccess", "Cập nhật hồ sơ thành công.");
            } else {
                request.setAttribute("updateFail", "Cập nhật thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("student", studentService.getStudentProfile(user.getUserId()));
        request.getRequestDispatcher("/student/student-profile.jsp").forward(request, response);
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
