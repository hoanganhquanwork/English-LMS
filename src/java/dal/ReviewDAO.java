/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.*;
import java.sql.*;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class ReviewDAO extends DBContext {

    public double getAvarageRatingCourse(int courseID) {
        String sql = "SELECT ISNULL(AVG(CAST(rating AS float)), 0) AS avg_rating FROM Reviews WHERE course_id = 11";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseID);
            ResultSet rs = st.executeQuery();
            return rs.next() ? rs.getDouble("avg_rating") : 0.0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<Integer, Double> getAvgForCourses(Collection<Integer> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return Collections.emptyMap();
        }

        String placeholders = makePlaceholders(courseIds.size());
        String sql = "SELECT course_id, ISNULL(AVG(CAST(rating AS float)),0) AS avg_rating "
                + "FROM Reviews WHERE course_id IN (" + placeholders + ") GROUP BY course_id";

        Map<Integer, Double> avg = new HashMap<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int i = 1;
            for (Integer id : courseIds) {
                st.setInt(i++, id);
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                avg.put(rs.getInt(1), rs.getDouble(2));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return avg;
    }

    private static String makePlaceholders(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            if (i > 0) {
                sb.append(',');
            }
            sb.append('?');
        }
        return sb.toString();
    }

}
