/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.Lesson;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.entity.Module;

/**
 *
 * @author Lenovo
 */
public class LessonDAO extends DBContext {

    public void insertLesson(Lesson lesson) throws SQLException {
        String sql = """
        INSERT INTO Lesson (lesson_id, title, content_type, video_url, duration_sec, text_content)
        VALUES (?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lesson.getModuleItemId());
            ps.setString(2, lesson.getTitle());
            ps.setString(3, lesson.getContentType());
            ps.setString(4, lesson.getVideoUrl());

           
            if (lesson.getDurationSec() > 0) {
                ps.setInt(5, lesson.getDurationSec());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

           
            if (lesson.getTextContent() != null && !lesson.getTextContent().isEmpty()) {
                ps.setString(6, lesson.getTextContent());
            } else {
                ps.setNull(6, java.sql.Types.NVARCHAR);
            }

            ps.executeUpdate();
            System.out.println(" Lesson inserted successfully!");
        }
    }

    public Lesson getLessonById(int moduleItemId) {
        String sql = "SELECT * FROM Lesson WHERE lesson_id = ?";
        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Lesson l = new Lesson();
                l.setModuleItemId(rs.getInt("lesson_id"));
                l.setTitle(rs.getString("title"));
                l.setContentType(rs.getString("content_type"));
                l.setVideoUrl(rs.getString("video_url"));
                l.setDurationSec(rs.getInt("duration_sec"));
                l.setTextContent(rs.getString("text_content"));
                return l;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Lesson> getAllLessons() throws SQLException {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT lesson_id, title, content_type, video_url, duration_sec, text_content FROM Lesson";

        try (
                PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Lesson lesson = new Lesson();
                lesson.setModuleItemId(rs.getInt("lesson_id"));
                lesson.setTitle(rs.getString("title"));
                lesson.setContentType(rs.getString("content_type"));
                lesson.setVideoUrl(rs.getString("video_url"));
                lesson.setDurationSec(rs.getInt("duration_sec"));
                lesson.setTextContent(rs.getString("text_content"));
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public List<Lesson> getLessonsByModule(int moduleId) throws SQLException {
        String sql = """
            SELECT l.lesson_id, l.title, l.content_type, l.video_url, l.duration_sec, l.text_content
            FROM Lesson l
            JOIN ModuleItem mi ON l.lesson_id = mi.module_item_id
            WHERE mi.module_id = ? AND mi.item_type = 'lesson'
            ORDER BY mi.order_index
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);

            try (ResultSet rs = ps.executeQuery()) {
                List<Lesson> list = new ArrayList<>();
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setModuleItemId(rs.getInt("lesson_id"));
                    lesson.setTitle(rs.getString("title"));
                    lesson.setContentType(rs.getString("content_type"));
                    lesson.setVideoUrl(rs.getString("video_url"));
                    lesson.setDurationSec((Integer) rs.getObject("duration_sec"));
                    lesson.setTextContent(rs.getString("text_content"));
                    list.add(lesson);
                }
                return list;
            }
        }

    }

    public void updateLesson(Lesson l) throws SQLException {
        String sql = "UPDATE Lesson SET title = ?, video_url = ?, duration_sec = ?, text_content = ? WHERE lesson_id = ?";
        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, l.getTitle());
            ps.setString(2, l.getVideoUrl());
            ps.setObject(3, l.getDurationSec(), java.sql.Types.INTEGER);
            ps.setString(4, l.getTextContent());
            ps.setInt(5, l.getModuleItemId());
            ps.executeUpdate();
        }
    }

    public boolean updateLessonReading(Lesson lesson) {
        String sql = "UPDATE Lesson SET title = ?, text_content = ? WHERE lesson_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getTextContent());
            ps.setInt(3, lesson.getModuleItemId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
