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
        String sql = "SELECT topic_id, name, description FROM Topics ORDER BY name ASC";

        try (
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Topic t = new Topic();
                t.setTopicId(rs.getInt("topic_id"));
                t.setName(rs.getString("name"));
                t.setDescription(rs.getString("description"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
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
}

