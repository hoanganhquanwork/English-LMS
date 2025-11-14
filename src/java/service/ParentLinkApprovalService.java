package service;

import dal.ParentLinkRequestDAO;
import model.entity.ParentLinkRequest;
import java.util.List;

public class ParentLinkApprovalService {

    private final ParentLinkRequestDAO requestDAO = new ParentLinkRequestDAO();

    public void approveRequest(int requestId, String note) {
        ParentLinkRequest req = requestDAO.getRequestById(requestId);
        if (req != null && "pending".equalsIgnoreCase(req.getStatus())) {
            requestDAO.updateRequestStatus(requestId, "approved", note);
            requestDAO.linkStudentToParent(req.getStudentId(), req.getParentId());
        }
    }

    public void rejectRequest(int requestId, String note) {
        ParentLinkRequest req = requestDAO.getRequestById(requestId);
        if (req != null && "pending".equalsIgnoreCase(req.getStatus())) {
            requestDAO.updateRequestStatus(requestId, "rejected", note);
        }
    }

    public void cancelRequest(int requestId, String note) {
        ParentLinkRequest req = requestDAO.getRequestById(requestId);
        if (req != null && "approved".equalsIgnoreCase(req.getStatus())) {
            requestDAO.updateRequestStatus(requestId, "unlink", note);
            requestDAO.unlinkStudentFromParent(req.getStudentId());
            requestDAO.cancelPendingCourseRequest(req.getStudentId(),req.getParentId());
        }
    }

    public List<ParentLinkRequest> getRequestsByStatus(int parentId, String status) {
        return requestDAO.getRequestsByParentAndStatus(parentId, status);

    }
}
