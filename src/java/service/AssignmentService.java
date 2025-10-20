/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.AssignmentDAO;
import dal.ModuleItemDAO;
import model.entity.Assignment;
import model.entity.ModuleItem;

/**
 *
 * @author Lenovo
 */
public class AssignmentService {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

    public int createAssignment(int moduleId, Assignment a) {

        try {

            ModuleItem item = new ModuleItem();
            item.setModuleId(moduleId);
            item.setItemType("assignment");
            item.setOrderIndex(moduleItemDAO.getNextOrderIndex(moduleId));
            item.setRequired(true);

            int moduleItemId = moduleItemDAO.insertModuleItem(item);

            a.setAssignmentId(moduleItemId);

            boolean success = assignmentDAO.insertAssignment(a);

            return success ? moduleItemId : -1;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;

        }
    }
     public boolean updateAssignment(Assignment a) {
        return assignmentDAO.updateAssignment(a);
    }

    public boolean deleteAssignment(int id) {
     try {         
            boolean moduleItemDeleted = moduleItemDAO.deleteModuleItem(id);
            return   moduleItemDeleted;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Assignment getAssignmentById(int id) {
        return assignmentDAO.getAssignmentById(id);
    }
}
