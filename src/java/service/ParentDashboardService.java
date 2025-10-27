package service;

import java.util.*;

import model.entity.*;
import service.*;

public class ParentDashboardService {

    private final ParentLinkApprovalService linkService = new ParentLinkApprovalService();
    private final OrderService orderService = new OrderService();
    private final CourseRequestService courseRequestService = new CourseRequestService();
    private final ParentProgressService progressService = new ParentProgressService();

    public Map<String, Object> buildDashboard(Users parent) {
        int parentId = parent.getUserId();

        Map<String, Object> data = new HashMap<>();

        data.put("childAccounts", countApprovedChildren(parentId));
        data.put("purchasedCourses", countPurchasedCourses(parentId));
        data.put("activeCourses", countActiveCourses(parentId));
        data.put("pendingRequests", countPendingCourseRequests(parentId));
        data.put("pendingPayments", countPendingPayments(parentId));
        data.put("pendingPaymentsList", PendingPayments(parentId));
        data.put("children", getChildrenOverview(parentId));
        data.put("pendingApprovals", courseRequestService.getRequests(parentId, "pending"));
        data.put("linkRequests", getPendingLinkRequests(parentId)); 

        return data;
    }

    private int countApprovedChildren(int parentId) {
        List<ParentLinkRequest> approved = linkService.getRequestsByStatus(parentId, "approved");
        return approved != null ? approved.size() : 0;
    }

    private int countPurchasedCourses(int parentId) {
        List<Orders> orders = orderService.getOrdersByParentAndStatus(parentId, "paid");
        int count = 0;
        for (Orders o : orders) {
            if (o.getItems() != null) {
                count += o.getItems().size();
            }
        }
        return count;
    }

    private int countActiveCourses(int parentId) {
        List<Users> children = progressService.getChildrenByParent(parentId);
        int total = 0;
        for (Users c : children) {
            List<model.dto.CourseProgressDTO> progress = progressService.getCourseProgressByStudent(c.getUserId());
            for (var p : progress) {
                if (p.getProgressPctRequired() < 100) {
                    total++;
                }
            }
        }
        return total;
    }

    private int countPendingCourseRequests(int parentId) {
        List<CourseRequest> list = courseRequestService.getRequests(parentId, "pending");
        return list == null ? 0 : list.size();
    }

    private int countPendingPayments(int parentId) {
        List<CourseRequest> list = courseRequestService.getRequests(parentId, "unpaid");
        return list == null ? 0 : list.size();
    }

    private List<Map<String, Object>> getChildrenOverview(int parentId) {
        List<Users> children = progressService.getChildrenByParent(parentId);
        List<Map<String, Object>> list = new ArrayList<>();

        for (Users child : children) {
            Map<String, Object> childInfo = new HashMap<>();
            childInfo.put("studentId", child.getUserId());
            childInfo.put("fullName", child.getFullName());
            childInfo.put("email", child.getEmail());

            Map<String, Object> overview = progressService.getOverview(child.getUserId());
            int totalCourses = ((Number) overview.get("activeCourses")).intValue()
                    + ((Number) overview.get("completedCourses")).intValue();
            double avgProgress = (double) overview.get("avgProgress");

            childInfo.put("totalCourses", totalCourses);
            childInfo.put("progress", avgProgress);
            list.add(childInfo);
        }

        return list;
    }

    private List<ParentLinkRequest> getPendingLinkRequests(int parentId) {
        return linkService.getRequestsByStatus(parentId, "pending");
    }

    private List<CourseRequest> PendingPayments(int parentId) {
        List<CourseRequest> list = courseRequestService.getRequests(parentId, "unpaid");
        return list;
    }
}
