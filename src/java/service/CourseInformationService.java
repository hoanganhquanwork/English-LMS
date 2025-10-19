/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import dal.CourseInformationDAO;
import java.util.List;
import java.util.NoSuchElementException;
import model.dto.CourseInformationDTO;
import model.dto.ReviewDTO;

/**
 *
 * @author Admin
 */
public class CourseInformationService {

    private final CourseInformationDAO courseInformationDAO = new CourseInformationDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    public CourseInformationDTO getCourseInformation(int courseId) {
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId phải > 0");
        }

        String status = courseDAO.getCourseStatus(courseId);

        if (status == null) {
            throw new NoSuchElementException("Course không thấy");
        }

        if (!status.equalsIgnoreCase("publish")) {
            throw new NoSuchElementException("Course không khả thi");
        }

        CourseInformationDTO course = courseInformationDAO.getFullCourseInformation(courseId);
        if (course == null) {
            throw new NoSuchElementException("Course không thấy");
        }
        return course;
    }
    
    public List<CourseInformationDTO>getRandomSameCategory(int courseId){
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId phải > 0");
        }
        return courseInformationDAO.getRandomSameCategory(courseId);
    }

    public List<ReviewDTO> getTopFourLatestReview(int courseId) {
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId phải > 0");
        }
        return courseInformationDAO.getTopFourLatestReview(courseId);

    }

}
