package service;

import dal.ParentProfileDAO;
import model.Users;
import model.ParentProfile;

public class ParentProfileService {
    private final ParentProfileDAO dao = new ParentProfileDAO();

    public Users getUser(int userId) {
        return dao.getUserById(userId);
    }

    public ParentProfile getParentProfile(int userId) {
        return dao.getParentProfileById(userId);
    }

    public void updateProfile(Users u, ParentProfile p) {
        if (u.getEmail() == null || !u.getEmail().contains("@")) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }
        if (u.getFullName() == null || u.getFullName().isBlank()) {
            throw new IllegalArgumentException("Tên không được để trống");
        }
        dao.updateUser(u);
        dao.updateParentProfile(p);
    }
    
}
