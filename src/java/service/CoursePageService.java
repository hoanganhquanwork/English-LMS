/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import dal.ModuleDAO;
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
}
