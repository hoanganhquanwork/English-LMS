/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseManagerDAO;
import dal.RevenueDAO;
import java.math.BigDecimal;
import java.util.List;
import model.dto.RevenueReportDTO;
import model.entity.Course;

/**
 *
 * @author LENOVO
 */
public class ManagerDashboardService {

    private final CourseManagerDAO cDao = new CourseManagerDAO();
    private final RevenueDAO rDao = new RevenueDAO();

    public int getTotalCourses() {
        return cDao.getTotalCourses();
    }

    public int getTotalInstructor() {
        return cDao.getActiveInstructors();
    }

    public int getPendingCourses() {
        return cDao.getPendingApprovals();
    }

    public BigDecimal getTotalRevenue() {
        BigDecimal re = rDao.getTotalRevenueInDays(30);
        return re != null ? re : BigDecimal.ZERO;
    }

    public List<RevenueReportDTO> getMonthlyRevenue(int year) {
        List<RevenueReportDTO> reports = rDao.getMonthlyReport(year);
        fillMissingMonths(reports, year);
        return reports;
    }

    public void getCourseStatusCounts(List<String> statuses, List<Integer> counts) {
        cDao.getCourseStatusCounts(statuses, counts);
    }

    public List<Course> getApprovedOrRejectedCourses() {
        return cDao.getFilteredCourses(null, null, "newest");
    }

    public List<Course> getPublishedOrUnpublishedCourses() {
        return cDao.getFilteredCoursesForPublish(null, null, "newest");
    }

    private void fillMissingMonths(List<RevenueReportDTO> reports, int year) {
        boolean[] exists = new boolean[13];
        for (RevenueReportDTO r : reports) {
            exists[r.getMonth()] = true;
        }

        for (int m = 1; m <= 12; m++) {
            if (!exists[m]) {
                RevenueReportDTO empty = new RevenueReportDTO();
                empty.setMonth(m);
                empty.setYear(year);
                empty.setCourseIdSold(0);
                empty.setTotalRevenue(BigDecimal.ZERO);
                reports.add(empty);
            }
        }

        reports.sort((a, b) -> Integer.compare(a.getMonth(), b.getMonth()));
    }
}
