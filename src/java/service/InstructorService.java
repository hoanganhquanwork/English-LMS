/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import dal.InstructorDAO;
import dal.InstructorProfileDAO;
import java.util.List;
import model.entity.Course;
import model.entity.InstructorProfile;

/**
 *
 * @author Lenovo
 */
public class InstructorService {
    private InstructorDAO instructorDAO = new InstructorDAO();
     private InstructorProfileDAO dao = new InstructorProfileDAO();
    private CourseDAO courseDAO = new CourseDAO();
    public int getCourseCount(int instructorId) {
        return instructorDAO.countCoursesByInstructor(instructorId);
    }

    public int getActiveStudentCount(int instructorId) {
        return instructorDAO.countStudentsByInstructor(instructorId);
    }
    
      public InstructorProfile getInstructor(int userId) {
        return dao.getByUserId(userId);
    }

    public List<Course> getInstructorCourses(int userId) {
        return courseDAO.getCoursesByInstructor(userId);
    }
}
