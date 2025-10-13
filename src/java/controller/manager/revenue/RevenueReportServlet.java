/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager.revenue;

import dal.RevenueDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.dto.RevenueReportDTO;
import service.RevenueService;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "RevenueReportServlet", urlPatterns = {"/revenue-report"})
public class RevenueReportServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RevenueReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RevenueReportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");
        String yearParam = request.getParameter("year");

        int year = java.time.Year.now().getValue();
        if (yearParam != null && yearParam.matches("\\d{4}")) {
            year = Integer.parseInt(yearParam);
        }

        if (type == null || (!type.equals("year") && !type.equals("month"))) {
            type = "month";
        }

        RevenueService service = new RevenueService(); // ✅ Dùng service thay vì DAO

        try {
            if (type.equals("year")) {
                List<RevenueReportDTO> yearlyReports = service.getYearlyReport();
                request.setAttribute("reports", yearlyReports);
                request.setAttribute("reportType", "year");
            } else {
                List<RevenueReportDTO> monthlyReports = service.getMonthlyReport(year);
                request.setAttribute("reports", monthlyReports);
                request.setAttribute("reportType", "month");
                request.setAttribute("selectedYear", year);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu báo cáo doanh thu: " + e.getMessage());
        }

        RequestDispatcher rd = request.getRequestDispatcher("/views-manager/revenue-report.jsp");
        rd.forward(request, response);
    }
/**
 * Handles the HTTP <code>POST</code> method.
 *
 * @param request servlet request
 * @param response servlet response
 * @throws ServletException if a servlet-specific error occurs
 * @throws IOException if an I/O error occurs
 */
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
