package service;

import dal.ParentProgressDAO;
import java.util.*;
import model.dto.CourseProgressDTO;
import model.entity.Users;

public class ParentProgressService {
    
    private ParentProgressDAO dao = new ParentProgressDAO();
    
    // Lấy danh sách con theo phụ huynh
    public List<Users> getChildrenByParent(int parentId) {
        return dao.getChildrenByParent(parentId);
    }
    
    // Lấy danh sách tiến độ theo học sinh
    public List<CourseProgressDTO> getCourseProgressByStudent(int studentId) {
        return dao.getCourseProgress(studentId);
    }

    // Tính tổng quan cho dashboard
    public Map<String, Object> getOverview(int studentId) {
        Map<String, Object> data = new HashMap<>();
        List<CourseProgressDTO> list = dao.getCourseProgress(studentId);

        int activeCourses = 0;
        int completedCourses = 0;
        double totalPct = 0;
        for (CourseProgressDTO c : list) {
            if (c.getProgressPctRequired() >= 100) completedCourses++;
            else activeCourses++;
            totalPct += c.getProgressPctRequired();
        }
        double avgProgress = list.isEmpty() ? 0 : totalPct / list.size();

        data.put("activeCourses", activeCourses);
        data.put("completedCourses", completedCourses);
        data.put("avgProgress", Math.round(avgProgress * 10.0) / 10.0);
        return data;
    }
}
