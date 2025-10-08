/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ManagerDAO;
import dal.UserDAO;
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
}
