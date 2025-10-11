/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.ModuleItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Lenovo
 */
public class ModuleItemDAO extends DBContext{
    public int insertModuleItem(ModuleItem item) throws SQLException {
        String sql = "INSERT INTO ModuleItem (module_id, item_type, order_index, is_required) " +
                     "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, item.getModuleId());
            ps.setString(2, item.getItemType());
            ps.setInt(3, item.getOrderIndex());
            ps.setBoolean(4, item.isRequired());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // trả về module_item_id vừa insert
            }
        }
        return -1;
    }
    public int getNextOrderIndex(int moduleId) throws SQLException {
    String sql = "SELECT ISNULL(MAX(order_index), 0) + 1 FROM ModuleItem WHERE module_id = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, moduleId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) return rs.getInt(1);
    }
    return 1;
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
                item.setModuleId(rs.getInt("module_id"));
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
}
