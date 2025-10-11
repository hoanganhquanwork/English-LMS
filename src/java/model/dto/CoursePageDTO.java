/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.util.List;
import model.entity.Course;

/**
 *
 * @author Admin
 */
public class CoursePageDTO {

    private Course course;
    private List<ModuleWithItemsDTO> modules;

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public List<ModuleWithItemsDTO> getModules() {
        return modules;
    }

    public void setModules(List<ModuleWithItemsDTO> modules) {
        this.modules = modules;
    }

}
