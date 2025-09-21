/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author Admin
 */
public class BCryptUtil {
    public static String hashPassword(String plainPassword){
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }
    
    public static boolean checkPassword(String plainPassword, String hashedPassword){
        if(hashedPassword == null || hashedPassword.startsWith("$2a$")){
            throw new IllegalArgumentException("Invalid hash");
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
