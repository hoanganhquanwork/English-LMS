/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDate;
import model.StudentProfile;
import model.Users;

/**
 *
 * @author Admin
 */
public class StudentService {

    private final StudentDAO sdao = new StudentDAO();
    private final UserDAO udao = new UserDAO();

    public StudentProfile getStudentProfile(int userId) {
        return sdao.findStudentById(userId);
    }

    //update profile information
    public boolean updateAll(int userId, String fullName,
            String phone, LocalDate dob, String gender, String address,
            String gradeLevel, String institution) {
        StudentProfile sp = new StudentProfile();
        sp.setUserId(userId);
        if (address != null && !address.isBlank()) {
            sp.setAddress(address.trim());
        }

        if (gradeLevel != null && !gradeLevel.isBlank()) {
            sp.setGradeLevel(gradeLevel.trim());
        }

        if (institution != null && !institution.isBlank()) {
            sp.setInstitution(institution.trim());
        }

        int a = sdao.updateStudentProfile(sp);
        int b = udao.updateBasic(
                userId,
                (fullName != null && !fullName.isBlank()) ? fullName.trim() : null,
                (phone != null && !phone.isBlank()) ? phone.trim() : null,
                dob,
                (gender != null && !gender.isBlank()) ? gender.trim() : null
        );
        return (a >= 0 && b >= 0);
    }

    public boolean updateAvatar(HttpServletRequest request, Users user) throws IOException, ServletException {
        Part avatar = request.getPart("avatar");
        if (avatar == null || avatar.getSize() <= 0) {
            return false; //Khong ai tai len
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
