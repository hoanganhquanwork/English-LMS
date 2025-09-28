/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import java.util.List;
import model.Category;
import model.Course;

/**
 *
 * @author Admin
 */
public class HomeService {
    private CourseDAO cdao = new CourseDAO();
    
    public List<Category> getAllCategories(){
        return cdao.getAllCategories();
    }
    
    public List<Course> getTopPopularCourse(){
        return cdao.getTopPopularCourse();
    }
    
    public List<Course> getTopNewestCourses(){
        return cdao.getTopNewestCourses();
    }
}
