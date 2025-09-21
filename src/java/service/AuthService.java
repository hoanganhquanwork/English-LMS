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
public class AuthService {
    UserDAO udao = new UserDAO();
    
    public String register(Users user){
        String email = user.getEmail();
        if(udao.getUserByEmail(email) != null){
            return "Email đã được sử dụng!";
        }
        String username = user.getUsername();
        if(udao.getUserByUserName(username) != null){
            return "Tên đăng nhập tồn tại";
        }
        String plainPassword = user.getPassword();
        String hashedPassword = util.BCryptUtil.hashPassword(plainPassword);
        user.setPassword(hashedPassword);
        int row = udao.register(user);
        if(row > 0){
            return "success";
        }else{
            return "Đăng ký thất bại vui lòng thử lại!";
        }
    }
}
