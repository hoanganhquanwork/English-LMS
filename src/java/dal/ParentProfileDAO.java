package dal;

import java.sql.*;
import model.entity.Users;
import model.entity.ParentProfile;

public class ParentProfileDAO extends DBContext {

    public Users getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ? AND role = 'Parent'";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setProfilePicture(rs.getString("profile_picture"));
                u.setPassword(rs.getString("password"));
                Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    u.setDateOfBirth(dob.toLocalDate());
                }
                u.setPhone(rs.getString("phone"));
                u.setGender(rs.getString("gender"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public ParentProfile getParentProfileById(int userId) {
        String sql = "SELECT * FROM ParentProfile WHERE user_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                ParentProfile p = new ParentProfile();
                p.setUserId(rs.getInt("user_id"));
                p.setAddress(rs.getString("address"));
                p.setOccupation(rs.getString("occupation"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateUser(Users u) {
        String sql = """
            UPDATE Users
            SET full_name=?, email=?, profile_picture=?, phone=?, gender=?, date_of_birth=?
            WHERE user_id=?
        """;
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, u.getFullName());
            stm.setString(2, u.getEmail());
            stm.setString(3, u.getProfilePicture());
            stm.setString(4, u.getPhone());
            stm.setString(5, u.getGender());
            if (u.getDateOfBirth() != null) {
                stm.setDate(6, Date.valueOf(u.getDateOfBirth()));
            } else {
                stm.setNull(6, Types.DATE);
            }
            stm.setInt(7, u.getUserId());
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateParentProfile(ParentProfile p) {
        String update = "UPDATE ParentProfile SET address=?, occupation=? WHERE user_id=?";
        String insert = "INSERT INTO ParentProfile(user_id, address, occupation) VALUES (?,?,?)";
        try {
            PreparedStatement stm = connection.prepareStatement(update);
            stm.setString(1, p.getAddress());
            stm.setString(2, p.getOccupation());
            stm.setInt(3, p.getUserId());
            int rows = stm.executeUpdate();
            if (rows == 0) { // nếu chưa có thì insert
                PreparedStatement ins = connection.prepareStatement(insert);
                ins.setInt(1, p.getUserId());
                ins.setString(2, p.getAddress());
                ins.setString(3, p.getOccupation());
                ins.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //For parent link     
    public Integer getParentIdByEmail(String email) {
        String sql = "SELECT * from Users WHERE email = ? and role = 'Parent' AND status = 'active' ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            return rs.next() ? rs.getInt("user_id") : null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer getParentIdByStudentId(int studentId) {
        String sql = "SELECT * from StudentProfile WHERE user_id = ? ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                int pid = rs.getInt("parent_id");
                if (rs.wasNull()) {
                    return null;
                }
                return pid;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
