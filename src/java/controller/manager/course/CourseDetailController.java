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
import java.util.Map;
import model.entity.Course;
import model.entity.Users;
import service.CourseDetailService;
import service.CourseManagerService;
import model.entity.Module;
import model.entity.ModuleItem;
import model.entity.Users;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CourseDetailController", urlPatterns = {"/coursedetail"})
public class CourseDetailController extends HttpServlet {

    private final CourseManagerService courseService = new CourseManagerService();
    private final CourseDetailService detailService = new CourseDetailService();

  @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String idStr = request.getParameter("courseId");

        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu mã khóa học!");
            request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
            return;
        }

        try {
            int courseId = Integer.parseInt(idStr);

            if (!detailService.isCourseValid(courseId)) {
                request.setAttribute("errorMessage", "Khóa học không hợp lệ hoặc đã bị xóa.");
                request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
                return;
            }

            Course course = courseService.getCourseById(courseId);
            if (course == null) {
                session.setAttribute("errorMessage", "Không tìm thấy thông tin khóa học.");
                response.sendRedirect("coursemanager");
                return;
            }

            String createdDate = "";
            if (course.getCreatedAt() != null) {
                createdDate = course.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }

            Map<String, Object> data = detailService.getFullDetail(courseId);
            if (data == null) {
                request.setAttribute("errorMessage", "Không thể tải dữ liệu chi tiết khóa học.");
                request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
                return;
            }

            request.setAttribute("course", course);
            request.setAttribute("modules", data.get("modules"));
            request.setAttribute("items", data.get("items"));
            request.setAttribute("instructor", data.get("instructor"));
            request.setAttribute("stats", data.get("stats"));
            request.setAttribute("createdDate", createdDate);

            request.getRequestDispatcher("/views-manager/course-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã khóa học không hợp lệ.");
            request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải trang chi tiết khóa học.");
            request.getRequestDispatcher("/views-manager/course-manager.jsp").forward(request, response);
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
            session = request.getSession(true);
            session.setAttribute("errorMessage", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
            response.sendRedirect("loginInternal");
            return;
        }

        Users manager = (Users) session.getAttribute("user");
        if (manager == null || !"Manager".equalsIgnoreCase(manager.getRole())) {
            session.setAttribute("errorMessage", "Bạn không có quyền truy cập chức năng này.");
            response.sendRedirect("home");
            return;
        }

        Integer managerIdObj = (Integer) session.getAttribute("managerId");
        int managerId = (managerIdObj != null) ? managerIdObj : manager.getUserId();
        session.setAttribute("managerId", managerId);

        String action = request.getParameter("action");
        String idStr = request.getParameter("courseId");

        if (action == null || idStr == null || idStr.isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu tham số xử lý yêu cầu.");
            request.getRequestDispatcher("/views-manager/course-detail.jsp").forward(request, response);
            return;
        }

        try {
            int courseId = Integer.parseInt(idStr);
            String message = null;

            switch (action) {
                case "approve":
                    courseService.updateCourseStatus(courseId, "approved");
                    message = "Khóa học đã được duyệt thành công!";
                    break;

                case "reject": {
                    String reason = request.getParameter("rejectReason");
                    if (reason == null || reason.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Vui lòng nhập lý do từ chối!");
                    } else {
                        courseService.rejectCourseWithReason(courseId, managerId, reason.trim());
                        message = "Khóa học đã bị từ chối và phản hồi đã được gửi cho giảng viên.";
                    }
                    break;
                }

                case "publish": {
                    String publishDateStr = request.getParameter("publishDate");
                    if (publishDateStr != null && !publishDateStr.isEmpty()) {
                        LocalDate publishDate = LocalDate.parse(publishDateStr);
                        LocalDateTime publishDateTime = publishDate.atStartOfDay();
                        boolean success = courseService.schedulePublish(courseId, publishDateTime);
                        if (!success) {
                            request.setAttribute("errorMessage", "Ngày đăng không hợp lệ (phải sau hôm nay và trong vòng 1 năm).");
                        } else {
                            message = "Khóa học đã được lên lịch đăng thành công!";
                        }
                    } else {
                        request.setAttribute("errorMessage", "Vui lòng chọn ngày đăng!");
                    }
                    break;
                }

                case "unpublish":
                    courseService.unpublishCourse(courseId);
                    message = "Khóa học đã được gỡ đăng.";
                    break;

                case "updatePrice": {
                    String priceStr = request.getParameter("price");
                    if (priceStr == null || priceStr.isEmpty()) {
                        request.setAttribute("errorMessage", "Giá khóa học không được để trống!");
                    } else {
                        BigDecimal price = new BigDecimal(priceStr);
                        courseService.updateCoursePrice(courseId, price);
                        message = "Cập nhật giá khóa học thành công!";
                    }
                    break;
                }

                default:
                    request.setAttribute("errorMessage", "Hành động không hợp lệ: " + action);
                    break;
            }

            if (message != null) {
                session.setAttribute("message", message);
            }

            response.sendRedirect("coursedetail?courseId=" + idStr);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng mã khóa học không hợp lệ!");
            request.getRequestDispatcher("/views-manager/course-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình xử lý yêu cầu!");
            request.getRequestDispatcher("/views-manager/course-detail.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Course Detail Management for Manager";
    }
}