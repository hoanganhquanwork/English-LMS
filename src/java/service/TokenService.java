/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TokenDAO;
import java.time.LocalDateTime;
import model.Users;

/**
 *
 * @author Admin
 */
public class TokenService {

    private TokenDAO tdao = new TokenDAO();

    public int saveRememberToken(String token, int userId, LocalDateTime expiryDate) {
        return tdao.saveRememberToken(token, userId, expiryDate);
    }

    public Users getUserByRememberToken(String token) {
        return tdao.getUserByRememberToken(token);
    }

    public int deleteRememberToken(String token) {
        return tdao.deleteRememberToken(token);
    }  
    
    public Integer verifyResetToken(String token){
        return tdao.getUserIdByResetToken(token);
    }
    
    public int markUsedResetToken(String token){
        return tdao.markUsedToken(token);
    }
    
    public Users getUserByResetToken(String token){
        return tdao.getUserByResetToken(token);
    }
}
