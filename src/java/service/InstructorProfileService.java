package service;

import dal.InstructorProfileDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDate;
import model.entity.InstructorProfile;
import model.entity.Users;

public class InstructorProfileService {

    private final InstructorProfileDAO instructorProfileDAO = new InstructorProfileDAO();
    private final UserDAO userDAO = new UserDAO();

    public InstructorProfile getInstructorProfile(int userId) {
        InstructorProfile profile = instructorProfileDAO.getByUserId(userId);
        if (profile == null) {
            // Create a new profile if it doesn't exist
            Users user = userDAO.getUserById(userId);
            if (user != null) {
                profile = new InstructorProfile();
                profile.setUser(user);
                profile.setBio("");
                profile.setExpertise("");
                profile.setQualifications("");
            }
        }
        return profile;
    }

   public boolean updateAll(Users u,
                             String fullName,
                             String phone,
                             LocalDate dob,
                             String gender,
                             String bio,
                             String expertise,
                             String qualifications) {

        InstructorProfile profile = new InstructorProfile();
        profile.setUser(u);

        if (bio != null && !bio.isBlank()) {
            profile.setBio(bio.trim());
        }
        if (expertise != null && !expertise.isBlank()) {
            profile.setExpertise(expertise.trim());
        }
        if (qualifications != null && !qualifications.isBlank()) {
            profile.setQualifications(qualifications.trim());
        }

        int a = instructorProfileDAO.updateInstructorProfile(profile);
        int b = userDAO.updateBasic(
                u.getUserId(),
                (fullName != null && !fullName.isBlank()) ? fullName.trim() : null,
                (phone != null && !phone.isBlank()) ? phone.trim() : null,
                dob,
                (gender != null && !gender.isBlank()) ? gender.trim() : null
        );

        return (a >= 0 && b >= 0);
    }

    public Users getUser(int userId) {
        return userDAO.getUserById(userId);
    }

    public boolean updateUser(Users user) {
        return userDAO.updateUser(user);
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

