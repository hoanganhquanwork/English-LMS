/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.ModuleItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.Module;

/**
 *
 * @author Lenovo
 */
public class ModuleItemDAO extends DBContext {

    private ModuleDAO moduleDAO = new ModuleDAO();

    public int insertModuleItem(ModuleItem item) throws SQLException {
        String sql = "INSERT INTO ModuleItem (module_id, item_type, order_index, is_required) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, item.getModule().getModuleId());
            ps.setString(2, item.getItemType());
            ps.setInt(3, item.getOrderIndex());
            ps.setBoolean(4, item.isRequired());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public int getNextOrderIndex(int moduleId) throws SQLException {
        String sql = "SELECT ISNULL(MAX(order_index), 0) + 1 FROM ModuleItem WHERE module_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

   public ModuleItem getModuleItemById(int moduleItemId) {
        ModuleItem item = null;

        String sql = """
            SELECT *
            FROM ModuleItem
            WHERE module_item_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleItemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                item = new ModuleItem();
                item.setModuleItemId(rs.getInt("module_item_id"));
                item.setItemType(rs.getString("item_type"));
                item.setOrderIndex(rs.getInt("order_index"));
                item.setRequired(rs.getBoolean("is_required"));

               
                int moduleId = rs.getInt("module_id");
                Module module = moduleDAO.getModuleById(moduleId);
                item.setModule(module);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy ModuleItem theo ID: " + e.getMessage());
        }

        return item;
    }

    public List<ModuleItem> getItemsByModule(int moduleId) {
        List<ModuleItem> list = new ArrayList<>();
        String sql = "SELECT * FROM ModuleItem WHERE module_id = ? ORDER BY order_index ASC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ModuleItem item = new ModuleItem();
                item.setModuleItemId(rs.getInt("module_item_id"));
                item.setModule(moduleDAO.getModuleById(rs.getInt("module_id")));
                item.setItemType(rs.getString("item_type"));
                item.setOrderIndex(rs.getInt("order_index"));
                item.setRequired(rs.getBoolean("is_required"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean deleteModuleItem(int moduleItemId) {
        String sql = "DELETE FROM ModuleItem WHERE module_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleItemId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean updateRequiredById(int moduleItemId, boolean required) {
    String sql = "UPDATE ModuleItem SET required = ? WHERE module_item_id = ?";
    try (
         PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setBoolean(1, required);
        ps.setInt(2, moduleItemId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}
