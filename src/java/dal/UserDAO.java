/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import model.Users;

/**
 *
 * @author Admin
 */
public class UserDAO extends DBContext {

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

    public Users getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ? AND STATUS ='active'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Users user = mapRow(rs);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Users getUserByUserName(String username) {
        String sql = "SELECT * FROM Users WHERE username = ? AND STATUS ='active'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Users user = mapRow(rs);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int register(Users user) {
        String sql = "INSERT INTO Users(username, email, password, gender, role) "
                + "VALUES (?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, user.getUsername());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPassword());  // password đã hash trước đó
            st.setString(4, user.getGender());
            st.setString(5, user.getRole());
            int affectedRow = st.executeUpdate();
            if(affectedRow > 0){
                ResultSet key = st.getGeneratedKeys();
                if(key.next()){
                    int newId = key.getInt(1);
                    user.setUserId(newId);
                }
                return affectedRow;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
