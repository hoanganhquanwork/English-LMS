/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ReviewDAO;
import java.util.Collection;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class ReviewService {

    private final ReviewDAO rdao = new ReviewDAO();

    public Map<Integer, Double> getAvgForCourses(Collection<Integer> courseIds) {
        return rdao.getAvgForCourses(courseIds);
    }
    
    public double getAvarageRateForCourse(int courseId){
        return rdao.getAvarageRatingCourse(courseId);
    }
}
