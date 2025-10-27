package controller.manager.course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import model.entity.Category;
import model.entity.Topic;
import service.CateAndTopicService;

@WebServlet(name = "CategoryAndTopicManagerController", urlPatterns = {"/cate-topic"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class CategoryAndTopicManagerController extends HttpServlet {

    private final CateAndTopicService service = new CateAndTopicService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String type = req.getParameter("type");
        if (type == null) {
            type = "category";
        }

        if (type.equals("topic")) {
            List<Topic> topics = service.getAllTopics();
            req.setAttribute("topics", topics);
        } else {
            List<Category> categories = service.getAllCategories();
            req.setAttribute("categories", categories);
        }

        req.setAttribute("type", type);
        req.getRequestDispatcher("/views-manager/category/category-topic-management.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String type = req.getParameter("type");
        if (!"topic".equalsIgnoreCase(type) && !"category".equalsIgnoreCase(type)) {
            type = "category";
        }

        String action = req.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = (req.getParameter("id") == null || req.getParameter("id").isEmpty())
                    ? "add" : "update";
        }

        String message = null;
        String error = null;

        if ("category".equals(type)) {
            Category c = new Category();
            String idRaw = req.getParameter("id");
            if (idRaw != null && !idRaw.isEmpty()) {
                c.setCategoryId(Integer.parseInt(idRaw));
            }
            c.setName(req.getParameter("name"));
            c.setDescription(req.getParameter("description"));

            Part filePart = req.getPart("pictureFile");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_"
                        + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("/uploads/categories");
                Files.createDirectories(Paths.get(uploadDir));
                Path filePath = Paths.get(uploadDir, fileName);
                filePart.write(filePath.toString());
                c.setPicture("uploads/categories/" + fileName);

            } else {
                String oldPic = req.getParameter("pictureOld");
                if (oldPic != null && !oldPic.isEmpty()) {
                    c.setPicture(oldPic);
                }
            }

            if ("add".equals(action)) {
                if (service.isCategoryDuplicate(c.getName())) {
                    error = "Tên danh mục đã tồn tại. Vui lòng chọn tên khác.";
                } else if (service.addCategory(c)) {
                    message = "Thêm danh mục thành công!";
                } else {
                    error = "Thêm danh mục thất bại.";
                }
            } else if ("update".equals(action)) {
                if (service.isCategoryDuplicateForUpdate(c.getName(), c.getCategoryId())) {
                    error = "Tên danh mục đã được sử dụng bởi danh mục khác.";
                } else if (service.updateCategory(c)) {
                    message = "Cập nhật danh mục thành công!";
                } else {
                    error = "Cập nhật danh mục thất bại.";
                }
            } else {
                error = "Hành động không hợp lệ.";
            }
        } else if ("topic".equals(type)) {
            Topic t = new Topic();
            String idRaw = req.getParameter("id");
            if (idRaw != null && !idRaw.isEmpty()) {
                t.setTopicId(Integer.parseInt(idRaw));
            }
            t.setName(req.getParameter("name"));
            t.setDescription(req.getParameter("description"));

            if (idRaw == null || idRaw.isEmpty()) {
                if (service.isTopicDuplicate(t.getName())) {
                    error = "Tên chủ đề đã tồn tại. Vui lòng chọn tên khác.";
                } else if (service.addTopic(t)) {
                    message = "Thêm chủ đề thành công!";
                } else {
                    error = "Thêm chủ đề thất bại.";
                }
            } else {
                if (service.isTopicDuplicateForUpdate(t.getName(), t.getTopicId())) {
                    error = "Tên chủ đề đã được sử dụng bởi chủ đề khác.";
                } else if (service.updateTopic(t)) {
                    message = "Cập nhật chủ đề thành công!";
                } else {
                    error = "Cập nhật chủ đề thất bại.";
                }
            }
        }

        if (message != null) {
            req.setAttribute("message", message);
        }
        if (error != null) {
            req.setAttribute("error", error);
        }

        if ("topic".equals(type)) {
            List<Topic> topics = service.getAllTopics();
            req.setAttribute("topics", topics);
        } else {
            List<Category> categories = service.getAllCategories();
            req.setAttribute("categories", categories);
        }
        req.setAttribute("type", type);
        req.getRequestDispatcher("/views-manager/category/category-topic-management.jsp")
        .forward(req, resp);
    }
}
