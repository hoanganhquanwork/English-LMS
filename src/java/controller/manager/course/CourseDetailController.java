/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager.course;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import model.dto.QuestionDTO;
import model.dto.QuestionListItemDTO;
import model.dto.QuizDTO;
import model.entity.Course;
import model.entity.Users;
import service.CourseDetailService;
import service.CourseManagerService;
import model.entity.Module;
import model.entity.ModuleItem;
import service.QuestionManagerService;


/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CourseDetailController", urlPatterns = {"/coursedetail"})
public class CourseDetailController extends HttpServlet {

    private final CourseManagerService cService = new CourseManagerService();
    private final CourseDetailService dService = new CourseDetailService();
    private final QuestionManagerService qService = new QuestionManagerService();

   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users manager = (Users) session.getAttribute("user");

        if (manager == null || !"Manager".equalsIgnoreCase(manager.getRole())) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập bằng tài khoản Quản lý!");
            response.sendRedirect("loginInternal");
            return;
        }

        String idStr = request.getParameter("courseId");
        if (idStr == null || idStr.isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu mã khóa học!");
            response.sendRedirect("coursemanager");
            return;
        }

        try {
            int courseId = Integer.parseInt(idStr);

            if (!dService.isCourseValid(courseId)) {
                session.setAttribute("errorMessage", "Khóa học không hợp lệ hoặc đã bị xóa!");
                response.sendRedirect("coursemanager");
                return;
            }

            Course course = cService.getCourseById(courseId);
            if (course == null) {
                session.setAttribute("errorMessage", "Không tìm thấy thông tin khóa học!");
                response.sendRedirect("coursemanager");
                return;
            }

            Map<String, Object> data = dService.getCourseDetail(courseId);
            if (data == null || data.containsKey("error")) {
                request.setAttribute("errorMessage", data != null ? data.get("error") : "Không thể tải dữ liệu khóa học.");
                request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
                return;
            }

            List<QuestionDTO> questions = (List<QuestionDTO>) data.get("questions");
            if (questions != null) {
                for (QuestionDTO q : questions) {
                    q.setOptions(qService.getOptionsByQuestionId(q.getQuestionId()));
                    q.setAnswers(qService.getAnswersByQuestionId(q.getQuestionId()));
                }
            }

            request.setAttribute("course", course);
            request.setAttribute("modules", data.get("modules"));
            request.setAttribute("items", data.get("items"));
            request.setAttribute("stats", data.get("stats"));
            request.setAttribute("quizzes", data.get("quizzes"));
            request.setAttribute("questions", questions);
            request.setAttribute("instructor", data.get("instructor"));

            if (course.getCreatedAt() != null) {
                request.setAttribute("createdDate",
                        course.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            }

            request.getRequestDispatcher("/views-manager/course-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Mã khóa học không hợp lệ!");
            response.sendRedirect("coursemanager");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải trang chi tiết khóa học!");
            response.sendRedirect("coursemanager");
        }
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
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("loginInternal");
            return;
        }

        Users manager = (Users) session.getAttribute("user");
        if (manager == null || !"Manager".equalsIgnoreCase(manager.getRole())) {
            session.setAttribute("errorMessage", "Bạn không có quyền truy cập chức năng này.");
            response.sendRedirect("home");
            return;
        }

        String idStr = request.getParameter("courseId");
        String action = request.getParameter("action");

        if (idStr == null || idStr.isEmpty() || action == null) {
            session.setAttribute("errorMessage", "Thiếu tham số xử lý yêu cầu.");
            response.sendRedirect("coursemanager");
            return;
        }

        try {
            int courseId = Integer.parseInt(idStr);

            String reason = request.getParameter("rejectReason");
            String publishDateStr = request.getParameter("publishDate");
            String priceStr = request.getParameter("price");

            BigDecimal price = (priceStr != null && !priceStr.isEmpty()) ? new BigDecimal(priceStr) : null;

            LocalDateTime publishDate = (publishDateStr != null && !publishDateStr.isEmpty())
                    ? LocalDate.parse(publishDateStr).atStartOfDay() : null;

            String resultMessage = cService.performAction(
                    action, courseId, reason, price, publishDate, manager.getUserId()
            );

            if (resultMessage.contains("thành công") || resultMessage.contains("đã")) {
                session.setAttribute("message", resultMessage);
            } else {
                session.setAttribute("errorMessage", resultMessage);
            }

            response.sendRedirect("coursedetail?courseId=" + idStr);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Định dạng mã khóa học không hợp lệ!");
            response.sendRedirect("coursemanager");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình xử lý yêu cầu!");
            response.sendRedirect("coursemanager");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}