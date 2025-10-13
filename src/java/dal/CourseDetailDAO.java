package dal;

import java.sql.*;
import java.util.*;

public class CourseDetailDAO extends DBContext {

    public boolean isCourseValid(int courseId) {
        String sql = "SELECT COUNT(*) FROM Course WHERE course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getModules(int courseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT m.module_id, m.title, m.description, m.order_index,
                   COUNT(mi.module_item_id) AS item_count
            FROM Module m
            LEFT JOIN ModuleItem mi ON m.module_id = mi.module_id
            WHERE m.course_id = ?
            GROUP BY m.module_id, m.title, m.description, m.order_index
            ORDER BY m.order_index
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("moduleId", rs.getInt("module_id"));
                m.put("title", rs.getString("title"));
                m.put("description", rs.getString("description"));
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
        String sql = """
            SELECT mi.module_item_id, mi.item_type, mi.order_index,
                   m.module_id, m.title AS module_title,
                   l.title AS lesson_title, l.content_type, l.video_url, l.text_content, l.duration_sec,
                   q.title AS quiz_title, q.passing_score_pct
            FROM ModuleItem mi
            JOIN Module m ON mi.module_id = m.module_id
            LEFT JOIN Lesson l ON mi.module_item_id = l.lesson_id
            LEFT JOIN Quiz q ON mi.module_item_id = q.quiz_id
            WHERE m.course_id = ?
            ORDER BY m.order_index, mi.order_index
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> i = new HashMap<>();
                i.put("moduleId", rs.getInt("module_id"));
                i.put("moduleTitle", rs.getString("module_title"));
                i.put("itemId", rs.getInt("module_item_id"));
                i.put("itemType", rs.getString("item_type"));
                i.put("orderIndex", rs.getInt("order_index"));
                i.put("lessonTitle", rs.getString("lesson_title"));
                i.put("contentType", rs.getString("content_type"));
                i.put("videoUrl", rs.getString("video_url"));
                i.put("textContent", rs.getString("text_content"));
                i.put("durationSec", rs.getInt("duration_sec"));
                i.put("quizTitle", rs.getString("quiz_title"));
                i.put("passingScore", rs.getBigDecimal("passing_score_pct"));
                list.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getStatistics(int courseId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = """
            SELECT
              (SELECT COUNT(*) FROM Module WHERE course_id = ?) AS moduleCount,
              (SELECT COUNT(*) FROM Lesson l 
               JOIN ModuleItem mi ON l.lesson_id = mi.module_item_id 
               JOIN Module m ON mi.module_id = m.module_id 
               WHERE m.course_id = ?) AS lessonCount,
              (SELECT COUNT(*) FROM Quiz q 
               JOIN ModuleItem mi ON q.quiz_id = mi.module_item_id 
               JOIN Module m ON mi.module_id = m.module_id 
               WHERE m.course_id = ?) AS quizCount,
              (SELECT COUNT(*) FROM Assignment a 
               JOIN ModuleItem mi ON a.assignment_id = mi.module_item_id 
               JOIN Module m ON mi.module_id = m.module_id 
               WHERE m.course_id = ?) AS assignmentCount,
              (SELECT COUNT(*) FROM Discussion d 
               JOIN ModuleItem mi ON d.discussion_id = mi.module_item_id 
               JOIN Module m ON mi.module_id = m.module_id 
               WHERE m.course_id = ?) AS discussionCount
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 1; i <= 5; i++) ps.setInt(i, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("moduleCount", rs.getInt("moduleCount"));
                stats.put("lessonCount", rs.getInt("lessonCount"));
                stats.put("quizCount", rs.getInt("quizCount"));
                stats.put("assignmentCount", rs.getInt("assignmentCount"));
                stats.put("discussionCount", rs.getInt("discussionCount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}