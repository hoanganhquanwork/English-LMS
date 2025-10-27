package service;

import java.util.*;
import dal.ReportTypeDAO;
import model.entity.ReportType;

public class AdminReportTypeService {

    private final ReportTypeDAO dao = new ReportTypeDAO();

    public List<ReportType> getPagedTypes(String role, String status, String keyword, int page, int size) {
        int offset = (page - 1) * size;
        return dao.getReportTypes(role, status, keyword, offset, size);
    }

    public int getTotalPages(String role, String status, String keyword, int size) {
        int total = dao.countReportTypes(role, status, keyword);
        return (int) Math.ceil((double) total / size);
    }

    public ReportType getById(int id) {
        return dao.getById(id);
    }

    public boolean save(ReportType t) {
        if (t.getTypeId() > 0) {
            return dao.update(t);
        } else {
            return dao.insert(t);
        }
    }

    public boolean changeStatus(int id, String action) {
        boolean active = action.equalsIgnoreCase("activate");
        return dao.updateStatus(id, active);
    }

    public List<String> getAvailableRoles() {
        return Arrays.asList("Guest", "Student", "Instructor", "Manager", "Parent");
    }
}
