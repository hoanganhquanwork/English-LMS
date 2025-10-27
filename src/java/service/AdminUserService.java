package service;

import dal.AdminUserDAO;
import model.entity.Users;
import java.sql.Date;
import java.util.List;

public class AdminUserService {
    private final AdminUserDAO userDAO = new AdminUserDAO();

    public Users getUserById(int id) {
        return userDAO.getById(id);
    }

    public int deleteUser(int id) {
        return userDAO.deleteById(id);
    }

    public int countSearchUsers(String keyword, String role, String status) {
        return userDAO.countSearch(keyword, role, status);
    }

    public List<Users> searchUsersPaged(String keyword, String role, String status, int page, int size) {
        return userDAO.searchPaged(keyword, role, status, page, size);
    }

    public int countAllUsers() {
        return userDAO.countAllUsers();
    }

    public int countInstructors() {
        return userDAO.countInstructors();
    }

    /** 
     * Update user basic info 
     */
    public int updateUser(int id, String username, String email, String role, String status,
                          String phone, Date dob, String gender) {
        return userDAO.updateBasic(id, username, email, role, status, phone, dob, gender);
    }
    
    /**
     * Update only user status
     */
    public int updateUserStatus(int id, String status) {
        return userDAO.updateStatus(id, status);
    }
    
    /**
     * Count users by status
     */
    public int countUsersByStatus(String status) {
        return userDAO.countByStatus(status);
    }
    
    /**
     * Get distinct roles from database
     */
    public List<String> getDistinctRoles() {
        return userDAO.getDistinctRoles();
    }
    
    /**
     * Get distinct statuses from database
     */
    public List<String> getDistinctStatuses() {
        return userDAO.getDistinctStatuses();
    }
}
