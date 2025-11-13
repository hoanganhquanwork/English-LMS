package service;

import dal.AdminProfileDAO;
import dal.ParentProfileDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDate;
import model.entity.Users;

public class AdminProfileService {

    private final AdminProfileDAO dao = new AdminProfileDAO();
    private final ParentProfileDAO pdao = new ParentProfileDAO();

    public Users getProfile(int id) {
        return dao.getProfile(id);
    }

    public String updateProfile(Users user) {
        String email = user.getEmail();
        if (email==null) return "Email không được để trống";
        if (pdao.isEmailExists(email, user.getUserId())) {
            return "Email đã được sử dụng!";
        }
        if (email.length() < 3) {
            return "Email phải có ít nhất 3 ký tự.";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return "Định dạng email không hợp lệ.";
        }
        if (user == null || user.getUserId() <= 0) {
            return "Người dùng không hợp lệ.";
        }
        String fullName = user.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Họ tên không được để trống.";
        }
        if (fullName.length() > 100) {
            return "Họ tên quá dài (tối đa 100 ký tự).";
        }
        if (!fullName.matches("^[\\p{L}\\s'.-]+$")) {
            return "Họ tên chỉ được chứa chữ cái và dấu cách.";
        }

        String phone = user.getPhone();
        if (phone != null && !phone.isBlank()) {
            phone = phone.trim();
            if (!phone.matches("^\\+?[0-9]{7,15}$")) {
                return "Số điện thoại không hợp lệ (7–15 số, có thể có dấu +).";
            }
            if (pdao.isPhoneExists(user.getPhone(), user.getUserId())) {
                return "Số điện thoại đã được sử dụng bởi tài khoản khác.";
            }
            user.setPhone(phone);
        }

        String gender = user.getGender();
        if (gender != null && !gender.isBlank()) {
            String g = gender.trim().toLowerCase();
            if (!(g.equals("male") || g.equals("female") || g.equals("other"))) {
                return "Giới tính phải là male, female hoặc other.";
            }
            user.setGender(g);
        }

        if (user.getDateOfBirth() != null) {
            LocalDate dob = user.getDateOfBirth();
            LocalDate today = LocalDate.now();
            if (dob.isAfter(today)) {
                return "Ngày sinh không được ở tương lai.";
            }
            if (dob.isBefore(today.minusYears(120))) {
                return "Ngày sinh không hợp lệ (tuổi vượt quá 120).";
            }
            if (dob.isAfter(today.minusYears(18))) {
                return "Ngày sinh không hợp lệ (tuổi dưới 18).";
            }
        }
        boolean updated = dao.updateProfile(user);
        if (updated) {
            return "success";
        } else {
            return "Cập nhật thất bại. Vui lòng thử lại!";
        }
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
