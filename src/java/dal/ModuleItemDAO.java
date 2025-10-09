/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.ModuleItem;
import java.sql.*;

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
}
