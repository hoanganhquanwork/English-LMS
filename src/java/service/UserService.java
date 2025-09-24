/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.UserDAO;
import model.Users;

/**
 *
 * @author Admin
 */
public class UserService {

    private final UserDAO udao = new UserDAO();
    
    public Users getUserById(int userId){
        return udao.getUserById(userId);
    }
    
    public boolean updateProfilePicture(Users user){
        return udao.updateProfilePicture(user);
    }
}
