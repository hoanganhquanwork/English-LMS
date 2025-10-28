/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author LENOVO
 */
package dal;

import model.dto.RevenueReportDTO;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class RevenueDAO extends DBContext {

    public List<RevenueReportDTO> getMonthlyReport(int year) {
        List<RevenueReportDTO> list = new ArrayList<>();

        String sql = "SELECT MONTH(o.paid_at) AS month, "
                + "COUNT(oi.course_id) AS courses_sold, "
                + "SUM(p.amount_vnd) AS total_revenue "
                + "FROM Orders o "
                + "LEFT JOIN OrderItems oi ON o.order_id = oi.order_id "
                + "LEFT JOIN Payments p ON o.order_id = p.order_id "
                + "WHERE o.status = 'paid' AND p.status = 'captured' "
                + "AND YEAR(o.paid_at) = ? "
                + "GROUP BY MONTH(o.paid_at) "
                + "ORDER BY MONTH(o.paid_at)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, year);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueReportDTO dto = new RevenueReportDTO();
                    dto.setMonth(rs.getInt("month"));
                    dto.setCourseIdSold(rs.getInt("courses_sold"));
                    dto.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                    dto.setYear(year);
                    list.add(dto);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<RevenueReportDTO> getYearlyReport() {
        List<RevenueReportDTO> list = new ArrayList<>();

        String sql =  "SELECT YEAR(o.paid_at) AS year, "
               +"COUNT(oi.course_id) AS courses_sold, "
               +"SUM(p.amount_vnd) AS total_revenue "
        +"FROM Orders o "
        +"LEFT JOIN OrderItems oi ON o.order_id = oi.order_id "
        +"LEFT JOIN Payments p ON o.order_id = p.order_id "
        +"WHERE o.status = 'paid' AND p.status = 'captured' "
        +"GROUP BY YEAR(o.paid_at) "
        +"ORDER BY YEAR(o.paid_at) ";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RevenueReportDTO dto = new RevenueReportDTO();
                dto.setYear(rs.getInt("year"));
                dto.setCourseIdSold(rs.getInt("courses_sold"));
                dto.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<RevenueReportDTO> getAllMonthlyReports() {
        List<RevenueReportDTO> list = new ArrayList<>();

        String sql = "SELECT YEAR(o.paid_at) AS year, MONTH(o.paid_at) AS month, "
                + "COUNT(oi.course_id) AS courses_sold, "
                + "SUM(p.amount_vnd) AS total_revenue "
                + "FROM Orders o "
                + "LEFT JOIN OrderItems oi ON o.order_id = oi.order_id "
                + "LEFT JOIN Payments p ON o.order_id = p.order_id "
                + "WHERE o.status = 'paid' AND p.status = 'captured' "
                + "GROUP BY YEAR(o.paid_at), MONTH(o.paid_at) "
                + "ORDER BY YEAR(o.paid_at), MONTH(o.paid_at)";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RevenueReportDTO dto = new RevenueReportDTO();
                dto.setYear(rs.getInt("year"));
                dto.setMonth(rs.getInt("month"));
                dto.setCourseIdSold(rs.getInt("courses_sold"));
                dto.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
