/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ManagerDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.entity.ManagerProfile;
import model.entity.Users;

public class ManagerService {

    private final ManagerDAO managerDAO = new ManagerDAO();
    private final UserDAO userDAO = new UserDAO();

    public ManagerProfile getManagerProfile(int userId) {
        return managerDAO.getByUserId(userId);
    }
    public boolean updateProfile(ManagerProfile mp) {
        return managerDAO.updateManagerProfile(mp);
    }
    public Users getUser(int userId) {
        return userDAO.getUserById(userId);
    }
    public boolean updateUser(Users u) {
        return userDAO.updateUser(u);
    }
     public boolean updateAvatar(HttpServletRequest request, Users user) throws IOException, ServletException {
        Part avatar = request.getPart("avatar");
        if (avatar == null || avatar.getSize() <= 0) {
            return false; 
        }
        int maxSize = 5 * 1024 * 1024;
        if (avatar.getSize() > maxSize) {
            return false;
        }
        String shortPath = Paths.get(avatar.getSubmittedFileName()).getFileName().toString();
        String savePath = request.getServletContext().getRealPath("/image/avatar") + File.separator + shortPath;
        avatar.write(savePath);
        user.setProfilePicture("image/avatar/" + shortPath);
        return true;
    }
}
