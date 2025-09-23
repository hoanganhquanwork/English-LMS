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

    public int saveToken(String token, int userId, LocalDateTime expiryDate) {
        return tdao.saveToken(token, userId, expiryDate);
    }

    public Users getUserByToken(String token) {
        return tdao.getUserByToken(token);
    }

    public int deleteToken(String token) {
        return tdao.deleteToken(token);
    }
}
