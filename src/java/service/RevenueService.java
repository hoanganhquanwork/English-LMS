/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.RevenueDAO;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.dto.RevenueReportDTO;
import java.io.PrintWriter;

/**
 *
 * @author LENOVO
 */
public class RevenueService {

    private final RevenueDAO revenueDAO;

    public RevenueService() {
        this.revenueDAO = new RevenueDAO();
    }

    public List<RevenueReportDTO> getMonthlyReport(int year) {
        List<RevenueReportDTO> reports = revenueDAO.getMonthlyReport(year);
        fillMissingMonths(reports, year);
        return reports;
    }

    public List<RevenueReportDTO> getYearlyReport() {
        return revenueDAO.getYearlyReport();
    }

    private void fillMissingMonths(List<RevenueReportDTO> reports, int year) {
        boolean[] exists = new boolean[13]; // 1..12
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

    public void exportCsv(HttpServletResponse response, List<RevenueReportDTO> reports, String type) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=revenue_report_" + type + ".csv");

        try (PrintWriter writer = response.getWriter()) {
            writer.write("\uFEFF");
            writer.println("Kỳ,Doanh thu (₫),Số khóa học bán ra");

            for (RevenueReportDTO r : reports) {
                String label = type.equals("year")
                        ? (r.getMonth() > 0 ? "Tháng " + r.getMonth() + "/" + r.getYear() : String.valueOf(r.getYear()))
                        : "Tháng " + r.getMonth();
                writer.printf("%s,%s,%s%n", label, r.getTotalRevenue(), r.getCourseIdSold());
            }
        }
    }

    public List<RevenueReportDTO> getAllMonthlyReports() {
        return revenueDAO.getAllMonthlyReports();
    }
}
