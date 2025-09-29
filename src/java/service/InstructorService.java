/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.InstructorDAO;

/**
 *
 * @author Lenovo
 */
public class InstructorService {
    private InstructorDAO instructorDAO = new InstructorDAO();

    public int getCourseCount(int instructorId) {
        return instructorDAO.countCoursesByInstructor(instructorId);
    }

    public int getActiveStudentCount(int instructorId) {
        return instructorDAO.countStudentsByInstructor(instructorId);
    }
}
