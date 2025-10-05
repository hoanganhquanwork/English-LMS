/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ParentProfileDAO;
import dal.StudentDAO;

/**
 *
 * @author Admin
 */
public class StudentRequestService {

    private ParentProfileDAO pdao = new ParentProfileDAO();
    private StudentDAO sdao = new StudentDAO();

    public boolean createLinkRequest(int studentId, String parentEmail) {
        Integer parentId = pdao.getParentIdByEmail(parentEmail);
        if (parentId == null) {
            throw new IllegalArgumentException("Email phụ huynh cần liên kết không hợp lệ");
        }
        return sdao.createLinkRequest(studentId, parentId);
    }

    public boolean unlinkParentAccount(int studenId) {
        Integer parentId = pdao.getParentIdByStudentId(studenId);
        return sdao.unlinkParentRequest(studenId, parentId);
    }
    
    public String getLatestStatus(int studenId){
        return sdao.getLatestStatus(studenId);
    }
    
    public String getLatestParentEmail(int studentId){
        return sdao.getLatestParentEmail(studentId);
    }
    
    public boolean cancelPendingRequest(int studenId){
        return sdao.cancelPendingRequest(studenId);
    }
}
