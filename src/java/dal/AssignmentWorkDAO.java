/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.entity.AssignmentWork;
import java.sql.*;
import java.util.*;
import model.entity.Assignment;
import model.entity.InstructorProfile;
import model.entity.StudentProfile;
import model.entity.Users;

/**
 *
 * @author Lenovo
 */
public class AssignmentWorkDAO extends DBContext {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private UserDAO dao = new UserDAO();

    public List<AssignmentWork> getAllAssignmentWorksByInstructor(int instructorId) {
        List<AssignmentWork> list = new ArrayList<>();

        String sql = """
       SELECT * 
        FROM AssignmentWork
        WHERE grader_id = ?
          AND status IN ('submitted', 'passed')
        ORDER BY submitted_at DESC;
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AssignmentWork work = new AssignmentWork();

               
                Assignment assignment = assignmentDAO.getAssignmentById(rs.getInt("assignment_id"));
                work.setAssignment(assignment);

              
                StudentProfile student = new StudentProfile();
                student.setUserId(rs.getInt("student_id"));
                student.setUser(dao.getUserById(rs.getInt("student_id")));
                work.setStudent(student);

               
                Timestamp submittedAt = rs.getTimestamp("submitted_at");
                if (submittedAt != null) {
                    work.setSubmittedAt(submittedAt.toLocalDateTime());
                }

               
                work.setTextAnswer(rs.getString("text_answer"));
                work.setFileUrl(rs.getString("file_url"));
                work.setStatus(rs.getString("status"));

                
                double score = rs.getDouble("score");
                if (!rs.wasNull()) {
                    work.setScore(score);
                }

                
                int graderId = rs.getInt("grader_id");
                if (!rs.wasNull()) {
                    InstructorProfile grader = new InstructorProfile();
                    grader.setUser(dao.getUserById(graderId));
                    work.setGrader(grader);
                }

               
                Timestamp gradedAt = rs.getTimestamp("graded_at");
                if (gradedAt != null) {
                    work.setGradedAt(gradedAt.toLocalDateTime());
                }

                work.setFeedbackText(rs.getString("feedback_text"));
                list.add(work);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy AssignmentWork theo instructor: " + e.getMessage());
        }

        return list;
    }

    public AssignmentWork getAssignmentWorkDetail(int assignmentId, int studentId) {
        String sql = """
        SELECT * 
        FROM AssignmentWork
        WHERE assignment_id = ? AND student_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                AssignmentWork work = new AssignmentWork();

                Assignment assignment = assignmentDAO.getAssignmentById(rs.getInt("assignment_id"));
                work.setAssignment(assignment);

                StudentProfile student = new StudentProfile();
                student.setUserId(rs.getInt("student_id"));
                work.setStudent(student);

                Timestamp submittedAt = rs.getTimestamp("submitted_at");
                if (submittedAt != null) {
                    work.setSubmittedAt(submittedAt.toLocalDateTime());
                }

                
                work.setTextAnswer(rs.getString("text_answer"));
                
                work.setFileUrl(rs.getString("file_url"));
                work.setStatus(rs.getString("status"));
                work.setFeedbackText(rs.getString("feedback_text"));

                double score = rs.getDouble("score");
                if (!rs.wasNull()) {
                    work.setScore(score);
                }

                int graderId = rs.getInt("grader_id");
                if (!rs.wasNull()) {
                    InstructorProfile grader = new InstructorProfile();
                    grader.setUser(dao.getUserById(graderId));
                    work.setGrader(grader);
                }

                // 🔹 Thời gian chấm
                Timestamp gradedAt = rs.getTimestamp("graded_at");
                if (gradedAt != null) {
                    work.setGradedAt(gradedAt.toLocalDateTime());
                }

                return work;
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy chi tiết AssignmentWork: " + e.getMessage());
        }

        return null;
    }
    


    public boolean updateGrade(AssignmentWork work, int graderId) {
        String sql = """
            UPDATE AssignmentWork
            SET score = ?, feedback_text = ?, grader_id = ?, graded_at = ?, status = ?
            WHERE assignment_id = ? AND student_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBigDecimal(1, new java.math.BigDecimal(work.getScore()));
            ps.setString(2, work.getFeedbackText());
            ps.setInt(3, graderId);
            ps.setTimestamp(4, Timestamp.valueOf(work.getGradedAt()));
            ps.setString(5, work.getStatus());
            ps.setInt(6, work.getAssignment().getAssignmentId().getModuleItemId());
            ps.setInt(7, work.getStudent().getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi updateGrade: " + e.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        AssignmentWorkDAO dao = new AssignmentWorkDAO();
        System.out.println(dao.getAssignmentWorkDetail(8, 4));
    }
}
