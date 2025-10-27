/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.dto.RatingSummaryDTO;
import model.dto.ReviewDTO;


/**
 *
 * @author Admin
 */
public class ReviewDAO extends DBContext {

    CourseInformationDAO cdao = new CourseInformationDAO();

    public RatingSummaryDTO getRatingSummary(int courseId) {
        String sql = "SELECT CAST(AVG(CAST(rating AS DECIMAL(10,2))) AS DECIMAL(10,1)) AS avg_rating,"
                + " COUNT(*) AS total, "
                + " SUM(CASE WHEN rating=5 THEN 1 ELSE 0 END) AS s5, "
                + " SUM(CASE WHEN rating=4 THEN 1 ELSE 0 END) AS s4, "
                + " SUM(CASE WHEN rating=3 THEN 1 ELSE 0 END) AS s3, "
                + " SUM(CASE WHEN rating=2 THEN 1 ELSE 0 END) AS s2, "
                + " SUM(CASE WHEN rating=1 THEN 1 ELSE 0 END) AS s1 FROM Reviews WHERE course_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            RatingSummaryDTO summary = new RatingSummaryDTO();

            if (rs.next()) {
                BigDecimal avg = rs.getBigDecimal("avg_rating");
                summary.setAvgRating(avg == null ? 0.0 : avg.doubleValue());
                summary.setTotalRatings(rs.getInt("total"));
                summary.setFiveStarCount(rs.getInt("s5"));
                summary.setFourStarCount(rs.getInt("s4"));
                summary.setThreeStarCount(rs.getInt("s3"));
                summary.setTwoStarCount(rs.getInt("s2"));
                summary.setOneStarCount(rs.getInt("s1"));
            }
            return summary;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ReviewDTO> getListReviewByStar(int courseId, Integer star, String keyword, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT r.review_id, r.course_id, r.student_id, r.rating, r.comment,"
                + " r.created_at, r.edited_at, u.full_name AS student_name, u.profile_picture AS student_avatar "
                + " FROM Reviews r JOIN Users u ON u.user_id = r.student_id  WHERE r.course_id = ? ");

        if (star != null) {
            sql.append(" AND r.rating = ? ");
        }

        sql.append(" AND r.comment LIKE ? ");
        sql.append(" ORDER BY r.created_at DESC, r.review_id DESC ")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        String like = (keyword == null || keyword.isBlank()) ? "%%" : "%" + keyword.trim() + "%";
        int safePage = Math.max(1, page);
        int offset = (safePage - 1) * pageSize;
        List<ReviewDTO> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;
            st.setInt(index++, courseId);
            if (star != null) {
                st.setInt(index++, star);
            }
            st.setString(index++, like);
            st.setInt(index++, offset);
            st.setInt(index++, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ReviewDTO rv = new ReviewDTO();
                rv.setReviewId(rs.getInt("review_id"));
                rv.setCourseId(rs.getInt("course_id"));
                rv.setStudentId(rs.getInt("student_id"));
                rv.setRating(rs.getInt("rating"));
                rv.setComment(rs.getString("comment"));
                rv.setCreatedAt(rs.getTimestamp("created_at"));
                rv.setEditedAt(rs.getTimestamp("edited_at"));
                rv.setStudentName(rs.getString("student_name"));
                rv.setStudentAvatar(rs.getString("student_avatar"));
                list.add(rv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countByStars(int courseId, Integer stars, String keyword) {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM Reviews r WHERE r.course_id = ? ");

        if (stars != null) {
            sb.append(" AND r.rating = ? ");
        }
        sb.append(" AND r.comment LIKE ? ");

        String like = (keyword == null || keyword.isBlank()) ? "%%" : "%" + keyword.trim() + "%";

        String sql = sb.toString();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int index = 1;
            st.setInt(index++, courseId);
            if (stars != null) {
                st.setInt(index++, stars);
            }
            st.setString(index++, like);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ReviewDTO> getAllReviews(int courseId) {
        String sql = "SELECT r.review_id, r.course_id, r.student_id, r.rating, r.comment, "
                + " r.created_at, r.edited_at, u.full_name AS student_name, u.profile_picture AS student_avatar "
                + " FROM Reviews r JOIN Users u ON u.user_id = r.student_id "
                + " WHERE r.course_id = ? "
                + " ORDER BY r.created_at DESC, r.review_id DESC";

        List<ReviewDTO> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ReviewDTO rv = new ReviewDTO();
                rv.setReviewId(rs.getInt("review_id"));
                rv.setCourseId(rs.getInt("course_id"));
                rv.setStudentId(rs.getInt("student_id"));
                rv.setRating(rs.getInt("rating"));
                rv.setComment(rs.getString("comment"));
                rv.setCreatedAt(rs.getTimestamp("created_at"));
                rv.setEditedAt(rs.getTimestamp("edited_at"));
                rv.setStudentName(rs.getString("student_name"));
                rv.setStudentAvatar(rs.getString("student_avatar"));
                list.add(rv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ReviewDTO getReviewByCourseAndStudent(int courseId, int studentId) {
        String sql = "SELECT r.review_id, r.course_id, r.student_id, r.rating, r.comment, r.created_at, r.edited_at, "
                + " u.full_name AS student_name, u.profile_picture AS student_avatar "
                + " FROM Reviews r JOIN Users u ON u.user_id = r.student_id "
                + " WHERE r.course_id = ? AND r.student_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                ReviewDTO rv = new ReviewDTO();
                rv.setReviewId(rs.getInt("review_id"));
                rv.setCourseId(rs.getInt("course_id"));
                rv.setStudentId(rs.getInt("student_id"));
                rv.setRating(rs.getInt("rating"));
                rv.setComment(rs.getString("comment"));
                rv.setCreatedAt(rs.getTimestamp("created_at"));
                rv.setEditedAt(rs.getTimestamp("edited_at"));
                rv.setStudentName(rs.getString("student_name"));
                rv.setStudentAvatar(rs.getString("student_avatar"));
                return rv;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean existsReview(int courseId, int studentId) {
        String sql = "SELECT 1 FROM Reviews WHERE course_id = ? AND student_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertReview(int courseId, int studentId, int rating, String comment) {
        String sql = "INSERT INTO Reviews (course_id, student_id, rating, comment) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            st.setInt(2, studentId);
            st.setInt(3, rating);
            st.setString(4, comment);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateReview(int courseId, int studentId, int rating, String comment) {
        String sql = "UPDATE Reviews SET rating = ?, comment = ?, edited_at = GETDATE() "
                + "WHERE course_id = ? AND student_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, rating);
            st.setString(2, comment);
            st.setInt(3, courseId);
            st.setInt(4, studentId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}