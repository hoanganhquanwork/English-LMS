/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseManagerDAO;
import java.math.BigDecimal;
import model.Course;
import java.util.List;
import java.util.stream.Collectors;
import model.CourseManagers;

public class CourseManagerService {

    private final CourseManagerDAO dao;

    public CourseManagerService() {
        this.dao = new CourseManagerDAO();
    }

    public List<Course> getAllCourses() {
        return dao.getAllCourses();
    }

    public List<Course> getFilteredCourses(String status, String keyword, String sort) {
        return dao.getFilteredCourses(status, keyword, sort);
    }
    public boolean updateCourseStatus(int courseId, String status) {
        return dao.updateCourseStatus(courseId, status);
    }

    public Course getCourseById(int courseId) {
        return dao.getCourseById(courseId);
    }
    public boolean updateCoursePrice(int courseId, BigDecimal price){
    return dao.updateCoursePrice(courseId, price);
    }
}
