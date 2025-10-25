/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.math.BigDecimal;
import java.util.List;
import model.dto.InstructorInformationDTO;
import model.dto.ModuleItemInformationDTO;
import model.entity.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import model.dto.CourseInformationDTO;
import model.dto.ModuleInformationDTO;
import model.dto.ReviewDTO;

/**
 *
 * @author Admin
 */
public class CourseInformationDAO extends DBContext {

    public CourseInformationDTO getFullCourseInformation(int courseId) {
        CourseInformationDTO base = getCourseBase(courseId);
        if (base == null) {
            return null;
        }

        if (base.getInstructor() != null && base.getInstructor().getUserId() > 0) {
            base.setInstructor(getInstructorById(base.getInstructor().getUserId()));
        }

        base.setRating(getRatingAvg(courseId));
        base.setRatingsCount(getRatingsCount(courseId));
        base.setStudentCount(getStudentCount(courseId));

        List<ModuleInformationDTO> modules = getModulesFullByCourseId(courseId);
        base.setModuleDetails(modules);
        base.setModuleCount(modules.size());
        return base;
    }

    public Double getRatingAvg(int courseId) {
        String sql = "SELECT CAST(AVG(CAST(r.rating AS DECIMAL(10,2))) AS DECIMAL(10,1)) AS rating_avg "
                + "FROM Reviews r WHERE r.course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                BigDecimal avg = rs.getBigDecimal("rating_avg");
                return (avg == null) ? null : avg.doubleValue();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer getRatingsCount(int courseId) {
        String sql = "SELECT COUNT(*) AS rating_count FROM Reviews WHERE course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return (Integer) rs.getObject("rating_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Integer getStudentCount(int courseId) {
        String sql = "SELECT COUNT(*) AS student_count "
                + "FROM Enrollments WHERE course_id = ? AND status IN ('active','completed')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return (Integer) rs.getObject("student_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private CourseInformationDTO getCourseBase(int courseId) {
        String sql = "SELECT c.course_id, c.title, c.description, c.language, c.level, "
                + "       c.thumbnail, c.price, cat.name AS category_name, c.category_id, c.created_by "
                + "FROM Course c JOIN Categories cat ON cat.category_id = c.category_id "
                + "WHERE c.course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                CourseInformationDTO ci = new CourseInformationDTO();
                ci.setCourseId(rs.getInt("course_id"));
                ci.setTitle(rs.getString("title"));
                ci.setDescription(rs.getString("description"));
                ci.setLanguage(rs.getString("language"));
                ci.setLevel(rs.getString("level"));
                ci.setCategoryName(rs.getString("category_name"));
                ci.setThumbnail(rs.getString("thumbnail"));
                ci.setPrice(rs.getBigDecimal("price"));
                ci.setCategoryId(rs.getInt("category_id"));
                InstructorInformationDTO ins = new InstructorInformationDTO();
                ins.setUserId(rs.getInt("created_by")); // chỉ set id, lát lấy full
                ci.setInstructor(ins);
                return ci;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public InstructorInformationDTO getInstructorById(int userId) {
        String sql = "SELECT ip.user_id, u.full_name, u.profile_picture "
                + "FROM InstructorProfile ip JOIN Users u ON u.user_id = ip.user_id "
                + "WHERE ip.user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                InstructorInformationDTO ins = new InstructorInformationDTO();
                ins.setUserId(rs.getInt("user_id"));
                ins.setFullName(rs.getString("full_name"));
                ins.setAvatarUrl(rs.getString("profile_picture"));
                return ins;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ModuleInformationDTO> getModulesFullByCourseId(int courseId) {
        List<ModuleInformationDTO> modules = getModuleInformation(courseId);
        for (ModuleInformationDTO m : modules) {
            List<ModuleItemInformationDTO> items = getModuleItemInformation(m.getId());

            List<ModuleItemInformationDTO> videos = new ArrayList<>();
            List<ModuleItemInformationDTO> readings = new ArrayList<>();
            List<ModuleItemInformationDTO> assignments = new ArrayList<>();
            List<ModuleItemInformationDTO> quizzes = new ArrayList<>();
            List<ModuleItemInformationDTO> discussions = new ArrayList<>();

            for (ModuleItemInformationDTO it : items) {
                String type = it.getItemType();
                if ("lesson".equalsIgnoreCase(type)) {
                    if ("video".equalsIgnoreCase(it.getContentType())) {
                        videos.add(it);
                    } else if ("reading".equalsIgnoreCase(it.getContentType())) {
                        readings.add(it);
                    }
                } else if ("assignment".equalsIgnoreCase(type)) {
                    assignments.add(it);
                } else if ("quiz".equalsIgnoreCase(type)) {
                    quizzes.add(it);
                } else if ("discussion".equalsIgnoreCase(type)) {
                    discussions.add(it);
                }
            }

            m.setVideos(videos);
            m.setReadings(readings);
            m.setAssignments(assignments);
            m.setQuizzes(quizzes);
            m.setDiscussions(discussions);

            m.setVideoCount(videos.size());
            m.setReadingCount(readings.size());
            m.setAssignmentCount(assignments.size());
            m.setQuizCount(quizzes.size());
            m.setDiscussionCount(discussions.size());
        }
        return modules;
    }

    private List<ModuleInformationDTO> getModuleInformation(int courseId) {
        String sql = "SELECT m.module_id, m.title, m.order_index "
                + "FROM Module m WHERE m.course_id = ? "
                + "ORDER BY m.order_index ASC, m.module_id ASC";
        List<ModuleInformationDTO> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ModuleInformationDTO m = new ModuleInformationDTO();
                m.setId(rs.getInt("module_id"));
                m.setTitle(rs.getString("title"));
                m.setOrderNo(rs.getInt("order_index"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ModuleItemInformationDTO> getModuleItemInformation(int moduleId) {
        String sql = "SELECT mi.module_item_id AS item_id, "
                + "       mi.item_type, "
                + "       COALESCE(l.title, q.title, a.title, d.title) AS title, "
                + "       l.content_type "
                + "FROM ModuleItem mi "
                + "LEFT JOIN Lesson     l ON l.lesson_id     = mi.module_item_id "
                + "LEFT JOIN Quiz       q ON q.quiz_id       = mi.module_item_id "
                + "LEFT JOIN Assignment a ON a.assignment_id = mi.module_item_id "
                + "LEFT JOIN Discussion d ON d.discussion_id = mi.module_item_id "
                + "WHERE mi.module_id = ? "
                + "ORDER BY mi.order_index, mi.module_item_id";
        List<ModuleItemInformationDTO> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ModuleItemInformationDTO it = new ModuleItemInformationDTO();
                it.setId(rs.getInt("item_id"));
                it.setItemType(rs.getString("item_type"));
                it.setTitle(rs.getString("title"));
                it.setContentType(rs.getString("content_type"));
                list.add(it);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private int safeInt(ResultSet rs, String col) throws SQLException {
        int v = rs.getInt(col);
        return rs.wasNull() ? 0 : v;
    }

    public List<ReviewDTO> getTopFourLatestReview(int courseId) {
        String sql = "SELECT TOP (4) r.review_id, r.course_id, r.student_id, r.rating, "
                + "r.comment, r.created_at, r.edited_at, u.full_name AS student_name,"
                + " u.profile_picture AS student_avatar FROM Reviews r JOIN Users u ON u.user_id = r.student_id "
                + "WHERE r.course_id = ? ORDER BY r.created_at DESC, r.review_id DESC;";
        List<ReviewDTO> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ReviewDTO r = new ReviewDTO();
                r.setReviewId(rs.getInt("review_id"));
                r.setCourseId(rs.getInt("course_id"));
                r.setStudentId(rs.getInt("student_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setEditedAt(rs.getTimestamp("edited_at"));
                r.setStudentName(rs.getString("student_name"));
                r.setStudentAvatar(rs.getString("student_avatar")); // null nếu user chưa có ảnh
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CourseInformationDTO> getRandomSameCategory(int currentCourseId) {
        CourseInformationDTO base = getCourseBase(currentCourseId);
        if (base == null) {
            return Collections.emptyList();
        }
        int categoryId = base.getCategoryId();

        String sql = "SELECT TOP (4) c.course_id "
                + " FROM Course c WHERE c.category_id = ? AND c.course_id <> ? ORDER BY NEWID()";

        List<CourseInformationDTO> result = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            st.setInt(2, currentCourseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int cid = rs.getInt("course_id");
                CourseInformationDTO full = getFullCourseInformation(cid);
                if (full != null) {
                    result.add(full);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
