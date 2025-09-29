package dal;

import model.Users;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminUserDAO extends DBContext {

    public Users getById(int id) {
        String sql = "SELECT user_id, username, email, role, status, phone, date_of_birth, gender, created_at "
                   + "FROM users WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Users u = new Users();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("status"));
                    u.setPhone(rs.getString("phone"));
                    u.setGender(rs.getString("gender"));

                    Date dob = rs.getDate("date_of_birth");
                    if (dob != null) {
                        u.setDateOfBirth(dob.toLocalDate());
                    }

                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        u.setCreatedAt(ts.toLocalDateTime());
                    }
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int deleteById(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int countSearch(String keyword, String role, String status) {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1 ");
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sb.append(" AND (LOWER(username) LIKE ? OR LOWER(email) LIKE ?) ");
            String kw = "%" + keyword.toLowerCase().trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (role != null && !role.isBlank()) {
            sb.append(" AND role = ? ");
            params.add(role);
        }
        if (status != null && !status.isBlank()) {
            sb.append(" AND status = ? ");
            params.add(status);
        }

        try (PreparedStatement ps = connection.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Users> searchPaged(String keyword, String role, String status, int page, int size) {
        StringBuilder sb = new StringBuilder(
            "SELECT user_id, username, email, role, status, phone, gender, date_of_birth, created_at "
          + "FROM users WHERE 1=1 ");

        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sb.append(" AND (LOWER(username) LIKE ? OR LOWER(email) LIKE ?) ");
            String kw = "%" + keyword.toLowerCase().trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (role != null && !role.isBlank()) {
            sb.append(" AND role = ? ");
            params.add(role);
        }
        if (status != null && !status.isBlank()) {
            sb.append(" AND status = ? ");
            params.add(status);
        }

        // SQL Server paging
        sb.append(" ORDER BY created_at DESC, user_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        int offset = (page - 1) * size;
        params.add(offset);
        params.add(size);

        ArrayList<Users> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Users u = new Users();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("status"));
                    u.setPhone(rs.getString("phone"));
                    u.setGender(rs.getString("gender"));

                    Date dob = rs.getDate("date_of_birth");
                    if (dob != null) {
                        u.setDateOfBirth(dob.toLocalDate());
                    }

                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        u.setCreatedAt(ts.toLocalDateTime());
                    }
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAllUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countInstructors() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'Instructor'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int updateBasic(int id, String username, String email, String role, String status,
                           String phone, Date dob, String gender) {
        String sql = "UPDATE users SET username=?, email=?, role=?, status=?, phone=?, date_of_birth=?, gender=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, role);
            ps.setString(4, status);
            ps.setString(5, phone);
            ps.setDate(6, dob);
            ps.setString(7, gender);
            ps.setInt(8, id);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
