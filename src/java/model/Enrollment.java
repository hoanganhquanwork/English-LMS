/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Date;

/**
 *
 * @author Lenovo
 */
public class Enrollment {

    private int enrollmentId;
    private Course course;       // nối đến Course
    private StudentProfile student; // nối đến StudentProfile
    private String status;       // active, completed
    private Date enrolledAt;

    public Enrollment() {
    }

    public Enrollment(int enrollmentId, Course course, StudentProfile student, String status, Date enrolledAt) {
        this.enrollmentId = enrollmentId;
        this.course = course;
        this.student = student;
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

    public StudentProfile getStudent() {
        return student;
    }

    public void setStudent(StudentProfile student) {
        this.student = student;
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

    @Override
    public String toString() {
        return "Enrollment{" + "enrollmentId=" + enrollmentId + ", course=" + course + ", student=" + student + ", status=" + status + ", enrolledAt=" + enrolledAt + '}';
    }

 
    
    
}
