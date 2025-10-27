package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.ReportType;
import model.entity.UserReport;

public class ReportDAO extends DBContext {

    public List<ReportType> getReportTypesByRole(String role) {
        List<ReportType> list = new ArrayList<>();
        String sql = """
            SELECT type_id, name
            FROM ReportTypes
            WHERE role = ? AND is_active = 1
            ORDER BY name
        """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReportType t = new ReportType();
                    t.setTypeId(rs.getInt("type_id"));
                    t.setName(rs.getString("name"));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertUserReport(int reporterId, int typeId, String description, String pageUrl) {
        String sql = "INSERT INTO UserReports (reporter_id, type_id, description, page_url, created_at) "
                + "VALUES (?,?,?, ?, SYSDATETIME())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reporterId);
            ps.setInt(2, typeId);
            ps.setString(3, description);
            ps.setString(4, pageUrl);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateReportStatus(int reportId, String status, String adminNote) {
        String sql = """
        UPDATE UserReports
        SET status = ?, admin_note = ?, updated_at = GETDATE()
        WHERE report_id = ?
    """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, reportId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<UserReport> getReportsByUserPaged(int userId, int limit, int offset) {
        List<UserReport> list = new ArrayList<>();
        String sql = """
            SELECT ur.report_id, rt.name AS type_name, ur.description,
                   ur.status, ur.created_at, ur.updated_at, ur.admin_note
            FROM UserReports ur
            JOIN ReportTypes rt ON ur.type_id = rt.type_id
            WHERE ur.reporter_id = ?
            ORDER BY ur.created_at DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;
        """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserReport r = new UserReport();
                r.setReportId(rs.getInt("report_id"));
                r.setTypeName(rs.getString("type_name"));
                r.setDescription(rs.getString("description"));
                r.setStatus(rs.getString("status"));
                r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                Timestamp updated = rs.getTimestamp("updated_at");
                if (updated != null) {
                    r.setUpdatedAt(updated.toLocalDateTime());
                }
                r.setAdminNote(rs.getString("admin_note"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countReportsByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM UserReports WHERE reporter_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<UserReport> getAllReportsPaged(String role, Integer typeId, String status, int limit, int offset) {
        List<UserReport> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT ur.report_id, u.full_name, u.role, rt.name AS type_name,
                   ur.description, ur.status, ur.created_at, ur.admin_note
            FROM UserReports ur
            JOIN Users u ON ur.reporter_id = u.user_id
            JOIN ReportTypes rt ON ur.type_id = rt.type_id
        """);

        if (role != null && !role.isBlank()) {
            sql.append(" AND u.role = ?");
        }
        if (typeId != null) {
            sql.append(" AND ur.type_id = ?");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND ur.status = ?");
        }
        sql.append(" ORDER BY ur.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;");

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (role != null && !role.isBlank()) {
                ps.setString(idx++, role);
            }
            if (typeId != null) {
                ps.setInt(idx++, typeId);
            }
            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserReport r = new UserReport();
                r.setReportId(rs.getInt("report_id"));
                r.setDescription(rs.getString("description"));
                r.setStatus(rs.getString("status"));
                r.setAdminNote(rs.getString("admin_note"));
                r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                r.setTypeName(rs.getString("type_name"));
                r.setReporterName(rs.getString("full_name"));
                r.setReporterRole(rs.getString("role"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAllReports(String role, Integer typeId, String status) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM UserReports ur
            JOIN Users u ON ur.reporter_id = u.user_id
        """);

        if (role != null && !role.isBlank()) {
            sql.append(" AND u.role = ?");
        }
        if (typeId != null) {
            sql.append(" AND ur.type_id = ?");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND ur.status = ?");
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (role != null && !role.isBlank()) {
                ps.setString(idx++, role);
            }
            if (typeId != null) {
                ps.setInt(idx++, typeId);
            }
            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<String> getDistinctRoles() {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT DISTINCT role FROM Users WHERE role IN ('Student','Parent','Instructor','Manager','Guest')";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(rs.getString(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }

    public List<ReportType> getAllReportTypes() {
        List<ReportType> list = new ArrayList<>();
        String sql = "SELECT type_id, role, name FROM ReportTypes WHERE is_active = 1 ORDER BY role, name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReportType rt = new ReportType();
                rt.setTypeId(rs.getInt("type_id"));
                rt.setRole(rs.getString("role"));
                rt.setName(rs.getString("name"));
                list.add(rt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public UserReport getReportDetail(int reportId) {
        String sql = """
        SELECT ur.*, u.full_name, u.email, u.role, rt.name AS type_name
        FROM UserReports ur
        JOIN Users u ON ur.reporter_id = u.user_id
        JOIN ReportTypes rt ON ur.type_id = rt.type_id
        WHERE ur.report_id = ?
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserReport r = new UserReport();
                r.setReportId(rs.getInt("report_id"));
                r.setReporterId(rs.getInt("reporter_id"));
                r.setTypeId(rs.getInt("type_id"));
                r.setDescription(rs.getString("description"));
                r.setPageUrl(rs.getString("page_url"));
                r.setStatus(rs.getString("status"));
                r.setAdminNote(rs.getString("admin_note"));
                r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                r.setUpdatedAt(rs.getTimestamp("updated_at") != null
                        ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
                r.setReporterName(rs.getString("full_name"));
                r.setReporterEmail(rs.getString("email"));
                r.setReporterRole(rs.getString("role"));
                r.setTypeName(rs.getString("type_name"));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
