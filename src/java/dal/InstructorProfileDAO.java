package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.InstructorProfile;

public class InstructorProfileDAO extends DBContext {
    private UserDAO dao = new UserDAO();
    public InstructorProfile getByUserId(int userId) {
        String sql = "SELECT user_id, bio, expertise, qualifications "
                   + "FROM InstructorProfile WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InstructorProfile instructor = new InstructorProfile();
                    instructor.setUser(dao.getUserById(rs.getInt("user_id")));
                    instructor.setBio(rs.getString("bio"));
                    instructor.setExpertise(rs.getString("expertise"));
                    instructor.setQualifications(rs.getString("qualifications"));
                    return instructor;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; 
    }
    
    public static void main(String[] args) {
        InstructorProfileDAO dao = new  InstructorProfileDAO();
        System.out.println(dao.getByUserId(8));
    }
}
