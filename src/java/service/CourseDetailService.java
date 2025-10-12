package service;

import dal.CourseDetailDAO;
import java.util.*;

public class CourseDetailService {

    private final CourseDetailDAO dao = new CourseDetailDAO();

    public boolean isCourseValid(int courseId) {
        return dao.isCourseValid(courseId);
    }

    public Map<String, Object> getFullDetail(int courseId) {
        Map<String, Object> data = new HashMap<>();

        try {
            List<Map<String, Object>> modules = dao.getModules(courseId);
            if (modules == null) {
                modules = new ArrayList<>();
            }

            List<Map<String, Object>> items = dao.getModuleItems(courseId);
            if (items == null) {
                items = new ArrayList<>();
            }

            for (Map<String, Object> item : items) {
                String type = (String) item.get("itemType");
                String contentType = (String) item.get("contentType");
                String videoUrl = (String) item.get("videoUrl");

                if ("lesson".equalsIgnoreCase(type)
                        && "video".equalsIgnoreCase(contentType)
                        && videoUrl != null
                        && videoUrl.contains("watch?v=")) {
                    item.put("videoUrl", videoUrl.replace("watch?v=", "embed/"));
                }
            }

            Map<String, Object> stats = dao.getStatistics(courseId);
            if (stats == null) {
                stats = new HashMap<>();
            }

            Map<String, Object> instructor = dao.getInstructorInfo(courseId);
            if (instructor == null) {
                instructor = new HashMap<>();
            }
            data.put("modules", modules);
            data.put("items", items);
            data.put("stats", stats);
            data.put("instructor", instructor);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return data;
    }
}