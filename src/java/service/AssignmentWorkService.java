/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AssignmentDAO;
import dal.AssignmentWorkDAO;
import dal.InstructorDAO;
import dal.ProgressDAO;
import dal.StudentDAO;
import java.time.LocalDateTime;
import java.util.List;
import model.entity.Assignment;
import model.entity.AssignmentWork;

/**
 *
 * @author Lenovo
 */
public class AssignmentWorkService {

    private final AssignmentWorkDAO dao = new AssignmentWorkDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final StudentDAO sdao = new StudentDAO();
    private InstructorDAO instructorDAO = new InstructorDAO();
    private final ProgressDAO progressDAO = new ProgressDAO();

    public List<AssignmentWork> getWorksByInstructor(int instructorId) {
        return dao.getAllAssignmentWorksByInstructor(instructorId);
    }

    public AssignmentWork getAssignmentWorkDetail(int assignmentId, int studentId) {
        return dao.getAssignmentWorkDetail(assignmentId, studentId);
    }

    public boolean gradeAssignment(int assignmentId, int studentId, double score,
            String feedback, int graderId) {

        Assignment assignment = assignmentDAO.getAssignmentById(assignmentId);
        if (assignment == null) {
            System.err.println("Không tìm thấy Assignment với ID = " + assignmentId);
            return false;
        }
        double maxScore = assignment.getMaxScore();
        Double passingPct = assignment.getPassingScorePct();
        if (passingPct == null) {
            passingPct = 0.0;
        }
        double scorePct = (score / maxScore) * 100;
        String status = scorePct >= passingPct ? "passed" : "returned";
        AssignmentWork work = new AssignmentWork();
        work.setAssignment(assignmentDAO.getAssignmentById(assignmentId));
        work.setStudent(sdao.findStudentById(studentId));
        work.setScore(score);
        work.setFeedbackText(feedback);
        work.setGradedAt(LocalDateTime.now());
        work.setStatus(status);

        boolean updated = dao.updateGrade(work, graderId);
        if (updated) {
            boolean passed = "passed".equals(status);
            progressDAO.updateBestAssignmentScore(studentId, assignmentId, scorePct, passed);
        }

        return updated;
    }
}
