package service;

import dal.UserDAO;
import model.Users;
import java.util.List;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    /* Paged + count for filters (phục vụ phân trang) */
    public int countSearchUsers(String keyword, String role, String status) {
        return userDAO.countSearchUsers(keyword, role, status);
    }

    public List<Users> searchUsersPaged(String keyword, String role, String status, int page, int size) {
        return userDAO.searchUsersPaged(keyword, role, status, page, size);
    }

    public List<Users> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public Users getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public void deleteUser(int id) {
        userDAO.deleteUser(id);
    }

    public void addUser(Users u) {
        userDAO.addUser(u);
    }

    public void updateUser(int id, String username, String email, String role, String status) {
        userDAO.updateUser(id, username, email, role, status);
    }

    public int countAllUsers() {
        return userDAO.countAllUsers();
    }

    public int countInstructors() {
        return userDAO.countByRole("Instructor");
    }
}
