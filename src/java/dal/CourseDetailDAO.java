package dal;

import java.sql.*;
import java.util.*;

public class CourseDetailDAO extends DBContext {

    public boolean isCourseValid(int courseId) {
        String sql = "SELECT COUNT(*) FROM Course WHERE course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getModules(int courseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = 
            "SELECT m.module_id, m.title, m.order_index, "
          + "COUNT(mi.module_item_id) AS item_count "
          + "FROM Module m "
          + "LEFT JOIN ModuleItem mi ON m.module_id = mi.module_id "
          + "WHERE m.course_id = ? "
          + "GROUP BY m.module_id, m.title, m.order_index "
          + "ORDER BY m.order_index";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("moduleId", rs.getInt("module_id"));
                m.put("title", rs.getString("title"));
                m.put("orderIndex", rs.getInt("order_index"));
                m.put("itemCount", rs.getInt("item_count"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getModuleItems(int courseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = 
            "SELECT mi.module_item_id, mi.item_type, mi.order_index, "
          + "m.module_id, m.title AS module_title, "
          + "l.title AS lesson_title, l.content_type, l.video_url, l.text_content, l.duration_sec "
          + "FROM ModuleItem mi "
          + "JOIN Module m ON mi.module_id = m.module_id "
          + "LEFT JOIN Lesson l ON mi.module_item_id = l.lesson_id "
          + "WHERE m.course_id = ? "
          + "ORDER BY m.order_index, mi.order_index";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("moduleId", rs.getInt("module_id"));
                item.put("moduleTitle", rs.getString("module_title"));
                item.put("itemId", rs.getInt("module_item_id"));
                item.put("itemType", rs.getString("item_type"));
                item.put("orderIndex", rs.getInt("order_index"));

                if ("lesson".equalsIgnoreCase(rs.getString("item_type"))) {
                    item.put("lessonTitle", rs.getString("lesson_title"));
                    item.put("contentType", rs.getString("content_type"));
                    item.put("videoUrl", rs.getString("video_url"));
                    item.put("textContent", rs.getString("text_content"));
                    Object durationObj = rs.getObject("duration_sec");
                    item.put("durationSec", durationObj != null ? rs.getInt("duration_sec") : 0);
                }
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getStatistics(int courseId) {
        Map<String, Object> stats = new HashMap<>();
        String sql =
            "SELECT "
          + "(SELECT COUNT(*) FROM Module WHERE course_id = ?) AS moduleCount, "
          + "(SELECT COUNT(*) FROM Lesson l "
          + " JOIN ModuleItem mi ON l.lesson_id = mi.module_item_id "
          + " JOIN Module m ON mi.module_id = m.module_id "
          + " WHERE m.course_id = ?) AS lessonCount";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("moduleCount", rs.getInt("moduleCount"));
                stats.put("lessonCount", rs.getInt("lessonCount"));
                stats.put("quizCount", 0);
                stats.put("assignmentCount", 0);
                stats.put("discussionCount", 0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Object> getInstructorInfo(int courseId) {
        Map<String, Object> instructor = new HashMap<>();
        String sql =
            "SELECT u.user_id, u.full_name, u.email, "
          + "i.expertise, i.qualifications, i.bio "
          + "FROM Course c "
          + "JOIN InstructorProfile i ON c.created_by = i.user_id "
          + "JOIN Users u ON i.user_id = u.user_id "
          + "WHERE c.course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                instructor.put("userId", rs.getInt("user_id"));
                instructor.put("fullName", rs.getString("full_name"));
                instructor.put("email", rs.getString("email"));
                instructor.put("expertise", rs.getString("expertise"));
                instructor.put("qualifications", rs.getString("qualifications"));
                instructor.put("bio", rs.getString("bio"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return instructor;
    }
}