package service;

import dal.AdminUserDAO;
import model.Users;
import java.util.List;

public class AdminUserService {

    private final AdminUserDAO dao = new AdminUserDAO();

    public Users getUserById(int id) {
        return dao.getById(id);
    }

    public void deleteUser(int id) {
        dao.deleteById(id);
    }

    public int countSearchUsers(String keyword, String role, String status) {
        return dao.countSearch(keyword, role, status);
    }

    public List<Users> searchUsersPaged(String keyword, String role, String status, int page, int size) {
        return dao.searchPaged(keyword, role, status, page, size);
    }

    public int countAllUsers() {
        return dao.countAllUsers();
    }

    public int countInstructors() {
        return dao.countInstructors();
    }

//    public void addUser(Users u) { dao.insert(u); }
    public int updateUser(int id, String username, String email, String role, String status,
            String phone, java.sql.Date dob, String gender) {
        return dao.updateBasic(id, username, email, role, status, phone, dob, gender);
    }

}
