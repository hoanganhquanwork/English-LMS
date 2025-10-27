package service;

import dal.ReportDAO;
import java.util.List;
import model.entity.ReportType;
import model.entity.UserReport;

public class ReportService {

    private final ReportDAO reportDAO = new ReportDAO();

    public List<ReportType> getReportTypesForRole(String role) {
        if (role == null || role.isBlank()) {
            role = "Guest";
        }
        return reportDAO.getReportTypesByRole(role);
    }

    public boolean submitReport(int reporterId, int typeId, String description, String pageUrl) {
        if (description == null || description.trim().isEmpty()) {
            return false;
        }
        reportDAO.insertUserReport(reporterId, typeId, description.trim(), pageUrl);
        return true;
    }

    public List<UserReport> getReportsByUserPaged(int userId, int page, int size) {
        int offset = (page - 1) * size;
        return reportDAO.getReportsByUserPaged(userId, size, offset);
    }

    public int countReportsByUser(int userId) {
        return reportDAO.countReportsByUser(userId);
    }

    public List<UserReport> getAllReportsPaged(String role, Integer typeId, String status, int page, int size) {
        int offset = (page - 1) * size;
        return reportDAO.getAllReportsPaged(role, typeId, status, size, offset);
    }

    public int countAllReports(String role, Integer typeId, String status) {
        return reportDAO.countAllReports(role, typeId, status);
    }

    public List<String> getDistinctRoles() {
        return reportDAO.getDistinctRoles();
    }

    public List<ReportType> getAllReportTypes() {
        return reportDAO.getAllReportTypes();
    }

    public UserReport getReportDetail(int reportId) {
        return reportDAO.getReportDetail(reportId);
    }

    public boolean updateReportStatus(int reportId, String status, String adminNote) {
        if (status == null || status.isBlank()) {
            return false;
        }
        return reportDAO.updateReportStatus(reportId, status, adminNote);
    }

}
