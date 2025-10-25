/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Topic;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Lenovo
 */
public class TopicDAO extends DBContext {

    public List<Topic> getAllTopics() {
        List<Topic> list = new ArrayList<>();
        String sql = "SELECT * FROM Topics ORDER BY name";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Topic topic = new Topic(
                        rs.getInt("topic_id"),
                        rs.getString("name"),
                        rs.getString("description")
                );
                list.add(topic);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách topics: " + e.getMessage());
        }
        return list;
    }

    public Topic getTopicById(int topicId) {
        String sql = "SELECT * FROM Topics WHERE topic_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, topicId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Topic(
                        rs.getInt("topic_id"),
                        rs.getString("name"),
                        rs.getString("description")
                );
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy topic: " + e.getMessage());
        }
        return null;
    }

    public boolean insertTopic(Topic t) {
        String sql = "INSERT INTO Topics (name, description) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getDescription());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        t.setTopicId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[TopicDAO.insertTopic] " + e.getMessage());
        }
        return false;
    }

    public boolean updateTopic(Topic t) {
        String sql = "UPDATE Topics SET name = ?, description = ? WHERE topic_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getDescription());
            ps.setInt(3, t.getTopicId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[TopicDAO.updateTopic] " + e.getMessage());
        }
        return false;
    }

    public boolean isTopicNameExists(String name) {
        String sql = "SELECT COUNT(*) FROM Topics WHERE LOWER(name) = LOWER(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[TopicDAO.isTopicNameExists] " + e.getMessage());
        }
        return false;
    }

    public boolean isTopicNameExistsForUpdate(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Topics WHERE LOWER(name) = LOWER(?) AND topic_id <> ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[TopicDAO.isTopicNameExistsForUpdate] " + e.getMessage());
        }
        return false;
    }
}
