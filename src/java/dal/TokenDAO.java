/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.Users;

/**
 *
 * @author Admin
 */
public class TokenDAO extends DBContext {

    private Users mapRow(ResultSet rs) throws SQLException {
        Users u = new Users();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setGender(rs.getString("gender"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) {
            u.setDateOfBirth(dob.toLocalDate());
        } else {
            u.setDateOfBirth(null);
        }
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            u.setCreatedAt(ts.toLocalDateTime());
        }
        String profilePicture = rs.getString("profile_picture");
        if (profilePicture != null) {
            u.setProfilePicture(profilePicture);
        }
        return u;
    }

    //remember-me token
    public int saveRememberToken(String token, int userId, LocalDateTime expiryDate) {
        String sql = "INSERT INTO PersistentTokens(token, user_id, expiry_date) VALUES(?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            st.setInt(2, userId);
            st.setTimestamp(3, Timestamp.valueOf(expiryDate));
            int affected = st.executeUpdate();
            return affected;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    //remember-me token
    public Users getUserByRememberToken(String token) {
        String sql = "SELECT u.* FROM PersistentTokens p JOIN Users u \n"
                + "on p.user_id =  u.user_id\n"
                + "WHERE token = ? AND expiry_date > GETDATE() AND u.status = 'active'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Users u = mapRow(rs);
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //remember-me token
    public int deleteRememberToken(String token) {
        String sql = "DELETE FROM PersistentTokens WHERE token = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            int affected = st.executeUpdate();
            return affected;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int saveResetPasswordToken(int userId, String token, Timestamp expiry) {
        String sql = "INSERT INTO PasswordResetTokens(user_id, token, expires_at) VALUES(?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setString(2, token);
            st.setTimestamp(3, expiry);
            int affected = st.executeUpdate();
            return affected;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Integer getUserIdByResetToken(String token) {
        String sql = "SELECT user_id FROM PasswordResetTokens "
                + "WHERE token = ? AND used_at IS NULL AND expires_at > GETDATE()";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int markUsedToken(String token) {
        String sql = "UPDATE PasswordResetTokens SET used_at = GETDATE() WHERE token = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            int affected = st.executeUpdate();
            return affected;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Users getUserByResetToken(String token) {
        String sql = "SELECT u.* FROM PasswordResetTokens t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "WHERE t.token = ? "
                + "AND t.used_at IS NULL "
                + "AND t.expires_at > GETDATE() "
                + "AND u.status = 'active'";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
