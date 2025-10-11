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
        String sql = "SELECT * FROM Modules WHERE course_id = ? ORDER BY order_index ASC";
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

    public boolean insertModule(Module module) {
        String sql = "INSERT INTO Modules (course_id, title, description, order_index) "
                + "SELECT ?, ?, ?, ISNULL(MAX(order_index), 0) + 1, ? "
                + "FROM Modules WHERE course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, module.getCourse().getCourseId());
            st.setString(2, module.getTitle());
            st.setString(3, module.getDescription());
            st.setInt(5, module.getCourse().getCourseId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateModule(Module module) {
        String sql = "UPDATE Modules SET title=?, description=? WHERE module_id=?";
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
        String sql = "DELETE FROM Modules WHERE module_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        ModuleDAO dao = new ModuleDAO();

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
}
