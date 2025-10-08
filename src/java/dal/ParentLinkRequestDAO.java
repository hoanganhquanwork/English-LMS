package dal;

import java.sql.*;
import java.util.*;
import model.entity.ParentLinkRequest;
import model.entity.Users;

public class ParentLinkRequestDAO extends DBContext {

    public List<ParentLinkRequest> getRequestsByParentId(int parentId) {
        List<ParentLinkRequest> list = new ArrayList<>();

        String sql = """
            SELECT pr.*, 
                   u.full_name AS student_name, 
                   u.email AS student_email, 
                   u.profile_picture AS student_avatar
            FROM ParentLinkRequests pr
            JOIN Users u ON pr.student_id = u.user_id
            WHERE pr.parent_id = ?
            ORDER BY pr.created_at DESC
        """;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, parentId);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                ParentLinkRequest r = new ParentLinkRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setStudentId(rs.getInt("student_id"));
                r.setParentId(rs.getInt("parent_id"));
                r.setNote(rs.getString("note"));
                r.setStatus(rs.getString("status"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setDecidedAt(rs.getTimestamp("decided_at"));

                // Gán thêm thông tin học sinh
                Users s = new Users();
                s.setUserId(rs.getInt("student_id"));
                s.setFullName(rs.getString("student_name"));
                s.setEmail(rs.getString("student_email"));
                s.setProfilePicture(rs.getString("student_avatar"));
                r.setStudent(s);

                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE ParentLinkRequests SET status = ?, decided_at = GETDATE() WHERE request_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, status);
            stm.setInt(2, requestId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ParentLinkRequest getRequestById(int requestId) {
        String sql = "SELECT * FROM ParentLinkRequests WHERE request_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, requestId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                ParentLinkRequest r = new ParentLinkRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setStudentId(rs.getInt("student_id"));
                r.setParentId(rs.getInt("parent_id"));
                r.setNote(rs.getString("note"));
                r.setStatus(rs.getString("status"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setDecidedAt(rs.getTimestamp("decided_at"));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
