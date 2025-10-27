/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.RubricCriterion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Lenovo
 */
public class RubricCriterionDAO extends DBContext{
     private final AssignmentDAO assignmentDAO = new AssignmentDAO();
     public boolean insertRubricCriterion(RubricCriterion rc) {
        String sql = "INSERT INTO RubricCriterion (assignment_id, criterion_no, weight, guidance) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, rc.getAssignment().getAssignmentId().getModuleItemId());
            st.setInt(2, rc.getCriterionNo());
            st.setDouble(3, rc.getWeight());
            st.setString(4, rc.getGuidance());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println(" Lỗi insert RubricCriterion:");
            e.printStackTrace();
        }
        return false;
    }

    public void insertRubricList(List<RubricCriterion> list) throws SQLException {
        String sql = "INSERT INTO RubricCriterion (assignment_id, criterion_no, weight, guidance) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (RubricCriterion rc : list) {
                st.setInt(1, rc.getAssignment().getAssignmentId().getModuleItemId());
                st.setInt(2, rc.getCriterionNo());
                st.setDouble(3, rc.getWeight());
                st.setString(4, rc.getGuidance());
                st.addBatch();
            }
            st.executeBatch();
        }
    }
    
    public List<RubricCriterion> getByAssignmentId(int assignmentId) {
        List<RubricCriterion> list = new ArrayList<>();
        String sql = "SELECT * FROM RubricCriterion WHERE assignment_id = ? ORDER BY criterion_no";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, assignmentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                RubricCriterion c = new RubricCriterion();
                c.setAssignment(assignmentDAO.getAssignmentById(assignmentId));
                c.setCriterionNo(rs.getInt("criterion_no"));
                c.setWeight(rs.getDouble("weight"));
                c.setGuidance(rs.getString("guidance"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteByAssignmentId(int assignmentId) throws SQLException {
        String sql = "DELETE FROM RubricCriterion WHERE assignment_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, assignmentId);
            st.executeUpdate();
        }
    }

    public void insertCriterion(int assignmentId, int criterionNo, double weight, String guidance) throws SQLException {
        String sql = "INSERT INTO RubricCriterion (assignment_id, criterion_no, weight, guidance) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, assignmentId);
            st.setInt(2, criterionNo);
            st.setDouble(3, weight);
            st.setString(4, guidance);
            st.executeUpdate();
        }
    }
}
