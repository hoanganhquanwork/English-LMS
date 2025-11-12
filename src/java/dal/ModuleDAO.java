/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import java.util.ArrayList;
import java.util.List;
import model.dto.ModuleItemViewDTO;
import model.dto.ModuleWithItemsDTO;
import model.entity.Course;
import model.entity.Module;

/**
 *
 * @author Lenovo
 */
public class ModuleDAO extends DBContext {

    private CourseDAO course = new CourseDAO();

    public List<Module> getModulesByCourse(int courseId) {
        List<Module> list = new ArrayList<>();
        String sql = "SELECT * FROM Module WHERE course_id = ? ORDER BY order_index ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Module m = new Module();
                m.setModuleId(rs.getInt("module_id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setOrderIndex(rs.getInt("order_index"));
                m.setCourse(course.getCourseById(courseId));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Module getModuleById(int moduleId) {
        Module module = null;
        String sql = "SELECT * FROM Module WHERE module_id =  ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {             
                module = new Module();
                module.setModuleId(rs.getInt("module_id"));
                module.setTitle(rs.getString("title"));
                module.setDescription(rs.getString("description"));
                module.setOrderIndex(rs.getInt("order_index"));
                module.setCourse(course.getCourseById(rs.getInt("course_id")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return module;
    }

    public boolean insertModule(Module module) {
        String sql = "INSERT INTO Module (course_id, title, description, order_index) "
                + "SELECT ?, ?, ?, ISNULL(MAX(order_index), 0) + 1 "
                + "FROM Module WHERE course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, module.getCourse().getCourseId());
            st.setString(2, module.getTitle());
            st.setString(3, module.getDescription());
            st.setInt(4, module.getCourse().getCourseId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateModule(Module module) {
        String sql = "UPDATE Module SET title=?, description=? WHERE module_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, module.getTitle());
            st.setString(2, module.getDescription());
            st.setInt(3, module.getModuleId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteModule(int moduleId) {
        String sql = "DELETE FROM Module WHERE module_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countQuestionsByModule(int moduleId) {
        String sql = "SELECT COUNT(*) FROM ModuleQuestions WHERE module_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //for student feature list module item
    public List<ModuleWithItemsDTO> listModuleWithItems(int courseId, int studentId) {
        List<ModuleWithItemsDTO> result = new ArrayList<>();
        String sql = "SELECT m.module_id, m.course_id, m.title AS module_title, m.description, m.order_index, "
                + "                   mi.module_item_id, mi.item_type, mi.order_index AS item_order, "
                + "                   COALESCE(l.title, q.title, a.title, d.title) AS item_title, "
                + "                   l.content_type, l.duration_sec, "
                + "                   pr.status AS progress_status "
                + "            FROM Module m "
                + "            LEFT JOIN ModuleItem mi ON mi.module_id = m.module_id "
                + "            LEFT JOIN Lesson l      ON l.lesson_id = mi.module_item_id "
                + "            LEFT JOIN Quiz q        ON q.quiz_id = mi.module_item_id "
                + "            LEFT JOIN Assignment a  ON a.assignment_id = mi.module_item_id "
                + "            LEFT JOIN Discussion d  ON d.discussion_id = mi.module_item_id "
                + "            LEFT JOIN Progress pr   ON (pr.student_id = ? AND pr.module_item_id = mi.module_item_id) "
                + "            WHERE m.course_id = ? "
                + "            ORDER BY m.order_index ASC, mi.order_index ASC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            st.setInt(2, courseId);

            ResultSet rs = st.executeQuery();
            ModuleWithItemsDTO currentModule = null;
            Integer currentModuleId = null;
            while (rs.next()) {
                int moduleId = rs.getInt("module_id");
                if (currentModule == null || moduleId != currentModuleId) {
                    currentModuleId = moduleId;
                    currentModule = new ModuleWithItemsDTO();
                    currentModule.setModuleId(moduleId);
                    currentModule.setCourseId(rs.getInt("course_id"));
                    currentModule.setTitle(rs.getString("module_title"));
                    currentModule.setDescription(rs.getString("description"));
                    currentModule.setOrderIndex(rs.getInt("order_index"));
                    currentModule.setItems(new ArrayList<>());
                    result.add(currentModule);
                }

                int itemId = rs.getInt("module_item_id");
                if (!rs.wasNull()) {
                    ModuleItemViewDTO item = new ModuleItemViewDTO();
                    item.setModuleItemId(itemId);
                    item.setModuleId(moduleId);
                    item.setItemType(rs.getString("item_type"));
                    item.setOrderIndex(rs.getInt("item_order"));
                    item.setTitle(rs.getString("item_title"));
                    item.setContentType(rs.getString("content_type"));
                    int duration = rs.getInt("duration_sec");
                    if (rs.wasNull()) {
                        item.setDurationSec(null);
                    } else {
                        item.setDurationSec(duration);
                    }
                    item.setStatus(rs.getString("progress_status"));
                    currentModule.getItems().add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    //Quan
    public List<ModuleWithItemsDTO> getModulesWithItemsByCourseId(int studentId, int courseId) {
        List<ModuleWithItemsDTO> modules = new ArrayList<>();

        String sql = """
            SELECT m.module_id, m.title AS module_title, m.order_index,
                   mi.item_type, mi.is_required, l.title AS lesson_title, 
                   q.title AS quiz_title, a.title AS assign_title, d.title AS discuss_title,
                   p.status, p.score_pct
            FROM Module m
            JOIN ModuleItem mi ON m.module_id = mi.module_id
            LEFT JOIN Lesson l ON mi.module_item_id = l.lesson_id
            LEFT JOIN Quiz q ON mi.module_item_id = q.quiz_id
            LEFT JOIN Assignment a ON mi.module_item_id = a.assignment_id
            LEFT JOIN Discussion d ON mi.module_item_id = d.discussion_id
            LEFT JOIN Progress p ON p.module_item_id = mi.module_item_id AND p.student_id = ?
            WHERE m.course_id = ?
            ORDER BY m.order_index, mi.order_index
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();

            Map<Integer, ModuleWithItemsDTO> moduleMap = new LinkedHashMap<>();

            while (rs.next()) {
                int moduleId = rs.getInt("module_id");
                ModuleWithItemsDTO module = moduleMap.get(moduleId);

                if (module == null) {
                    module = new ModuleWithItemsDTO();
                    module.setModuleId(moduleId);
                    module.setTitle(rs.getString("module_title"));
                    module.setOrderIndex(rs.getInt("order_index"));
                    module.setItems(new ArrayList<>());
                    moduleMap.put(moduleId, module);
                }

                ModuleItemViewDTO item = new ModuleItemViewDTO();
                item.setItemType(rs.getString("item_type"));
                item.setRequired(rs.getBoolean("is_required"));

                String title = rs.getString("lesson_title");
                if (title == null) title = rs.getString("quiz_title");
                if (title == null) title = rs.getString("assign_title");
                if (title == null) title = rs.getString("discuss_title");
                item.setTitle(title);

                item.setStatus(rs.getString("status"));
                item.setScore_pct(rs.getObject("score_pct") != null ? rs.getDouble("score_pct") : null);

                module.getItems().add(item);
            }

            modules.addAll(moduleMap.values());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return modules;
    }    
}
