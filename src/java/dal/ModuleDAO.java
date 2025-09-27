/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Module;

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
        String sql = "INSERT INTO Modules (course_id, title, description, order_index, created_by) "
                + "SELECT ?, ?, ?, ISNULL(MAX(order_index), 0) + 1, ? "
                + "FROM Modules WHERE course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, module.getCourse().getCourseId());
            st.setString(2, module.getTitle());
            st.setString(3, module.getDescription());
            st.setInt(4, 3);
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
}
