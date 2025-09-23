/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TokenDAO;
import dal.UserDAO;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;
import model.OauthAccount;
import model.Users;
import util.GoogleLogin;

/**
 *
 * @author Admin
 */
public class AuthService {

    private UserDAO udao = new UserDAO();
    private TokenDAO tdao = new TokenDAO();

    public String register(Users user) {
        String email = user.getEmail();
        if (udao.getUserByEmail(email) != null) {
            return "Email đã được sử dụng!";
        }
        String username = user.getUsername();
        if (udao.getUserByUserName(username) != null) {
            return "Tên đăng nhập tồn tại";
        }
        String plainPassword = user.getPassword();
        String hashedPassword = util.BCryptUtil.hashPassword(plainPassword);
        user.setPassword(hashedPassword);
        int row = udao.register(user);
        if (row > 0) {
            return "success";
        } else {
            return "Đăng ký thất bại vui lòng thử lại!";
        }
    }

//    return user when password correct and status = 'active'
    public Users login(String login, String password) {
        return udao.getUserByLogin(login, password, true);
    }

//    check deactivated user
    public boolean isInactiveUser(String login, String password) {
        Users u = udao.getUserByLogin(login, password, false);
        return (u != null && !"active".equalsIgnoreCase(u.getStatus()));
    }

    public Users loginWithGoogle(String code) throws IOException {
        String accessToken = GoogleLogin.getToken(code);

        OauthAccount account = GoogleLogin.getUserInfo(accessToken);

        Users user = udao.getUserByProvider("google", account.getId());

        if (user == null) {
            if (udao.getUserByEmail(account.getEmail()) != null || udao.getUserByUserName(account.getEmail()) != null) {
                throw new IllegalStateException("Email đã được sử dụng");
            }
            user = new Users();
            user.setUsername(account.getEmail());
            user.setFullName(account.getName());
            user.setProfilePicture(account.getPicture());
            user.setEmail(account.getEmail());
            user.setStatus("active");
            user.setRole("Student");
            int inserted = udao.register(user);
            if (inserted <= 0) {
                throw new IllegalStateException("Không thể tạo tài khoản người dùng");
            }

            int linked = udao.linkOAuthAccount(user.getUserId(), "google", account.getId());
            if (linked <= 0) {
                throw new IllegalStateException("Không thể liên kết tài khoản");
            }
        }
        return user;
    }

    public void createRememberMe(Users user, HttpServletResponse resp) {
        String token = UUID.randomUUID().toString();
        LocalDateTime expiry = LocalDateTime.now().plusDays(14);
        tdao.saveToken(token, user.getUserId(), expiry);

        Cookie ck = new Cookie("rememberToken", token);
        ck.setHttpOnly(true);
        ck.setPath("/");
        ck.setMaxAge(14 * 24 * 60 * 60);
        resp.addCookie(ck);
    }

    public Users autoLoginFromToken(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            return null;
        }
        Users u = tdao.getUserByToken(rawToken);
        if (u == null) {
            return null;
        }
        if (!"active".equalsIgnoreCase(u.getStatus())) {
            return null;
        }
        return u;
    }

    public void revokeRememberToken(String rawToken) {
        if (rawToken != null && !rawToken.isBlank()) {
            tdao.deleteToken(rawToken);
        }
    }
}
