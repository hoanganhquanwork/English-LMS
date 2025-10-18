/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.assignment;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.entity.Assignment;
import model.entity.ModuleItem;
import service.AssignmentService;
import service.ModuleItemService;
import service.ModuleService;
import java.io.*;
import jakarta.servlet.http.*;

/**
 *
 * @author Lenovo
 */
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class UpdateAssignment extends HttpServlet {

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
            out.println("<title>Servlet UpdateAssignment</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateAssignment at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private ModuleService service = new ModuleService();
    private ModuleItemService contentService = new ModuleItemService();
    private AssignmentService aservice = new AssignmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        try {
            List<model.entity.Module> list = service.getModulesByCourse(courseId);
            Map<model.entity.Module, List<ModuleItem>> courseContent = contentService.getCourseContent(courseId);

            Assignment a = aservice.getAssignmentById(assignmentId);
            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("moduleList", list);
            request.setAttribute("assignment", a);
            request.setAttribute("content", courseContent);
            request.getRequestDispatcher("teacher/update-assignment.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       request.setCharacterEncoding("UTF-8");

        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));

            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String instructions = request.getParameter("description");
            String submissionType = request.getParameter("submissionType");
            String rubric = request.getParameter("gradingCriteria");
            double maxScore = Double.parseDouble(request.getParameter("maxScore"));
            String passStr = request.getParameter("passingScorePct");
            Double passing = (passStr == null || passStr.isEmpty()) ? null : Double.parseDouble(passStr);

            // Upload file
            Part filePart = request.getPart("attachments");
            String fileUrl = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = new File(filePart.getSubmittedFileName()).getName();
                String uploadPath = request.getServletContext().getRealPath("/uploads/assignment/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);
                fileUrl = "uploads/assignment/" + fileName;
            } else {
               
                Assignment old = aservice.getAssignmentById(assignmentId);
                fileUrl = old.getAttachmentUrl();
            }

            Assignment a = new Assignment();
            a.setAssignmentId(assignmentId);
            a.setTitle(title);
            a.setContent(content);
            a.setInstructions(instructions);
            a.setSubmissionType(submissionType);
            a.setAttachmentUrl(fileUrl);
            a.setMaxScore(maxScore);
            a.setPassingScorePct(passing);
            a.setRubric(rubric);

            boolean success = aservice.updateAssignment(a);
            if (success) {
                 response.sendRedirect("updateAssignment?courseId=" + courseId + "&moduleId=" + moduleId + "&assignmentId=" + assignmentId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật assignment: " + e.getMessage());
            request.getRequestDispatcher("instructor/update-assignment.jsp").forward(request, response);
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
