package service;

import dal.CourseManagerDAO;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import model.entity.Course;

public class CourseManagerService {

    private final CourseManagerDAO dao;

    public CourseManagerService() {
        this.dao = new CourseManagerDAO();
    }

    public List<Course> getFilteredCourses(String status, String keyword, String sort) {
        if (status == null || status.isEmpty()) status = "all";
        if (sort == null || sort.isEmpty()) sort = "newest";

        return dao.getFilteredCourses(status, keyword, sort);
    }

    public boolean updateCourseStatus(int courseId, String action) {
        if (courseId <= 0 || action == null || action.isBlank()) {
            return false;
        }

        Course course = dao.getCourseById(courseId);
        if (course == null) {
            return false;
        }

        String currentStatus = course.getStatus();
        String nextStatus = getNextStatus(currentStatus, action);
        if (nextStatus == null) {
            return false;
        }

        return dao.updateCourseStatus(courseId, nextStatus);
    }
    private String getNextStatus(String current, String action) {
        if (current == null || action == null) return null;

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
    public boolean updateCoursePrice(int courseId, BigDecimal price) {
        if (courseId <= 0 || price == null) return false;
        if (price.compareTo(BigDecimal.ZERO) < 0) return false;
        return dao.updateCoursePrice(courseId, price);
    }
    public Course getCourseById(int courseId) {
        if (courseId <= 0) return null;
        return dao.getCourseById(courseId);
    }

    public List<Course> getFilterPublishCourse(String status, String keyword, String sort) {
        if (status == null || status.isEmpty()) status = "all";
        if (sort == null || sort.isEmpty()) sort = "newest";
        return dao.getFilteredCoursesForPublish(status, keyword, sort);
    }
    public boolean publishNow(int courseId) {
        if (courseId <= 0) return false;
        return dao.publishNow(courseId);
    }
    public boolean unpublishCourse(int courseId) {
        if (courseId <= 0) return false;
        return dao.unpublishCourse(courseId);
    }

    public boolean republishCourse(int courseId) {
        if (courseId <= 0) return false;
        return dao.republishCourse(courseId);
    }

    public boolean schedulePublish(int courseId, LocalDateTime publishDate) {
        if (courseId <= 0 || publishDate == null) return false;

        LocalDate today = LocalDate.now();
        LocalDate date = publishDate.toLocalDate();

        if (date.isBefore(today)) {
            System.out.println(" Lỗi: Ngày đăng không được nhỏ hơn hôm nay.");
            return false;
        }
        if (date.isAfter(today.plusYears(1))) {
            System.out.println("Lỗi: Ngày đăng không được vượt quá 1 năm.");
            return false;
        }

        return dao.schedulePublish(courseId, Timestamp.valueOf(publishDate));
    }

    public boolean rejectCourseWithReason(int courseId, int managerId, String reason) {
        if (courseId <= 0 || managerId <= 0) return false;
        if (reason == null || reason.trim().isEmpty()) return false;
        return dao.rejectCourseWithReason(courseId, managerId, reason);
    }


    public void autoPublishIfDue() {
        dao.autoPublishIfDue();
    }
      public String getRejectionReason(int courseId) {
        return dao.getRejectReasonByCourseId(courseId);
    }
}