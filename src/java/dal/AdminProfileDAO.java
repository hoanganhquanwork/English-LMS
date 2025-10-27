package dal;

import model.entity.Users;
import java.sql.*;

public class AdminProfileDAO extends DBContext {

    public Users getProfile(int id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setGender(rs.getString("gender"));
                Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    u.setDateOfBirth(dob.toLocalDate());
                }
                u.setProfilePicture(rs.getString("profile_picture"));
                u.setRole(rs.getString("role"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(Users u) {
        String sql = "UPDATE Users SET full_name=?, phone=?, gender=?, date_of_birth=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getPhone());
            ps.setString(3, u.getGender());
             if (u.getDateOfBirth() != null) {
                ps.setDate(4, Date.valueOf(u.getDateOfBirth()));
            } else {
                ps.setNull(4, Types.DATE);
            }
            ps.setInt(5, u.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
