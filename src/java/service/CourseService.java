/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import java.util.List;
import model.entity.Course;

/**
 *
 * @author Lenovo
 */
public class CourseService {

    private CourseDAO courseDAO = new CourseDAO();

    public boolean isEnrolled(int studentId, int courseId) {
        if (studentId < 0) {
            throw new IllegalArgumentException("studentId không hợp lệ");
        }
        if (courseId < 0) {
            throw new IllegalArgumentException("courseId không hợp lệ");
        }
        return courseDAO.isEnrolled(studentId, courseId);
    }

    public String getEnrollmentStatus(int studentId, int courseId) {
        if (studentId <= 0 || courseId <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return courseDAO.getEnrollmentStatus(studentId, courseId);
    }

    public int getLessonCount(int courseId) {
        return courseDAO.countLessonsByCourse(courseId);
    }

    public int getStudentCount(int courseId) {
        return courseDAO.countStudentsByCourse(courseId);
    }

    public List<Course> searchAndFilterCourses(int instructorId, String keyword, String status) {
        return courseDAO.searchAndFilterCourses(instructorId, keyword, status);
    }

    public boolean createCourse(Course course) {
        return courseDAO.addCourse(course);
    }

    public boolean updateCourse(Course course) {
        return courseDAO.updateCourse(course);
    }

    public Course getCourseById(int courseId) {
        return courseDAO.getCourseById(courseId);
    }

    public boolean removeCourse(int courseId) {
        return courseDAO.deleteCourse(courseId);
    }

    public boolean submitCourse(int courseId) {
        return courseDAO.updateCourseStatus(courseId, "submitted");
    }
}
