/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseRequestDAO;
import dal.ParentProfileDAO;
import dal.StudentDAO;
import model.entity.CourseRequest;

/**
 *
 * @author Admin
 */
public class StudentRequestService {

    private ParentProfileDAO pdao = new ParentProfileDAO();
    private StudentDAO sdao = new StudentDAO();
    private CourseRequestDAO cdao = new CourseRequestDAO();

    //For link request
    public boolean createLinkRequest(int studentId, String parentEmail) {
        if (parentEmail == null || parentEmail.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập email phụ huynh.");
        }
        Integer currentPid = pdao.getParentIdByStudentId(studentId);
        if (currentPid != null) {
            throw new IllegalStateException("Tài khoản đã liên kết, vui lòng hủy liên kết trước");
        }

        Integer parentId = pdao.getParentIdByEmail(parentEmail);
        if (parentId == null) {
            throw new IllegalArgumentException("Email phụ huynh cần liên kết không hợp lệ");
        }
        boolean ok = sdao.createLinkRequest(studentId, parentId);
        if (!ok) {
            throw new IllegalStateException("Không thể tạo email");
        }
        return true;

    }

    public boolean unlinkParentAccount(int studenId) {
        Integer parentId = pdao.getParentIdByStudentId(studenId);
        if (parentId == null) {
            throw new IllegalStateException("Bạn chưa liên kết tài khoản phụ huynh");
        }
        boolean ok = sdao.unlinkParentRequest(studenId, parentId);
        if (!ok) {
            throw new IllegalStateException("Hủy liên kết phụ huynh không thành công");
        }
        ok = cdao.cancelAllPendingByStudent(studenId, "Yêu cầu bị hủy do học sinh hủy liên kết");
        if (!ok) {
            throw new IllegalStateException("Thay đổi note pending request thất bại");
        }
        return true;
    }

    public String getLatestStatus(int studenId) {
        return sdao.getLatestStatus(studenId);
    }

    public String getLatestParentEmail(int studentId) {
        return sdao.getLatestParentEmail(studentId);
    }

    public boolean cancelPendingRequest(int studenId) {
        boolean ok = sdao.cancelPendingRequest(studenId);
        if (!ok) {
            throw new IllegalStateException("Không thể hủy bỏ yêu cầu hiện tại");
        }
        return true;
    }

    //For enroll requsét
}
