/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author LENOVO
 */
public class CourseManagers {
    private int courseId;
    private int userId;
    private boolean isPrimary;
    private boolean canApproved;
    private boolean canViewReports;

    public CourseManagers() {
    }

    public CourseManagers(int courseId, int userId, boolean isPrimary, boolean canApproved, boolean canViewReports) {
        this.courseId = courseId;
        this.userId = userId;
        this.isPrimary = isPrimary;
        this.canApproved = canApproved;
        this.canViewReports = canViewReports;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isIsPrimary() {
        return isPrimary;
    }

    public void setIsPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    public boolean isCanApproved() {
        return canApproved;
    }

    public void setCanApproved(boolean canApproved) {
        this.canApproved = canApproved;
    }

    public boolean isCanViewReports() {
        return canViewReports;
    }

    public void setCanViewReports(boolean canViewReports) {
        this.canViewReports = canViewReports;
    }
}
