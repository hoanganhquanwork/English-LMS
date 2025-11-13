package service;

import dal.ParentProgressDAO;
import java.util.*;
import model.dto.CourseProgressDTO;
import model.entity.Course;
import model.entity.Users;

public class ParentProgressService {

    private ParentProgressDAO dao = new ParentProgressDAO();

    public List<Users> getChildrenByParent(int parentId) {
        return dao.getChildrenByParent(parentId);
    }

    public List<CourseProgressDTO> getCourseProgressByStudent(int studentId) {
        List<CourseProgressDTO> list = new ArrayList<>();
        try {
            List<Course> course = dao.getCourseProgress(studentId);
            for (Course c : course) {
                CourseProgressDTO cp = new CourseProgressDTO();
                String title = c.getTitle();
                int courseId = c.getCourseId();
                cp.setCourseId(courseId);
                cp.setCourseTitle(title);

                // --- Gọi các hàm con để tính tiến độ ---
                int total = dao.countModuleItems(courseId);
                int completed = dao.countCompletedItems(studentId, courseId);
                int required = dao.countRequiredItems(courseId);
                int requiredCompleted = dao.countRequiredCompleted(studentId, courseId);

                cp.setTotalItems(total);
                cp.setCompletedItems(completed);
                cp.setRequiredItems(required);
                cp.setRequiredCompleted(requiredCompleted);

                // Tính phần trăm tiến độ
                double percent = 0;
                if (required > 0) {
                    percent = (requiredCompleted * 100.0) / required;
                }
                cp.setProgressPctRequired(percent);

                // Tính điểm trung bình
                Double avgScore = dao.calculateAverageScore(studentId, courseId);
                cp.setAvgScorePct(avgScore);

                list.add(cp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getOverview(int studentId) {
        Map<String, Object> data = new HashMap<>();
        List<CourseProgressDTO> list = getCourseProgressByStudent(studentId);
        int activeCourses = 0;
        int completedCourses = 0;
        double totalPct = 0;
        for (CourseProgressDTO c : list) {
            if (c.getProgressPctRequired() >= 100) {
                completedCourses++;
            } else {
                activeCourses++;
            }
            totalPct += c.getProgressPctRequired();
        }
        double avgProgress = list.isEmpty() ? 0 : totalPct / list.size();

        data.put("activeCourses", activeCourses);
        data.put("completedCourses", completedCourses);
        data.put("avgProgress", Math.round(avgProgress * 10.0) / 10.0);
        return data;
    }

}
