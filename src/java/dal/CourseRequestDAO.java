/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.entity.CourseRequest;
import model.entity.Course;
import model.entity.ParentProfile;
import model.entity.StudentProfile;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import model.entity.Users;

/**
 *
 * @author Admin
 */
public class CourseRequestDAO extends DBContext {

    private CourseDAO cdao = new CourseDAO();
    private StudentDAO sdao = new StudentDAO();
    private ParentProfileDAO pdao = new ParentProfileDAO();

    public List<CourseRequest> searchCourseRequest(
            int studentId, String status, String sort, String keyword, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT cr.request_id, cr.student_id, "
                + " cr.course_id, cr.parent_id, cr.status, "
                + " cr.note, cr.created_at, cr.decided_at, "
                + " c.title AS course_title "
                + "FROM CourseRequests cr JOIN Course c ON c.course_id = cr.course_id "
                + " WHERE 1=1");

        if (page < 1) {
            page = 1;
        }
        if (pageSize < 1) {
            pageSize = 10;
        }
        List<Object> parameters = new ArrayList<>();

        sql.append(" AND cr.student_id = ? ");
        parameters.add(studentId);

        if (status != null && !status.isBlank()) {
            sql.append(" AND cr.status = ? ");
            parameters.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND c.title like ? ");
            parameters.add("%" + keyword + "%");
        }

        if ("asc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY c.title ASC, cr.request_id DESC ");
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY c.title DESC, cr.request_id DESC ");
        } else if ("decided".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY cr.decided_at DESC, cr.request_id DESC ");
        } else {
            sql.append(" ORDER BY cr.created_at DESC, cr.request_id DESC ");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        List<CourseRequest> courseList = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < parameters.size(); i++) {
                Object o = parameters.get(i);
                if (o == null) {
                    st.setObject(i + 1, null);
                } else if (o instanceof Integer) {
                    st.setInt(i + 1, (Integer) o);
                } else if (o instanceof String) {
                    st.setString(i + 1, (String) o);
                }
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseRequest cr = new CourseRequest();
                cr.setRequestId(rs.getInt("request_id"));

                StudentProfile s = sdao.findStudentById(rs.getInt("student_id"));
                cr.setStudent(s);

                Course c = cdao.getCourseById(rs.getInt("course_id"));
                cr.setCourse(c);

                int parentId = rs.getInt("parent_id");
                if (rs.wasNull()) {
                    cr.setParent(null);
                } else {
                    ParentProfile p = pdao.getParentProfileById(parentId);
                    cr.setParent(p);
                }

                cr.setStatus(rs.getString("status"));
                cr.setNote(rs.getString("note"));

                Timestamp ct = rs.getTimestamp("created_at");
                Timestamp dt = rs.getTimestamp("decided_at");
                cr.setCreatedAt(ct == null ? null : ct.toLocalDateTime());
                cr.setDecidedAt(dt == null ? null : dt.toLocalDateTime());

                courseList.add(cr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courseList;
    }

    public int countCourseRequest(
            int studentId, String status, String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM CourseRequests cr JOIN Course c ON c.course_id = cr.course_id "
                + "WHERE 1=1"
        );

        List<Object> parameter = new ArrayList<>();
        sql.append(" AND cr.student_id = ? ");
        parameter.add(studentId);
        if (status != null && !status.isBlank()) {
            sql.append(" AND cr.status = ? ");
            parameter.add(status);
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND c.title LIKE ? ");
            parameter.add("%" + keyword.trim() + "%");
        }
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < parameter.size(); i++) {
                st.setObject(i + 1, parameter.get(i));
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

//    From student
    public boolean resendCourseRequest(int requestId, int studentId) {
        String sql = "UPDATE CourseRequests SET status='pending',"
                + " decided_at = NULL, note = ?  "
                + "WHERE request_id=? AND student_id=? AND status IN ('saved','rejected','canceled')";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String defaultMessage = "Yêu cầu đang đợi phụ huynh duyệt";
            st.setString(1, defaultMessage);
            st.setInt(2, requestId);
            st.setInt(3, studentId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelPendingRequest(int requestId, int studentId, String note) {
        String sql = "UPDATE CourseRequests  SET status='canceled', decided_at=GETDATE(),"
                + "  note = NULLIF(?, N'')  WHERE request_id=? AND student_id=? AND status = 'pending'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            if (note == null) {
                st.setNull(1, java.sql.Types.VARCHAR);
            } else {
                st.setString(1, note);
            }
            st.setInt(2, requestId);
            st.setInt(3, studentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelAllPendingByStudent(int studentId, String note) {
        String sql = "UPDATE CourseRequests SET status='canceled',"
                + " decided_at=GETDATE(), note = ? WHERE student_id = ? AND status = 'pending'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, note);
            st.setInt(2, studentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CourseRequest> getRequestsByParentAndStatus(int parentId, String status) {
        List<CourseRequest> list = new ArrayList<>();
        String sql = """
        SELECT 
            r.request_id, r.student_id, r.course_id, r.status, 
            r.note, r.created_at, r.decided_at,
            c.title AS course_title, c.price AS course_price,
            u.full_name AS student_name, u.profile_picture, u.email, u.phone,
            s.grade_level, s.institution, s.address
        FROM CourseRequests r
        JOIN Course c ON r.course_id = c.course_id
        JOIN StudentProfile s ON r.student_id = s.user_id
        JOIN Users u ON s.user_id = u.user_id
        WHERE r.parent_id = ? AND r.status = ?
        ORDER BY r.created_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setString(2, status);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CourseRequest req = new CourseRequest();
                req.setRequestId(rs.getInt("request_id"));
                req.setStatus(rs.getString("status"));
                req.setNote(rs.getString("note"));
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

                req.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                req.setFormattedCreatedAt(req.getCreatedAt().format(formatter));

                Timestamp decided = rs.getTimestamp("decided_at");
                if (decided != null) {
                    LocalDateTime decidedAt = decided.toLocalDateTime();
                    req.setDecidedAt(decidedAt);
                    req.setFormattedDecidedAt(decidedAt.format(formatter));
                }

                if (decided != null) {
                    req.setDecidedAt(decided.toLocalDateTime());
                }

                // --- Map Course ---
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setTitle(rs.getString("course_title"));
                c.setPrice(rs.getBigDecimal("course_price"));
                req.setCourse(c);

                // --- Map Student + User ---
                Users u = new Users();
                u.setUserId(rs.getInt("student_id"));
                u.setFullName(rs.getString("student_name"));
                u.setProfilePicture(rs.getString("profile_picture"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));

                StudentProfile s = new StudentProfile();
                s.setUserId(rs.getInt("student_id"));
                s.setGradeLevel(rs.getString("grade_level"));
                s.setInstitution(rs.getString("institution"));
                s.setAddress(rs.getString("address"));
                s.setUser(u);

                req.setStudent(s);
                list.add(req);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateStatus(int requestId, String status) {
        String sql = "UPDATE CourseRequests SET status=?, decided_at=GETDATE() WHERE request_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Integer> countByStatus(int parentId) {
        Map<String, Integer> map = new HashMap<>();
        String sql = """
            SELECT status, COUNT(*) AS total
            FROM CourseRequests
            WHERE parent_id=?
            GROUP BY status
        """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
    
    public void updateNoteForRequest(int requestId, String note) {
    String sql = """
        UPDATE CourseRequests
        SET note = ?, decided_at = GETDATE()
        WHERE request_id = ?
    """;
    try{
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, note);
        ps.setInt(2, requestId);

        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

}
