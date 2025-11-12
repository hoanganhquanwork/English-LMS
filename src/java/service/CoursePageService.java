/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import dal.ModuleDAO;
import dal.ParentProgressDAO;
import java.sql.SQLException;
import java.util.List;
import model.dto.CoursePageDTO;
import model.dto.ModuleItemViewDTO;
import model.dto.ModuleWithItemsDTO;
import model.entity.Course;

/**
 *
 * @author Admin
 */
public class CoursePageService {

    private final CourseDAO courseDAO = new CourseDAO();
    private final ModuleDAO moduleDAO = new ModuleDAO();
    private ParentProgressDAO ParentDAO = new ParentProgressDAO();


    public CoursePageDTO getCoursePage(int courseId, int studentId) {
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId phải > 0");
        }
        if (studentId <= 0) {
            throw new IllegalArgumentException("studentId phải > 0");
        }
        Course course = courseDAO.getCourseById(courseId);
        if (course == null) {
            throw new RuntimeException("Course không tìm thấy: " + courseId);
        }
        List<ModuleWithItemsDTO> modules = moduleDAO.listModuleWithItems(courseId, studentId);
        for (ModuleWithItemsDTO m : modules) {
            for (ModuleItemViewDTO it : m.getItems()) {
                if (it.getDurationSec() != null) {
                    int minute = (int) Math.ceil(it.getDurationSec() / 60.0);
                    it.setDurationMin(minute);
                }
            }
        }
        CoursePageDTO dto = new CoursePageDTO();
        dto.setCourse(course);
        dto.setModules(modules);
        return dto;
    }

    //Quan
    public CoursePageDTO getCourseProgressForParent(int studentId, int courseId) throws SQLException {
        Course course = courseDAO.getCourseById(courseId);
        List<ModuleWithItemsDTO> modules = moduleDAO.getModulesWithItemsByCourseId(studentId, courseId);
        int total = 0;
        int completed = 0;
        int totalRequired = 0;
        int completedRequired = 0;

        for (ModuleWithItemsDTO m : modules) {
            int moduleTotal = m.getItems().size();
            int moduleDone = 0;
            for (var i : m.getItems()) {
                 if ("completed".equals(i.getStatus())) {
                    moduleDone++;
                }
                if (i.isRequired()) {
                    totalRequired++;
                    if ("completed".equalsIgnoreCase(i.getStatus())) {
                        completedRequired++;
                    }
                }
            }
            total += moduleTotal;
            completed += moduleDone;
        }

        Double avgScore = ParentDAO.calculateAverageScore(studentId, courseId);

        CoursePageDTO dto = new CoursePageDTO();
        dto.setCourse(course);
        dto.setModules(modules);
        dto.setTotalRequired(totalRequired);
        dto.setCompletedRequired(completedRequired);
        dto.setTotalItems(total);
        dto.setCompletedItems(completed);
        dto.setAvgScorePct(avgScore);

        return dto;
    }
}
