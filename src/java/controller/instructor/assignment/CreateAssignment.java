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
import model.entity.Assignment;
import service.AssignmentService;
import java.io.*;
import jakarta.servlet.http.*;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024, // 10MB
        maxRequestSize = 15 * 1024 * 1024)
public class CreateAssignment extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateAssignment</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateAssignment at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private AssignmentService assignmentService = new AssignmentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));

            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String instructions = request.getParameter("description");
            String submissionType = request.getParameter("submissionType");
            String rubric = request.getParameter("gradingCriteria");
            boolean isAiGradeAllowed = "true".equals(request.getParameter("aiGrading"));
            String promptSummary = request.getParameter("promptSummary");

          
            String passingStr = request.getParameter("passingScorePct");
            Double passingScorePct = (passingStr == null || passingStr.isEmpty())
                    ? null : Double.parseDouble(passingStr);

            // 🔹 Xử lý upload file
            Part filePart = request.getPart("attachments");
            String fileUrl = null;

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = new File(filePart.getSubmittedFileName()).getName();
                String uploadPath = request.getServletContext().getRealPath("/uploads/assignment/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                // Lưu đường dẫn tương đối để hiển thị trong JSP
                fileUrl = "uploads/assignment/" + fileName;
            }

            String[] nos = request.getParameterValues("criterion_no");
            String[] guidances = request.getParameterValues("guidance");
            String[] weights = request.getParameterValues("weight");
            // 🔹 Gói dữ liệu Assignment
            Assignment a = new Assignment();
            a.setTitle(title);
            a.setContent(content);
            a.setInstructions(instructions);
            a.setSubmissionType(submissionType);
            a.setAttachmentUrl(fileUrl);
            a.setPassingScorePct(passingScorePct);         
            a.setAiGradeAllowed(isAiGradeAllowed);
            a.setPromptSummary(promptSummary);

            // 🔹 Gọi Service để lưu DB
              int newId = assignmentService.createAssignment(moduleId, a, nos, guidances, weights);


            if (newId != -1) {
                response.sendRedirect("updateAssignment?courseId=" + courseId + "&moduleId=" + moduleId + "&assignmentId=" + newId);
            } else {
                request.setAttribute("error", "Không thể tạo Assignment mới. Vui lòng thử lại.");
                request.getRequestDispatcher("teacher/create-assignment.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi tạo Assignment: " + e.getMessage(), e);
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
