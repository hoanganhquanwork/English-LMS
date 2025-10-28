/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CategoryDAO;
import java.util.List;
import model.entity.Category;

/**
 *
 * @author Lenovo
 */
public class CategoryService {

    private CategoryDAO cdao = new CategoryDAO();

    public List<Category> getAllCategories() {
        return cdao.getAllCategories();
    }
}
