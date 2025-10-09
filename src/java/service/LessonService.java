/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.LessonDAO;
import dal.ModuleDAO;
import java.util.List;
import model.entity.Lesson;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import model.entity.Module;

/**
 *
 * @author Lenovo
 */
public class LessonService {
     private LessonDAO lessonDAO = new LessonDAO();
       private ModuleDAO moduleDAO = new ModuleDAO();
     
 public Map<Module, List<Lesson>> getCourseContent(int courseId) throws SQLException {
        List<Module> modules = moduleDAO.getModulesByCourse(courseId);
        Map<Module, List<Lesson>> result = new LinkedHashMap<>();
        for (Module m : modules) {
            List<Lesson> lessons = lessonDAO.getLessonsByModule(m.getModuleId());
            result.put(m, lessons);
        }
        return result;
    }
}
