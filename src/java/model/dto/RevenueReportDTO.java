/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.math.BigDecimal;

/**
 *
 * @author LENOVO
 */

//lấy attribute từ 3 bảng Order (month), OrderItems (courseIdSold) và totalRevennue lấy từ cái Payment
public class RevenueReportDTO {
 private int month;
 private int courseIdSold;
 private BigDecimal totalRevenue;
private int year;
    public RevenueReportDTO() {
    }

    public RevenueReportDTO(int month, int courseIdSold, BigDecimal totalRevenue, int year) {
        this.month = month;
        this.courseIdSold = courseIdSold;
        this.totalRevenue = totalRevenue;
        this.year = year;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getCourseIdSold() {
        return courseIdSold;
    }

    public void setCourseIdSold(int courseIdSold) {
        this.courseIdSold = courseIdSold;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

   
}
