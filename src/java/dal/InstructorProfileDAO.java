package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.entity.InstructorProfile;

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
    
    public int updateInstructorProfile(InstructorProfile profile) {
        String sql = "UPDATE InstructorProfile "
                   + "SET bio = ?, expertise = ?, qualifications = ? "
                   + "WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, profile.getBio());
            st.setString(2, profile.getExpertise());
            st.setString(3, profile.getQualifications());
            st.setInt(4, profile.getUser().getUserId());
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean insertInstructorProfile(InstructorProfile profile) {
        String sql = "INSERT INTO InstructorProfile (user_id, bio, expertise, qualifications) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, profile.getUser().getUserId());
            ps.setString(2, profile.getBio());
            ps.setString(3, profile.getExpertise());
            ps.setString(4, profile.getQualifications());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static void main(String[] args) {
        InstructorProfileDAO dao = new  InstructorProfileDAO();
        System.out.println(dao.getByUserId(8));
    }
}
