/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import model.entity.CourseRequest;
import dal.CourseRequestDAO;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class CourseRequestService {

    private CourseRequestDAO crdao = new CourseRequestDAO();

    public List<CourseRequest> getListCourseRequest(int studentId, String status,
            String sort, String keyword, int page, int pageSize) {
        if (studentId < 0) {
            throw new IllegalArgumentException("StudentId không hợp lệ");
        }
        if (page < 1) {
            page = 1;
        }
        if (pageSize < 1) {
            pageSize = 10;
        }
        if (sort == null) {
            sort = "created";
        }
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        try {
            return crdao.searchCourseRequest(studentId, status, sort, keyword, page, pageSize);
        } catch (Exception e) {
            throw new RuntimeException("Yêu cầu thất bại", e);
        }
    }

    public int countCourseRequest(int studentId, String status, String keyword) {
        if (studentId <= 0) {
            throw new IllegalArgumentException("studentId must be positive");
        }

        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        try {
            return crdao.countCourseRequest(studentId, status, keyword);
        } catch (Exception e) {
            throw new RuntimeException("Yêu cầu thất bại", e);
        }
    }

    public int computeTotalPage(int pages, int pageSize) {
        if (pageSize <= 0) {
            return 0;
        }
        return (int) Math.ceil(pages / (double) pageSize);
    }

    public boolean resendCourseRequest(int requestId, int studentId) {
        if (requestId < 0) {
            throw new IllegalArgumentException("requestId không hợp lệ");
        }
        if (studentId < 0) {
            throw new IllegalArgumentException("studentId không hợp lệ");
        }

        try {
            return crdao.resendCourseRequest(requestId, studentId);
        } catch (Exception e) {
            throw new RuntimeException("Yêu cầu thất bại", e);
        }
    }

    public boolean cancelPendingRequest(int requestId, int studentId, String note) {
        if (requestId <= 0) {
            throw new IllegalArgumentException("requestId không hợp lệ");
        }
        if (studentId <= 0) {
            throw new IllegalArgumentException("studentId không hợp lệ");
        }

        if (note != null) {
            note = note.trim();
        }
        try {
            return crdao.cancelPendingRequest(requestId, studentId, note);
        } catch (Exception e) {
            throw new RuntimeException("cancelPendingRequest thất bại", e);
        }
    }

    public List<CourseRequest> getRequests(int parentId, String status) {
        return crdao.getRequestsByParentAndStatus(parentId, status);
    }

    public Map<String, Integer> getStatusCounts(int parentId) {
        return crdao.countByStatus(parentId);
    }

    public boolean parentCourseRequestAction(int requestId, String status) {
        if (status.equalsIgnoreCase("approved")) {
            return crdao.updateStatus(requestId, "unpaid");
        }
        return crdao.updateStatus(requestId, status);
    }

    public void updateNoteForRequest(int requestId, String note) {
        String reason = "[Phụ huynh] Lý do từ chối: ".concat(note);
        crdao.updateNoteForRequest(requestId, reason);
    }
}
