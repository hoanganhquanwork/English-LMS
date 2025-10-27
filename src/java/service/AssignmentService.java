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

            if (success && nos != null) {
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
