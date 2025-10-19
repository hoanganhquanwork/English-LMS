package service;

import dal.AdminProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.entity.Users;

public class AdminProfileService {
    private final AdminProfileDAO dao = new AdminProfileDAO();

    public Users getProfile(int id) {
        return dao.getProfile(id);
    }

    public boolean updateProfile(Users user) {
        return dao.updateProfile(user);
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
