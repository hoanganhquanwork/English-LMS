package dal;

import model.Users;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public int countAllUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countInstructors() {
        return countByRole("Instructor");
    }

    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT user_id, username, email, role, status, created_at FROM Users";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    u.setCreatedAt(ts.toLocalDateTime());
                }
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addUser(Users u) {
        String sql = "INSERT INTO Users (username, email, password, role, status, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getStatus());
            ps.setTimestamp(6, Timestamp.valueOf(u.getCreatedAt()));

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE user_id=?";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateUser(int userId, String username, String email, String role, String status) {
        String sql = "UPDATE Users SET username=?, email=?, role=?, status=? WHERE user_id=?";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, role);
            ps.setString(4, status);
            ps.setInt(5, userId);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Users getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Users> searchUsers(String keyword, String role, String status) {
        List<Users> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT user_id, username, email, role, status, created_at FROM Users WHERE 1=1 "
        );

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (username LIKE ? OR email LIKE ?) ");
        }
        if (role != null && !role.isEmpty()) {
            sql.append("AND role=? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND status=? ");
        }

        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }
            if (role != null && !role.isEmpty()) {
                ps.setString(idx++, role);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    u.setCreatedAt(ts.toLocalDateTime());
                }
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = ?";
        try (Connection con = new DBContext().connection; PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private PreparedStatement buildSearchStatement(Connection con, String baseSql,
            String keyword, String role, String status) throws SQLException {
        StringBuilder sb = new StringBuilder(baseSql).append(" WHERE 1=1 ");
        if (keyword != null && !keyword.isBlank()) {
            sb.append(" AND (username LIKE ? OR email LIKE ?) ");
        }
        if (role != null && !role.isBlank()) {
            sb.append(" AND role = ? ");
        }
        if (status != null && !status.isBlank()) {
            sb.append(" AND status = ? ");
        }
        PreparedStatement ps = con.prepareStatement(sb.toString());
        int idx = 1;
        if (keyword != null && !keyword.isBlank()) {
            ps.setString(idx++, "%" + keyword + "%");
            ps.setString(idx++, "%" + keyword + "%");
        }
        if (role != null && !role.isBlank()) {
            ps.setString(idx++, role);
        }
        if (status != null && !status.isBlank()) {
            ps.setString(idx++, status);
        }
        return ps;
    }

    public int countSearchUsers(String keyword, String role, String status) {
        String base = "SELECT COUNT(*) FROM Users";
        try (Connection con = new DBContext().connection; PreparedStatement ps = buildSearchStatement(con, base, keyword, role, status); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Users> searchUsersPaged(String keyword, String role, String status, int page, int size) {
        List<Users> list = new ArrayList<>();
        int offset = (page - 1) * size;

        String base = "SELECT user_id, username, email, role, status, created_at FROM Users";

        String orderLimit
                = " ORDER BY CASE WHEN created_at IS NULL THEN 1 ELSE 0 END, "
                + "          created_at DESC, user_id DESC "
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = new DBContext().connection) {
            StringBuilder sb = new StringBuilder(base).append(" WHERE 1=1 ");
            if (keyword != null && !keyword.isBlank()) {
                sb.append(" AND (username LIKE ? OR email LIKE ?) ");
            }
            if (role != null && !role.isBlank()) {
                sb.append(" AND role = ? ");
            }
            if (status != null && !status.isBlank()) {
                sb.append(" AND status = ? ");
            }
            sb.append(orderLimit);

            PreparedStatement ps = con.prepareStatement(sb.toString());
            int idx = 1;
            if (keyword != null && !keyword.isBlank()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }
            if (role != null && !role.isBlank()) {
                ps.setString(idx++, role);
            }
            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, size);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    u.setCreatedAt(ts.toLocalDateTime());
                }
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
