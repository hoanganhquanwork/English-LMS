/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        Timestamp ts = rs.getTimestamp("created_at");
        u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }

    public int saveToken(String token, int userId, LocalDateTime expiryDate) {
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

    public Users getUserByToken(String token) {
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

    public int deleteToken(String token) {
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
}
