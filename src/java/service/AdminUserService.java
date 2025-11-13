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

    public String updateUser(int id, String username, String email, String status,
                         String phone, Date dob, String gender) {

    // --- Validate cơ bản ---
    if (id <= 0)
        return "ID người dùng không hợp lệ.";

    if (username == null || username.trim().isEmpty())
        return "Tên người dùng không được để trống.";

    if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"))
        return "Định dạng email không hợp lệ.";

    if (status == null || !(status.equals("active") || status.equals("deactivated")))
        return "Trạng thái phải là 'active' hoặc 'deactivated'.";

    if (phone != null && !phone.isBlank() && !phone.matches("^\\+?[0-9]{7,15}$"))
        return "Số điện thoại không hợp lệ.";

    if (gender != null && !gender.isBlank()) {
        String g = gender.toLowerCase();
        if (!(g.equals("male") || g.equals("female") || g.equals("other")))
            return "Giới tính phải là male, female hoặc other.";
    }

    // --- Check trùng username ---
    if (userDAO.isUsernameTaken(username, id))
        return "Tên người dùng đã tồn tại.";

    // --- Check trùng email ---
    if (userDAO.isEmailTaken(email, id))
        return "Email đã được sử dụng.";

    int rows = userDAO.updateBasic(id, username.trim(), email.trim(), status, phone, dob, gender);
    if (rows > 0)
        return "success";
    else
        return "Cập nhật thất bại. Vui lòng thử lại.";
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
