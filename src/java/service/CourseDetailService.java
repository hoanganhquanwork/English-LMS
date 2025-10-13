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
            List<Map<String, Object>> items = dao.getModuleItems(courseId);
            for (Map<String, Object> item : items) {
                String itemType = (String) item.get("itemType");
                String contentType = (String) item.get("contentType");
                String url = (String) item.get("videoUrl");

                if ("lesson".equals(itemType) && "video".equals(contentType) && url != null) {
                    if (url.contains("watch?v=")) {
                        url = url.replace("watch?v=", "embed/");
                        item.put("videoUrl", url);
                    }
                }
            }

            Map<String, Object> stats = dao.getStatistics(courseId);
            data.put("modules", modules);
            data.put("items", items);
            data.put("stats", stats);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}