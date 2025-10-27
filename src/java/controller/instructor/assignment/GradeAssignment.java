/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.assignment;

import dal.RubricCriterionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;
import model.entity.AssignmentWork;
import model.entity.RubricCriterion;
import model.entity.Users;
import service.AssignmentWorkService;

/**
 *
 * @author Lenovo
 */
public class GradeAssignment extends HttpServlet {

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
            out.println("<title>Servlet GradeAssignment</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GradeAssignment at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private AssignmentWorkService workService = new AssignmentWorkService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));

            AssignmentWork work = workService.getAssignmentWorkDetail(assignmentId, studentId);

            if (work == null) {
                request.getRequestDispatcher("teacher/grade-assignments.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("work", work);
                request.setAttribute("assignment", work.getAssignment());
                RubricCriterionDAO rubricDAO = new RubricCriterionDAO();
                List<RubricCriterion> rubrics = rubricDAO.getByAssignmentId(assignmentId);
                request.setAttribute("rubrics", rubrics);
            }

            request.getRequestDispatcher("teacher/grade-assignment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            double score = Double.parseDouble(request.getParameter("score"));
            String feedback = request.getParameter("feedback");

            HttpSession session = request.getSession(false);
            Users user = (Users) session.getAttribute("user");

            if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("loginInternal");
                return;
            }

            AssignmentWorkService service = new AssignmentWorkService();
            boolean success = service.gradeAssignment(assignmentId, studentId, score, feedback, user.getUserId());

            response.sendRedirect("gradeListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("gradeListServlet");
        }
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
