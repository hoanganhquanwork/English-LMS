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
import org.mindrot.jbcrypt.BCrypt;

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
        String sql = "INSERT INTO Users(username, email, password, gender, role, full_name, profile_picture, date_of_birth, phone, status) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, user.getUsername());
            st.setString(2, user.getEmail());

            // password
            if (user.getPassword() != null) {
                st.setString(3, user.getPassword());
            } else {
                st.setNull(3, java.sql.Types.VARCHAR);
            }

            // gender
            if (user.getGender() != null) {
                st.setString(4, user.getGender());
            } else {
                st.setNull(4, java.sql.Types.VARCHAR);
            }

            st.setString(5, user.getRole());

            // full_name
            if (user.getFullName() != null) {
                st.setString(6, user.getFullName());
            } else {
                st.setNull(6, java.sql.Types.NVARCHAR);
            }

            // profile_picture
            if (user.getProfilePicture() != null) {
                st.setString(7, user.getProfilePicture());
            } else {
                st.setNull(7, java.sql.Types.NVARCHAR);
            }

            // date_of_birth
            if (user.getDateOfBirth() != null) {
                st.setDate(8, java.sql.Date.valueOf(user.getDateOfBirth()));
            } else {
                st.setNull(8, java.sql.Types.DATE);
            }

            // phone
            if (user.getPhone() != null) {
                st.setString(9, user.getPhone());
            } else {
                st.setNull(9, java.sql.Types.NVARCHAR);
            }

            // status: nếu null thì gán 'active'
            st.setString(10, user.getStatus() != null ? user.getStatus() : "active");

            int affectedRow = st.executeUpdate();
            if (affectedRow > 0) {
                try (ResultSet key = st.getGeneratedKeys()) {
                    if (key.next()) {
                        int newId = key.getInt(1);
                        user.setUserId(newId);
                    }
                }
                return affectedRow;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Users getUserByLogin(String login, String password, boolean status) {
        String sql = "SELECT * FROM Users WHERE (username = ? OR email = ?) " + (status ? "AND status ='active'" : "");
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, login);
            st.setString(2, login);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                String hashPassword = rs.getString("password");
                if (BCrypt.checkpw(password, hashPassword)) {
                    Users user = mapRow(rs);
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Users getUserByProvider(String provider, String providerUserId) {
        String sql = "SELECT u.* FROM Users u "
                + "JOIN OAuthAccounts oa ON u.user_id = oa.user_id "
                + "WHERE oa.provider = ? AND oa.provider_user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, provider);
            st.setString(2, providerUserId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int linkOAuthAccount(int userId, String provider, String providerUserId) {
        String sql = "INSERT INTO OAuthAccounts(user_id, provider, provider_user_id) VALUES(?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setString(2, provider);
            st.setString(3, providerUserId);
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int updatePasswordByID(int userId, String hashPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, hashPassword);
            st.setInt(2, userId);
            int affected = st.executeUpdate();
            return affected ;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
        
    }
}
