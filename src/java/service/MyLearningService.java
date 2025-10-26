/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.MyLearningDAO;
import java.util.List;
import model.dto.MyLearningCompletedDTO;
import model.dto.MyLearningInProgressDTO;

/**
 *
 * @author Admin
 */
public class MyLearningService {

    MyLearningDAO mdao = new MyLearningDAO();

    public List<MyLearningInProgressDTO> getInProgressCourses(int studentId) {
        return mdao.getInProgressCourses(studentId);
    }

    public List<MyLearningCompletedDTO> getCompletedCourses(int studentId) {
        return mdao.getCompletedCourse(studentId);
    }
}
