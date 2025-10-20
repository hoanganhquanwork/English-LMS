/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ModuleDAO;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.entity.Module;

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
    public Map<Module, Integer> getModulesWithQuestionCount(int courseId) {
        List<Module> modules = moduleDAO.getModulesByCourse(courseId);
        Map<Module, Integer> map = new LinkedHashMap<>();

        for (Module m : modules) {
            int count = moduleDAO.countQuestionsByModule(m.getModuleId());
            map.put(m, count);
        }
        return map;
    }
}
