package service;

import dal.CategoryDAO;
import dal.TopicDAO;
import java.util.List;
import model.entity.Category;
import model.entity.Topic;

public class CateAndTopicService {

    private final CategoryDAO cDAO = new CategoryDAO();
    private final TopicDAO tDAO = new TopicDAO();

    public List<Category> getAllCategories() {
        return cDAO.getAllCategories();
    }

    public Category getCategoryById(int id) {
        return cDAO.getCategoryById(id);
    }

    public boolean addCategory(Category c) {
        if (c == null || c.getName() == null || c.getName().trim().isEmpty()) {
            System.err.println("Tên danh mục không được để trống!");
            return false;
        }
        return cDAO.insertCategory(c);
    }

    public boolean updateCategory(Category c) {
        if (c == null || c.getCategoryId() <= 0) {
            System.err.println("ID danh mục không hợp lệ!");
            return false;
        }
        return cDAO.updateCategory(c);
    }

    public List<Topic> getAllTopics() {
        return tDAO.getAllTopics();
    }

    public Topic getTopicById(int id) {
        return tDAO.getTopicById(id);
    }

    public boolean addTopic(Topic t) {
        if (t == null || t.getName() == null || t.getName().trim().isEmpty()) {
            System.err.println("Tên topic không được để trống!");
            return false;
        }
        return tDAO.insertTopic(t);
    }

    public boolean updateTopic(Topic t) {
        if (t == null || t.getTopicId() <= 0) {
            System.err.println("ID topic không hợp lệ!");
            return false;
        }
        return tDAO.updateTopic(t);
    }

    public boolean isCategoryDuplicate(String name) {
        return cDAO.isCategoryNameExists(name);
    }

    public boolean isTopicDuplicate(String name) {
        return tDAO.isTopicNameExists(name);
    }

    public boolean isCategoryDuplicateForUpdate(String name, int excludeId) {
        return cDAO.isCategoryNameExistsForUpdate(name, excludeId);
    }
    public boolean isTopicDuplicateForUpdate(String name, int excludeId) {
    return tDAO.isTopicNameExistsForUpdate(name, excludeId);
}
    
    
}
