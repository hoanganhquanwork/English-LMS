/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.EnrollmentDAO;
import java.util.List;
import model.Enrollment;

/**
 *
 * @author Lenovo
 */
public class EnrollmentService {
    private EnrollmentDAO dao = new EnrollmentDAO();

    public List<Enrollment> getEnrollments(int courseId, String keyword, String status) {
        return dao.searchAndFilterEnrollments(courseId, keyword, status);
    }
}
