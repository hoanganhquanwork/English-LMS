/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.*;
import java.util.*;
import model.ManagerProfile;

public class ManagerDAO extends DBContext {

    public ManagerProfile getByUserId(int userId) {
        String sql = "SELECT * FROM ManagerProfile WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateManagerProfile(ManagerProfile mp) {
        String sql = "UPDATE ManagerProfile SET position=?, specialization=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, mp.getPosition());
            ps.setString(2, mp.getSpecialization());
            ps.setInt(3, mp.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private ManagerProfile mapResultSet(ResultSet rs) throws SQLException {
        ManagerProfile mp = new ManagerProfile();
        mp.setUserId(rs.getInt("user_id"));
        mp.setPosition(rs.getString("position"));
        mp.setSpecialization(rs.getString("specialization"));
        return mp;
    }
}

