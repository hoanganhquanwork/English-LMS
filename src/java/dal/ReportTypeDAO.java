package dal;

import java.sql.*;
import java.util.*;
import model.entity.ReportType;

public class ReportTypeDAO extends DBContext {

    public List<ReportType> getReportTypes(String role, String status, String keyword, int offset, int size) {
        List<ReportType> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ReportTypes WHERE 1=1");

        if (role != null && !role.isEmpty()) {
            sql.append(" AND role = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND is_active = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        sql.append(" ORDER BY type_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int i = 1;
            if (role != null && !role.isEmpty()) {
                ps.setString(i++, role);
            }
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(i++, status.equals("1"));
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            ps.setInt(i++, offset);
            ps.setInt(i, size);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReportType t = new ReportType();
                t.setTypeId(rs.getInt("type_id"));
                t.setRole(rs.getString("role"));
                t.setName(rs.getString("name"));
                t.setActive(rs.getBoolean("is_active"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countReportTypes(String role, String status, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ReportTypes WHERE 1=1");

        if (role != null && !role.isEmpty()) {
            sql.append(" AND role = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND is_active = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

       try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int i = 1;
            if (role != null && !role.isEmpty()) {
                ps.setString(i++, role);
            }
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(i++, status.equals("1"));
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
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

    

    public ReportType getById(int id) {
        String sql = "SELECT * FROM ReportTypes WHERE type_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new ReportType(
                        rs.getInt("type_id"),
                        rs.getString("role"),
                        rs.getString("name"),
                        rs.getBoolean("is_active")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(ReportType t) {
        String sql = "UPDATE ReportTypes SET name=?, role=?, is_active=? WHERE type_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, t.getName());
            ps.setString(2, t.getRole());
            ps.setBoolean(3, t.isActive());
            ps.setInt(4, t.getTypeId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insert(ReportType t) {
        String sql = "INSERT INTO ReportTypes (role, name, is_active) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, t.getRole());
            ps.setString(2, t.getName());
            ps.setBoolean(3, t.isActive());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, boolean active) {
        String sql = "UPDATE ReportTypes SET is_active = ? WHERE type_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
