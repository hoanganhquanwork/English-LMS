/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.List;
import java.sql.*;
import java.util.ArrayList;
import model.dto.ModuleItemViewDTO;
import model.dto.MyLearningCompletedDTO;
import model.dto.MyLearningInProgressDTO;

/**
 *
 * @author Admin
 */
public class MyLearningDAO extends DBContext {

    public List<MyLearningInProgressDTO> getInProgressCourses(int studentId) {
        List<MyLearningInProgressDTO> list = new ArrayList<>();
        String sql = "SELECT c.course_id, c.title AS course_title, c.thumbnail, "
                + "CAST(100.0 * COALESCE(SUM(CASE WHEN p.status='completed' THEN 1 ELSE 0 END),0)"
                + " / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS progress_percent"
                + " FROM Enrollments e"
                + " JOIN Course  c  ON c.course_id = e.course_id "
                + " JOIN Module m ON m.course_id = c.course_id "
                + " JOIN ModuleItem mi ON mi.module_id = m.module_id AND mi.is_required = 1"
                + " LEFT JOIN Progress p "
                + " ON p.module_item_id = mi.module_item_id "
                + " AND p.student_id = e.student_id"
                + " WHERE e.student_id = ? AND e.status <> 'completed' "
                + " GROUP BY c.course_id, c.title, c.thumbnail "
                + " ORDER BY c.title";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                MyLearningInProgressDTO dto = new MyLearningInProgressDTO();
                int courseId = rs.getInt("course_id");
                dto.setCourseId(courseId);
                dto.setCourseTitle(rs.getString("course_title"));
                dto.setThumbnailUrl(rs.getString("thumbnail"));
                dto.setProgressPercent(rs.getDouble("progress_percent"));
                dto.setNextItem(getNextUnlearnedItem(studentId, courseId));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ModuleItemViewDTO getNextUnlearnedItem(int studentId, int courseId) {
        String sql = "SELECT TOP (1) mi.module_item_id, mi.item_type, "
                + " COALESCE(l.title, a.title, q.title, d.title) AS item_title,"
                + " l.duration_sec FROM Module m "
                + " JOIN ModuleItem mi ON mi.module_id = m.module_id "
                + " LEFT JOIN Lesson l ON l.lesson_id = mi.module_item_id "
                + " LEFT JOIN Assignment a ON a.assignment_id = mi.module_item_id "
                + " LEFT JOIN Quiz q ON q.quiz_id = mi.module_item_id "
                + " LEFT JOIN Discussion d ON d.discussion_id = mi.module_item_id "
                + " LEFT JOIN Progress p ON p.module_item_id = mi.module_item_id "
                + " AND p.student_id = ? "
                + " WHERE m.course_id = ? AND ISNULL(p.status, '') <> 'completed' "
                + " ORDER BY mi.is_required DESC, m.order_index, mi.order_index";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                ModuleItemViewDTO item = new ModuleItemViewDTO();
                item.setModuleItemId(rs.getInt("module_item_id"));
                item.setContentType(rs.getString("item_type"));
                item.setTitle(rs.getString("item_title"));
                Integer duration = (Integer) rs.getObject("duration_sec");
                if (duration != null) {
                    item.setDurationSec(duration);
                    item.setDurationMin((int) Math.ceil(duration / 60.0));
                }
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<MyLearningCompletedDTO> getCompletedCourse(int studentId) {
        List<MyLearningCompletedDTO> list = new ArrayList<>();
        String sql = "SELECT c.course_id, c.title AS course_title, c.thumbnail ,"
                + " e.enrolled_at, e.completed_at, "
                + " CAST(AVG(CAST(p.score_pct AS FLOAT)) AS DECIMAL(5,2)) AS avg_score "
                + " FROM Enrollments e JOIN Course c ON c.course_id = e.course_id "
                + " JOIN Module m ON m.course_id = c.course_id "
                + " JOIN ModuleItem mi ON mi.module_id = m.module_id LEFT "
                + " JOIN Progress p ON p.module_item_id = mi.module_item_id AND p.student_id = e.student_id "
                + " AND p.score_pct IS NOT NULL"
                + " WHERE e.student_id = ? "
                + " AND e.status = 'completed' "
                + " AND mi.is_required = 1"
                + " AND mi.item_type IN ('assignment','quiz')"
                + " GROUP BY c.course_id, c.title, c.thumbnail, e.enrolled_at, e.completed_at "
                + " ORDER BY e.completed_at DESC, c.title";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                MyLearningCompletedDTO dto = new MyLearningCompletedDTO();
                dto.setCourseId(rs.getInt("course_id"));
                dto.setCourseTitle(rs.getString("course_title"));
                dto.setThumbnailUrl(rs.getString("thumbnail"));
                dto.setAverageScore(rs.getDouble("avg_score"));
                Timestamp enrolledTs = rs.getTimestamp("enrolled_at");
                dto.setEnrolledAt(enrolledTs != null ? enrolledTs.toLocalDateTime() : null);
                Timestamp ts = rs.getTimestamp("completed_at");
                dto.setCompletedAt(ts != null ? ts.toLocalDateTime() : null);
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
