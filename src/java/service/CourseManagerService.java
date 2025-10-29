package service;

import dal.CourseManagerDAO;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import model.entity.Course;
import model.entity.Users;

public class CourseManagerService {

    private final CourseManagerDAO dao;

    public CourseManagerService() {
        this.dao = new CourseManagerDAO();
    }

    public List<Course> getFilteredCourses(String status, String keyword, String sort, String categoryIdString) {
        if (status == null || status.isEmpty()) {
            status = "all";
        }
        if (sort == null || sort.isEmpty()) {
            sort = "newest";
        }
        if (keyword == null) {
            keyword = "";
        }
        int categoryId = 0;
        try {
            if (categoryIdString != null && !categoryIdString.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdString);
            }
        } catch (Exception e) {
            categoryId = 0;
        }

        return dao.getFilteredCourses(status, keyword, sort, categoryId);
    }

    public String handleManagerAction(String action, String[] courseIds, String reason,
            BigDecimal price, Users manager) {
        if (action == null || action.trim().isEmpty()) {
            return "Hành động không hợp lệ.";
        }

        switch (action) {
            case "approve":
            case "bulkApprove":
                return handleApprove(courseIds);

            case "reject":
            case "bulkReject":
                return handleReject(courseIds, reason, manager);

            case "setPrice":
                return handleSetPrice(courseIds, price);

            default:
                return "Hành động không hợp lệ.";
        }
    }

    public List<Course> getFilterPublishCourse(String status, String keyword, String sort, String categoryIdString) {
        if (status == null || status.isEmpty()) {
            status = "all";
        }
        if (sort == null || sort.isEmpty()) {
            sort = "newest";
        }
        if (keyword == null) {
            keyword = "";
        }
        int categoryId = 0;
        try {
            if (categoryIdString != null && !categoryIdString.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdString);
            }
        } catch (Exception e) {
            categoryId = 0;
        }
        return dao.getFilteredCoursesForPublish(status, keyword, sort, categoryId);
    }

    public String handlePublishAction(String action, String[] courseIds, String dateStr) {
        if (action == null || action.isBlank()) {
            return "Hành động không hợp lệ.";
        }
        if (courseIds == null || courseIds.length == 0) {
            return "Vui lòng chọn ít nhất một khóa học.";
        }

        int successCount = 0;
        try {
            for (String idStr : courseIds) {
                int id = Integer.parseInt(idStr.trim());
                boolean success = false;

                if ("publish".equals(action)) {
                    success = publishNow(id);
                } else if ("unpublish".equals(action)) {
                    success = unpublishCourse(id);
                } else if ("republish".equals(action)) {
                    success = republishCourse(id);
                } else if ("schedule".equals(action)) {
                    success = scheduleValidatedPublish(id, dateStr);
                }

                if (success) {
                    successCount++;
                }
            }

            if (successCount == 0) {
                return "Không có khóa học nào được xử lý.";
            }

            if ("publish".equals(action)) {
                return "Đã đăng " + successCount + " khóa học.";
            } else if ("unpublish".equals(action)) {
                return "Đã gỡ đăng " + successCount + " khóa học.";
            } else if ("republish".equals(action)) {
                return "Đã đăng lại " + successCount + " khóa học.";
            } else if ("schedule".equals(action)) {
                return "Đã đặt lịch đăng cho " + successCount + " khóa học vào ngày " + dateStr + ".";
            } else {
                return "Hành động không hợp lệ.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "Đã xảy ra lỗi: " + e.getMessage();
        }
    }

    public void autoPublishIfDue() {
        dao.autoPublishIfDue();
    }

private String handleApprove(String[] courseIds) {
    if (courseIds == null || courseIds.length == 0) {
        return " Vui lòng chọn ít nhất một khóa học!";
    }

    int approvedCount = 0;
    StringBuilder invalidCourses = new StringBuilder();

    for (String idStr : courseIds) {
        try {
            int courseId = Integer.parseInt(idStr.trim());
            Course course = dao.getCourseById(courseId);

            if (course == null) {
                invalidCourses.append("[").append(courseId).append("] không tồn tại, ");
                continue;
            }

            BigDecimal price = course.getPrice();

            if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
                invalidCourses.append(course.getTitle())
                        .append(" (giá: ")
                        .append(price == null ? "chưa đặt" : price)
                        .append("), ");
                continue;
            }

            boolean success = dao.updateCourseStatus(courseId, "approved");
            if (success) {
                approvedCount++;
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    if (approvedCount == 0) {
        return "Không thể duyệt. Tất cả các khóa học được chọn đều chưa có giá hợp lệ.";
    }

    if (invalidCourses.length() > 0) {
        String invalidList = invalidCourses.substring(0, invalidCourses.length() - 2);
        return "Đã duyệt " + approvedCount + " khóa học, "
                + "nhưng bỏ qua các khóa chưa có giá hợp lệ: " + invalidList + ".";
    }

    return "Đã duyệt thành công " + approvedCount + " khóa học.";
}

    private String handleReject(String[] courseIds, String reason, Users manager) {
        if (courseIds == null || courseIds.length == 0) {
            return "Thiếu mã khóa học để từ chối!";
        }
        if (reason == null || reason.trim().isEmpty()) {
            return "Vui lòng nhập lý do từ chối.";
        }

        boolean allSuccess = true;
        for (String id : courseIds) {
            if (!rejectCourseWithReason(Integer.parseInt(id), manager.getUserId(), reason)) {
                allSuccess = false;
            }
        }

        if (allSuccess) {
            return "Đã từ chối " + courseIds.length + " khóa học.";
        } else {
            return "Một số khóa học bị lỗi khi cập nhật lý do.";
        }
    }

    private String handleSetPrice(String[] courseIds, BigDecimal price) {
        if (courseIds == null || courseIds.length == 0) {
            return "Thiếu mã khóa học để cập nhật giá.";
        }
        if (price == null || price.compareTo(BigDecimal.ZERO) < 0) {
            return "Giá không được nhỏ hơn 0.";
        }

        int courseId = Integer.parseInt(courseIds[0]);
        boolean updated = updateCoursePrice(courseId, price);

        if (updated) {
            return "Cập nhật giá thành công!";
        } else {
            return "Không thể cập nhật giá.";
        }
    }

    private boolean scheduleValidatedPublish(int courseId, String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return false;
        }

        LocalDate chosenDate = LocalDate.parse(dateStr);
        LocalDate today = LocalDate.now();

        if (chosenDate.isBefore(today) || chosenDate.isAfter(today.plusYears(1))) {
            System.out.println("Ngày đăng không hợp lệ: " + dateStr);
            return false;
        }

        LocalDateTime dateTime = chosenDate.atStartOfDay();
        return schedulePublish(courseId, dateTime);
    }

    public boolean updateCourseStatus(int courseId, String action) {
        if (courseId <= 0 || action == null || action.trim().isEmpty()) {
            return false;
        }

        Course course = dao.getCourseById(courseId);
        if (course == null) {
            return false;
        }

        String nextStatus = getNextStatus(course.getStatus(), action);
        if (nextStatus == null) {
            return false;
        }

        return dao.updateCourseStatus(courseId, nextStatus);
    }

    public boolean updateCoursePrice(int courseId, BigDecimal price) {
        if (courseId <= 0 || price == null || price.compareTo(BigDecimal.ZERO) < 0) {
            return false;
        }
        return dao.updateCoursePrice(courseId, price);
    }

    public Course getCourseById(int courseId) {
        if (courseId <= 0) {
            return null;
        }
        return dao.getCourseById(courseId);
    }

    public boolean publishNow(int courseId) {
        if (courseId <= 0) {
            return false;
        }
        return dao.publishNow(courseId);
    }

    public boolean unpublishCourse(int courseId) {
        if (courseId <= 0) {
            return false;
        }
        return dao.unpublishCourse(courseId);
    }

    public boolean republishCourse(int courseId) {
        if (courseId <= 0) {
            return false;
        }
        return dao.republishCourse(courseId);
    }

    public boolean schedulePublish(int courseId, LocalDateTime publishDate) {
        if (courseId <= 0 || publishDate == null) {
            return false;
        }
        return dao.schedulePublish(courseId, Timestamp.valueOf(publishDate));
    }

    public boolean rejectCourseWithReason(int courseId, int managerId, String reason) {
        if (courseId <= 0 || managerId <= 0) {
            return false;
        }
        if (reason == null || reason.trim().isEmpty()) {
            return false;
        }
        return dao.rejectCourseWithReason(courseId, managerId, reason);
    }

    private String getNextStatus(String current, String action) {
        if (current == null || action == null) {
            return null;
        }

        switch (action) {
            case "approved":
                if ("submitted".equals(current) || "rejected".equals(current)) {
                    return "approved";
                }
                break;
            case "rejected":
                if (!"publish".equals(current)) {
                    return "rejected";
                }
                break;
            case "publish":
                if ("approved".equals(current) || "unpublish".equals(current)) {
                    return "publish";
                }
                break;
            case "unpublish":
                if ("publish".equals(current)) {
                    return "unpublish";
                }
                break;
        }
        return null;
    }

    public String getRejectionReason(int courseId) {
        return dao.getRejectReasonByCourseId(courseId);
    }

    public String validateManagerAction(String action, int courseId, String reason, BigDecimal price, LocalDateTime publishDate) {
        if (action == null || action.isBlank()) {
            return "Thiếu hành động xử lý.";
        }
        if (courseId <= 0) {
            return "Mã khóa học không hợp lệ.";
        }

        switch (action) {
            case "approve":
            case "reject":
            case "publish":
            case "unpublish":
            case "updatePrice":
                break;
            default:
                return "Hành động không hợp lệ.";
        }

        if ("reject".equals(action)) {
            if (reason == null || reason.trim().isEmpty()) {
                return "Vui lòng nhập lý do từ chối.";
            }
        }

        if ("updatePrice".equals(action)) {
            if (price == null || price.compareTo(BigDecimal.ZERO) < 0) {
                return "Giá khóa học không được nhỏ hơn 0.";
            }
        }

        if ("publish".equals(action) && publishDate != null) {
            LocalDateTime now = LocalDateTime.now();
            if (publishDate.isBefore(now) || publishDate.isAfter(now.plusYears(1))) {
                return "Ngày đăng không hợp lệ (phải sau hôm nay và trong vòng 1 năm).";
            }
        }

        return null;
    }

    public String performAction(String action, int courseId, String reason, BigDecimal price, LocalDateTime publishDate, int managerId) {
        String validation = validateManagerAction(action, courseId, reason, price, publishDate);
        if (validation != null) {
            return validation;
        }

        switch (action) {
            case "approve":
                dao.updateCourseStatus(courseId, "approved");
                return "Khóa học đã được duyệt thành công!";

            case "reject":
                dao.rejectCourseWithReason(courseId, managerId, reason);
                return "Khóa học đã bị từ chối và phản hồi đã được gửi cho giảng viên.";

            case "publish":
                if (publishDate == null) {
                    return dao.publishNow(courseId)
                            ? "Khóa học đã được đăng ngay lập tức!"
                            : "Không thể đăng khóa học.";
                } else {
                    return dao.schedulePublish(courseId, java.sql.Timestamp.valueOf(publishDate))
                            ? "Khóa học đã được lên lịch đăng thành công!"
                            : "Không thể lên lịch đăng khóa học.";
                }

            case "unpublish":
                return dao.unpublishCourse(courseId)
                        ? "Khóa học đã được gỡ đăng."
                        : "Không thể gỡ đăng khóa học.";

            case "updatePrice":
                return dao.updateCoursePrice(courseId, price)
                        ? "Cập nhật giá khóa học thành công!"
                        : "Không thể cập nhật giá khóa học.";

            default:
                return "Hành động không hợp lệ!";
        }
    }
}
