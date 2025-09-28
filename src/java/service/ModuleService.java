/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ModuleDAO;
import java.util.List;
import model.Module;

/**
 *
 * @author Lenovo
 */
public class ModuleService {

    private ModuleDAO moduleDAO = new ModuleDAO();

    public List<Module> getModulesByCourse(int courseId) {
        return moduleDAO.getModulesByCourse(courseId);
    }

    public boolean createModule(Module module) {
        return moduleDAO.insertModule(module);
    }

    public boolean updateModule(Module module) {
       return moduleDAO.updateModule(module);
    }
    public boolean removeModule(int moduleId) {
        return moduleDAO.deleteModule(moduleId);
    }
}
