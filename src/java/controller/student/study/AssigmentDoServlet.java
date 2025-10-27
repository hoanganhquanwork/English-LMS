/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.study;

import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import model.dto.AssignmentDTO;
import model.dto.AssignmentWorkDTO;
import model.dto.RubricCriterionDTO;
import model.entity.StudentProfile;
import model.entity.Users;
import org.json.JSONObject;
import service.AssignmentService;
import util.DocxTextUtil;
import util.GeminiAPI;
import static util.ParseUtil.parseIntOrNull;

/**
 *
 * @author Admin
 */
@MultipartConfig
@WebServlet(name = "AssigmentDoServlet", urlPatterns = {"/assignmentDo"})
public class AssigmentDoServlet extends HttpServlet {

    AssignmentService assignmentService = new AssignmentService();

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
            out.println("<title>Servlet AssigmentDoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AssigmentDoServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        StudentProfile student = (session != null) ? (StudentProfile) session.getAttribute("student") : null;

        if (user == null || student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = student.getUserId();
        String submitType = request.getParameter("submitType");
        String submissionType = request.getParameter("submissionType");
        Integer courseId = parseIntOrNull(request.getParameter("courseId"));
        Integer assignmentId = parseIntOrNull(request.getParameter("assignmentId"));

        if (submitType.isEmpty() || courseId == null || assignmentId == null) {
            session.setAttribute("flashError", "Có lỗi trong quá trình nộp bài.");
            System.out.println("Thiếu tham số");
            return;
        }
        String textAnswer = null;
        String fileUrl = null;

        if ("text".equalsIgnoreCase(submissionType)) {
            textAnswer = request.getParameter("textAnswer");
            if (textAnswer.isBlank()) {
                session.setAttribute("flashError", "Nộp/lưu bài thất bại, bài làm không được để trống");
                response.sendRedirect(request.getContextPath()
                        + "/coursePage?courseId=" + (courseId != null ? courseId : "")
                        + "&itemId=" + (assignmentId != null ? assignmentId : ""));
                return;
            }
            if (textAnswer != null && !textAnswer.isBlank()) {
                assignmentService.saveDraft(assignmentId, studentId, "text", textAnswer, null);
            }
        } else if ("file".equalsIgnoreCase(submissionType)) {
            Part file = request.getPart("answerFile");

            // Lấy file cũ (nếu có)
            AssignmentWorkDTO cur = assignmentService.getAssigmentWork(assignmentId, studentId);
            String oldUrl = (cur != null ? cur.getFileUrl() : null);

            if (file != null && file.getSize() > 0) {
                //nếu chọn upload file mới
                String original = Paths.get(file.getSubmittedFileName()).getFileName().toString();
                String low = original.toLowerCase();
                if (!(low.endsWith(".docx") || low.endsWith(".mp3")
                        || "audio/mpeg".equalsIgnoreCase(file.getContentType()))) {
                    session.setAttribute("flashError", "Tệp tải lên không hợp lệ");
                    response.sendRedirect(request.getContextPath()
                            + "/coursePage?courseId=" + (courseId != null ? courseId : "")
                            + "&itemId=" + (assignmentId != null ? assignmentId : ""));
                    return;
                }
                String savePath = request.getServletContext().getRealPath("/uploads/assignmentWork") + File.separator + original;
                file.write(savePath);
                fileUrl = "uploads/assignmentWork" + "/" + original;
                assignmentService.saveDraft(assignmentId, studentId, "file", null, fileUrl);

            } else {
                //không chọn file mới
                if ("draft".equalsIgnoreCase(submitType)) {
                    fileUrl = oldUrl;
                } else if ("submit".equalsIgnoreCase(submitType) || "aiGrade".equalsIgnoreCase(submitType)) {
                    if (oldUrl != null && !oldUrl.isBlank()) {
                        fileUrl = oldUrl;
                    } else {
                        session.setAttribute("flashError", "Vui lòng chọn tệp trước khi nộp.");
                        response.sendRedirect(request.getContextPath()
                                + "/coursePage?courseId=" + courseId + "&itemId=" + assignmentId);
                        return;
                    }
                }
            }
        }

        try {
            if ("draft".equalsIgnoreCase(submitType)) {
                boolean ok = assignmentService.saveDraft(
                        assignmentId, studentId, submissionType,
                        "text".equalsIgnoreCase(submissionType) ? textAnswer : null,
                        "file".equalsIgnoreCase(submissionType) ? fileUrl : null
                );
            } else if ("submit".equalsIgnoreCase(submitType)) {
                boolean ok = assignmentService.submit(
                        assignmentId, studentId, submissionType,
                        "text".equalsIgnoreCase(submissionType) ? textAnswer : null,
                        "file".equalsIgnoreCase(submissionType) ? fileUrl : null
                );
            } else if ("aiGrade".equalsIgnoreCase(submitType)) {
                AssignmentWorkDTO work = assignmentService.getAssigmentWork(assignmentId, studentId);
                if (work == null) {
                    session.setAttribute("flashError", "Chưa có bài để chấm.");
                    response.sendRedirect(request.getContextPath()
                            + "/coursePage?courseId=" + (courseId != null ? courseId : "")
                            + "&itemId=" + (assignmentId != null ? assignmentId : ""));
                    return;
                }
                String textForAI;
                if ("text".equalsIgnoreCase(submissionType)) {
                    textForAI = (work.getTextAnswer() == null) ? "" : work.getTextAnswer().trim();
                } else {
                    String url = work.getFileUrl();
                    if (url == null || url.isBlank() || !url.toLowerCase().endsWith(".docx")) {
                        session.setAttribute("flashError", "Không tìm thấy tệp .docx để chấm.");
                        response.sendRedirect(request.getContextPath()
                                + "/coursePage?courseId=" + (courseId != null ? courseId : "")
                                + "&itemId=" + (assignmentId != null ? assignmentId : ""));
                        return;
                    }
                    File docx = new File(request.getServletContext().getRealPath("/") + url);
                    textForAI = DocxTextUtil.extractText(docx);
                    if (toString().isBlank()) {
                        session.setAttribute("flashError", "Không đọc được nội dung .docx.");
                        response.sendRedirect(request.getContextPath()
                                + "/coursePage?courseId=" + (courseId != null ? courseId : "")
                                + "&itemId=" + (assignmentId != null ? assignmentId : ""));
                        return;
                    }
                }
                System.out.println(textForAI);
                // Gọi API Gemini để chấm bài
                String prompt = constructGeminiPrompt(assignmentId, textForAI);
                JsonObject geminiResponse = GeminiAPI.callGeminiAPI(prompt);

                GeminiAPI.AssignmentFeedback feedback = GeminiAPI.parseGeminiResponse(geminiResponse);

                // Cập nhật điểm và phản hồi vào cơ sở dữ liệu
                assignmentService.gradeAssignment(assignmentId, studentId, feedback.getScore(), feedback.getFeedback(), null);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath()
                + "/coursePage?courseId=" + (courseId != null ? courseId : "")
                + "&itemId=" + (assignmentId != null ? assignmentId : ""));
    }


    private String constructGeminiPrompt(int assignmentId, String textForAI) {
        AssignmentDTO assignment = assignmentService.getAssignmentWithRubric(assignmentId);
        StringBuilder promptBuilder = new StringBuilder();
        
        promptBuilder.append("You are an expert, automated grading system. Your task is to evaluate the student's submission based on the provided rubric and return a JSON object containing the final score and detailed feedback.\n\n");
        
        promptBuilder.append("GRADING RULES:\n");
        promptBuilder.append("1. Score each criterion on a scale of **0 to 5**.\n");
        promptBuilder.append("2. Calculate the Final Score (out of 100) using the formula: **score_norm** = criterion score / 5. **Final Score** = (Σ(score_norm * criterion weight)) * 100.\n");
        promptBuilder.append("3. The final output MUST be a JSON object conforming to the required schema (fields: score, feedback).\n\n");
        
        promptBuilder.append("ASSIGNMENT REQUIREMENTS:\n").append(assignment.getPromptSummary()).append("\n\n");
        
        promptBuilder.append("STUDENT SUBMISSION:\n").append(textForAI).append("\n\n");
        
        promptBuilder.append("GRADING RUBRIC:\n");
        List<RubricCriterionDTO> rubric = assignment.getRubric();
        if (rubric != null && !rubric.isEmpty()) {
            for (RubricCriterionDTO criterion : rubric) {
                promptBuilder.append("- CRITERION: ").append(criterion.getGuidance())
                        .append(" | WEIGHT: ").append(criterion.getWeight()).append("\n");
            }
        } else {
            promptBuilder.append("No specific rubric criteria provided. Score the submission based on overall quality (0-100).\n");
        }
        
        promptBuilder.append("\nOUTPUT INSTRUCTION:\n");
        promptBuilder.append("Provide a detailed, constructive analysis of the submission in the 'feedback' field, addressing each criterion (Max 80 words). The 'score' must be the calculated Final Score (0-100).");
        
        return promptBuilder.toString();
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
