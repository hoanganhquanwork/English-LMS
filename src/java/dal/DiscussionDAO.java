/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.entity.Discussion;

/**
 *
 * @author Lenovo
 */
public class DiscussionDAO extends DBContext {

    private int getNextOrderIndex(int moduleId) throws SQLException {
        String sql = "SELECT ISNULL(MAX(order_index), 0) + 1 FROM ModuleItem WHERE module_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    public boolean insertDiscussion(int moduleId, String title, String description) {
        try {
            connection.setAutoCommit(false);

            int orderIndex = getNextOrderIndex(moduleId);
            String sql1 = "INSERT INTO ModuleItem (module_id, item_type, order_index) VALUES (?, 'discussion', ?)";
            PreparedStatement st1 = connection.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            st1.setInt(1, moduleId);
            st1.setInt(2, orderIndex);
            st1.executeUpdate();
            ResultSet rs = st1.getGeneratedKeys();
            int moduleItemId = 0;
            if (rs.next()) {
                moduleItemId = rs.getInt(1);
            }

           
            String sql2 = "INSERT INTO Discussion (discussion_id, title, description) VALUES (?, ?, ?)";
            PreparedStatement st2 = connection.prepareStatement(sql2);
            st2.setInt(1, moduleItemId);
            st2.setString(2, title);
            st2.setString(3, description);
            st2.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
            }
        }
        return false;
    }

    public Discussion getDiscussionById(int discussionId) {
        String sql = "SELECT discussion_id, title, description, created_at FROM Discussion WHERE discussion_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, discussionId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Discussion d = new Discussion();
                d.setDiscussionId(rs.getInt("discussion_id"));
                d.setTitle(rs.getString("title"));
                d.setDescription(rs.getString("description"));
                Timestamp cr = rs.getTimestamp("created_at");
                d.setCreatedAt(cr != null ? cr.toLocalDateTime() : null);
                return d;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
