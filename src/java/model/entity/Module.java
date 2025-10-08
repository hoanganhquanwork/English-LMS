/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class Module {

    private int moduleId;
    private Course course;
    private String title;
    private String description;
    private int orderIndex;
    private InstructorProfile createdBy;

 
    public Module() {
    }

    public Module(int moduleId, Course course, String title, String description, int orderIndex, InstructorProfile createdBy) {
        this.moduleId = moduleId;
        this.course = course;
        this.title = title;
        this.description = description;
        this.orderIndex = orderIndex;
        this.createdBy = createdBy;
    }


    
    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public String getTitle() {
        return title;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }
    

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public InstructorProfile getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(InstructorProfile createdBy) {
        this.createdBy = createdBy;
    }


}


