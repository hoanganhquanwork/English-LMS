/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AssignmentDAO;
import dal.ModuleDAO;
import dal.ModuleItemDAO;
import dal.RubricCriterionDAO;
import java.util.ArrayList;
import java.util.List;
import dal.ProgressDAO;
import java.math.BigDecimal;
import model.dto.AssignmentDTO;
import model.dto.AssignmentWorkDTO;
import model.entity.Assignment;
import model.entity.ModuleItem;
import model.entity.RubricCriterion;

/**
 *
 * @author Lenovo
 */
public class AssignmentService {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final ModuleItemDAO moduleItemDAO = new ModuleItemDAO();
    private ModuleDAO moduleDAO = new ModuleDAO();
    private final RubricCriterionDAO rubricDAO = new RubricCriterionDAO();
    private ProgressDAO progressDAO = new ProgressDAO();

    public int createAssignment(int moduleId, Assignment a,
            String[] nos, String[] guidances, String[] weights) {
        try {

            ModuleItem item = new ModuleItem();
            item.setModule(moduleDAO.getModuleById(moduleId));
            item.setItemType("assignment");
            item.setOrderIndex(moduleItemDAO.getNextOrderIndex(moduleId));
            item.setRequired(true);

            int moduleItemId = moduleItemDAO.insertModuleItem(item);
            a.setAssignmentId(moduleItemDAO.getModuleItemById(moduleItemId));

            boolean success = assignmentDAO.insertAssignment(a);

            if (success) {
                if (nos != null && nos.length > 0) {
                    List<RubricCriterion> list = new ArrayList<>();
                    for (int i = 0; i < nos.length; i++) {
                        RubricCriterion rc = new RubricCriterion();
                        rc.setAssignment(a);
                        rc.setCriterionNo(Integer.parseInt(nos[i]));
                        rc.setGuidance(guidances[i]);
                        rc.setWeight(Double.parseDouble(weights[i]));
                        list.add(rc);
                    }
                    rubricDAO.insertRubricList(list);
                }
                return moduleItemId; 
            }

            return -1;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean deleteAssignment(int id) {
        try {
            boolean moduleItemDeleted = moduleItemDAO.deleteModuleItem(id);
            return moduleItemDeleted;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Assignment getAssignmentById(int id) {
        return assignmentDAO.getAssignmentById(id);
    }

    //tuanta
    public AssignmentDTO getAssignmentWithRubric(int assignmentId) {
        AssignmentDTO a = assignmentDAO.findAssignmentById(assignmentId);
        if (a == null) {
            throw new IllegalArgumentException("Assignment không tồn tại.");
        }
        return a;
    }

    public AssignmentWorkDTO getAssigmentWork(int assignmentId, int studentId) {
        return assignmentDAO.findAssigmentWork(studentId, assignmentId);
    }

    public boolean saveDraft(int assignmentId, int studentId,
            String submissionType, String textAnswer, String fileUrl) {

        AssignmentDTO a = getAssignmentWithRubric(assignmentId);
        if (a == null) {
            throw new IllegalArgumentException("Assignment không tồn tại.");
        }
        if (!"text".equalsIgnoreCase(submissionType) && !"file".equalsIgnoreCase(submissionType)) {
            throw new IllegalArgumentException("submission_type không hợp lệ.");
        }

        AssignmentWorkDTO work = new AssignmentWorkDTO();
        work.setAssignmentId(assignmentId);
        work.setStudentId(studentId);

        if ("text".equalsIgnoreCase(submissionType)) {
            work.setTextAnswer(textAnswer);
            work.setFileUrl(null);
        } else {
            work.setTextAnswer(null);
            work.setFileUrl(fileUrl);
        }
        return assignmentDAO.saveAssignmentDraft(work);
    }

    public boolean submit(int assignmentId, int studentId,
            String submissionType, String textAnswer, String fileUrl) {

        AssignmentDTO a = getAssignmentWithRubric(assignmentId);
        if (a == null) {
            throw new IllegalArgumentException("Assignment không tồn tại.");
        }

        AssignmentWorkDTO current = getAssigmentWork(assignmentId, studentId);
        if (current != null && "submitted".equalsIgnoreCase(current.getStatus())) {
            throw new IllegalStateException("Bạn đã nộp bài. Vui lòng chờ chấm/trả bài trước khi nộp lại.");
        }

        if (!"text".equalsIgnoreCase(submissionType) && !"file".equalsIgnoreCase(submissionType)) {
            throw new IllegalArgumentException("submission_type không hợp lệ.");
        }

        AssignmentWorkDTO work = new AssignmentWorkDTO();
        work.setAssignmentId(assignmentId);
        work.setStudentId(studentId);

        if ("text".equalsIgnoreCase(submissionType)) {
            work.setTextAnswer(textAnswer);
            work.setFileUrl(null);
        } else {
            work.setTextAnswer(null);
            work.setFileUrl(fileUrl);
        }

        return assignmentDAO.submitWork(work);
    }

    public boolean gradeAssignment(int assignmentId, int studentId, BigDecimal score, String feedback, Integer graderId) {
        boolean ok = assignmentDAO.updateScoreAndFeedback(assignmentId, studentId,
                score.doubleValue(), feedback, graderId);
        if (!ok) {
            return false;
        }

        AssignmentDTO a = getAssignmentWithRubric(assignmentId);
        BigDecimal passing = a != null ? a.getPassingScorePct() : null;

        boolean markCompleted = false;
        if (passing != null) {
            markCompleted = score.compareTo(passing) >= 0;
        }
        progressDAO.updateBestQuizOrAssigmentScore(studentId, assignmentId, score.doubleValue(), markCompleted);
        return true;
    }

    public boolean updateAssignment(Assignment a, String[] nos, String[] guidances, String[] weights) {
        try {
            boolean updated = assignmentDAO.updateAssignment(a);
            if (!updated) {
                return false;
            }

            rubricDAO.deleteByAssignmentId(a.getAssignmentId().getModuleItemId());

            if (nos != null) {
                for (int i = 0; i < nos.length; i++) {
                    int no = Integer.parseInt(nos[i]);
                    double weight = Double.parseDouble(weights[i].replace(",", "."));
                    String guidance = guidances[i];
                    rubricDAO.insertCriterion(a.getAssignmentId().getModuleItemId(), no, weight, guidance);
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
