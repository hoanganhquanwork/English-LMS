/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ModuleDAO;
import dal.ModuleItemDAO;
import java.util.*;
import model.entity.Module;
import model.entity.ModuleItem;

/**
 *
 * @author Lenovo
 */
public class ModuleItemService {

    private ModuleDAO moduleDAO = new ModuleDAO();
    private ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

    public Map<Module, List<ModuleItem>> getCourseContent(int courseId) {
        Map<Module, List<ModuleItem>> result = new LinkedHashMap<>();

        try {
            // Lấy danh sách module của course
            List<Module> modules = moduleDAO.getModulesByCourse(courseId);

            for (Module m : modules) {
                try {
                    List<ModuleItem> items = moduleItemDAO.getItemsByModule(m.getModuleId());
                    result.put(m, items);
                } catch (Exception ex) {
                    System.err.println("Lỗi khi lấy ModuleItem cho moduleId = " + m.getModuleId());
                    ex.printStackTrace();
                }
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách module cho courseId = " + courseId);
            e.printStackTrace();
        }

        return result;
    }
}
