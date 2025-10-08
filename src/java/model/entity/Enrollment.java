/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.sql.Date;

/**
 *
 * @author Lenovo
 */
public class Enrollment {

    private int enrollmentId;
    private Course course;       // nối đến Course
    private Users user;      // nối đến StudentProfile
    private String status;       // active, completed
    private Date enrolledAt;

    public Enrollment() {
    }

    public Enrollment(int enrollmentId, Course course, Users user, String status, Date enrolledAt) {
        this.enrollmentId = enrollmentId;
        this.course = course;
        this.user = user;
        this.status = status;
        this.enrolledAt = enrolledAt;
    }

    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getEnrolledAt() {
        return enrolledAt;
    }

    public void setEnrolledAt(Date enrolledAt) {
        this.enrolledAt = enrolledAt;
    }


}
