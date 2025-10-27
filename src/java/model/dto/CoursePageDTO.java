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
    
    // Quan
    private double progressPct;
    private int completedItems;
    private int totalItems;
    private int totalRequired;
    private int completedRequired;
    private Double avgScorePct;

    public double getProgressPct() {
        return progressPct;
    }

    public void setProgressPct(double progressPct) {
        this.progressPct = progressPct;
    }

    public int getCompletedItems() {
        return completedItems;
    }

    public void setCompletedItems(int completedItems) {
        this.completedItems = completedItems;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public int getTotalRequired() {
        return totalRequired;
    }

    public void setTotalRequired(int totalRequired) {
        this.totalRequired = totalRequired;
    }

    public int getCompletedRequired() {
        return completedRequired;
    }

    public void setCompletedRequired(int completedRequired) {
        this.completedRequired = completedRequired;
    }

    public Double getAvgScorePct() {
        return avgScorePct;
    }

    public void setAvgScorePct(Double avgScorePct) {
        this.avgScorePct = avgScorePct;
    }

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