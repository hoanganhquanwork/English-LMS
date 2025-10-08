package service;

import dal.ParentProfileDAO;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import model.entity.Users;
import model.entity.ParentProfile;

public class ParentProfileService {

    private final ParentProfileDAO dao = new ParentProfileDAO();

    public Users getUser(int userId) {
        Users u = dao.getUserById(userId);

        if (u != null && u.getDateOfBirth() != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            u.setFormattedDateOfBirth(u.getDateOfBirth().format(formatter));
        }

        return u;
    }

    public ParentProfile getParentProfile(int userId) {
        return dao.getParentProfileById(userId);
    }

    public void updateProfile(Users u, ParentProfile p) {
        if (u.getFullName() == null || u.getFullName().isBlank()) {
            throw new IllegalArgumentException("Tên không được để trống.");
        }

        if (!u.getFullName().matches("^[A-Za-zÀ-ỹ\\s]{2,50}$")) {
            throw new IllegalArgumentException("Tên không hợp lệ. "
                    + "Tên chỉ được chứa chữ cái và khoảng trắng (không chứa số hoặc ký tự đặc biệt).");
        }

        if (u.getEmail() == null || !u.getEmail().contains("@")) {
            throw new IllegalArgumentException("Email không hợp lệ.");
        }

        if (u.getPhone() != null && !u.getPhone().isBlank()) {
            if (!u.getPhone().matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
                throw new IllegalArgumentException("Số điện thoại không hợp lệ. "
                        + "Vui lòng nhập số Việt Nam hợp lệ (10 số, bắt đầu bằng 03, 05, 07, 08 hoặc 09).");
            }

            if (dao.isPhoneExists(u.getPhone(), u.getUserId())) {
                throw new IllegalArgumentException("Số điện thoại đã được sử dụng bởi tài khoản khác.");
            }
        } 
        else {
            throw new IllegalArgumentException("Số điện thoại không được để trống.");
        }

        if (u.getDateOfBirth() != null) {
            LocalDate today = LocalDate.now();

            if (u.getDateOfBirth().isAfter(today)) {
                throw new IllegalArgumentException("Ngày sinh không hợp lệ. Không thể chọn ngày trong tương lai.");
            }

            int age = Period.between(u.getDateOfBirth(), today).getYears();
            if (age < 18) {
                throw new IllegalArgumentException("Phụ huynh phải ít nhất 18 tuổi.");
            }
            if (age > 120) {
                throw new IllegalArgumentException("Ngày sinh không hợp lệ. Tuổi không thể vượt quá 120.");
            }
        }

        dao.updateUser(u);
        dao.updateParentProfile(p);
    }
}
