/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.LessonDAO;
import dal.ModuleDAO;
import dal.ModuleItemDAO;
import dal.QuestionDAO;
import java.util.List;
import model.entity.Lesson;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import model.entity.Module;
import model.entity.ModuleItem;

/**
 *
 * @author Lenovo
 */
public class LessonService {

    private LessonDAO lessonDAO = new LessonDAO();
    private ModuleDAO moduleDAO = new ModuleDAO();
    private ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

    public Map<Module, List<Lesson>> getCourseContent(int courseId) throws SQLException {
        List<Module> modules = moduleDAO.getModulesByCourse(courseId);
        Map<Module, List<Lesson>> result = new LinkedHashMap<>();
        for (Module m : modules) {
            List<Lesson> lessons = lessonDAO.getLessonsByModule(m.getModuleId());
            result.put(m, lessons);
        }
        return result;
    }

    public Lesson getLessonById(int lessonId) {
        return lessonDAO.getLessonById(lessonId);
    }

    public boolean addLesson(Lesson lesson, int moduleId) {
        try {
            if (lesson == null || lesson.getTitle() == null || lesson.getTitle().trim().isEmpty()) {
                System.err.println("️ Invalid lesson data");
                return false;
            }

            int orderIndex = moduleItemDAO.getNextOrderIndex(moduleId);

            ModuleItem item = new ModuleItem();
            item.setModule(moduleDAO.getModuleById(moduleId));
            item.setItemType("lesson");
            item.setOrderIndex(orderIndex);
            item.setRequired(true);

            int moduleItemId = moduleItemDAO.insertModuleItem(item);
            if (moduleItemId == -1) {
                System.err.println(" Failed to insert ModuleItem for lesson");
                return false;
            }

            lesson.setModuleItemId(moduleItemId);

            lessonDAO.insertLesson(lesson);
            return true;

        } catch (Exception e) {
            System.err.println("Error inserting lesson: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteLesson(int lessonId) {
        try {

            boolean moduleDeleted = moduleItemDAO.deleteModuleItem(lessonId);
            return moduleDeleted;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateLesson(Lesson lesson) {
        try {
            lessonDAO.updateLesson(lesson);
            System.out.println("Lesson updated successfully!");
            return true;
        } catch (Exception e) {
            System.err.println("Error updating reading lesson: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

}
