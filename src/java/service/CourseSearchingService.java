/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import model.Category;
import model.Course;

/**
 *
 * @author Admin
 */
public class CourseSearchingService {

    CourseDAO cdao = new CourseDAO();

    public List<Course> searchCourse(int[] categoryIDs, String[] languages, String[] levels, String keyword, String sortBy,
            int pageIndex, int pageSize) {
        return cdao.searchCourse(categoryIDs, languages, levels, keyword, sortBy, pageIndex, pageSize);
    }

    public int countCourse(int[] categoryIDs, String[] languages, String[] levels, String keyword) {
        return cdao.countCourse(categoryIDs, languages, levels, keyword);
    }

    public List<Category> getAllCategories() {
        return cdao.getAllCategories();
    }

    public List<String> getAllLanguages() {
        return cdao.getAllLanguages();
    }

    public List<String> getAllLevels() {
        return cdao.getAllLevels();
    }
    
     public Map<Integer, Integer> getEnrollCounts(Collection<Integer> courseIds) {
        return cdao.getEnrollCounts(courseIds);
    }
}
