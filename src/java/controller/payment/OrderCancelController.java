package controller.payment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import service.OrderService;

@WebServlet("/parent/cancelorder")

public class OrderCancelController extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null) {
            response.sendRedirect(request.getContextPath()+"/parent/paymentitems");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            boolean success = orderService.cancelOrder(orderId);
            
            // Kiểm tra nếu request đến từ auto cancel (có header đặc biệt)
            String userAgent = request.getHeader("User-Agent");
            boolean isAutoCancel = request.getHeader("X-Requested-With") == null && 
                                 (userAgent == null || !userAgent.contains("Mozilla"));
            
            if (isAutoCancel) {
                // Trả về JSON response cho auto cancel
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": " + success + "}");
            } else {
                // Redirect bình thường cho user action
                if (success) {
                    response.sendRedirect(request.getContextPath()+"/parent/paymentitems?cancelled=true");
                } else {
                    response.sendRedirect(request.getContextPath()+"/parent/paymentitems?error=cancel_failed");
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi cancel order: " + e.getMessage());
            e.printStackTrace();
            
            // Trả về response phù hợp
            String userAgent = request.getHeader("User-Agent");
            boolean isAutoCancel = request.getHeader("X-Requested-With") == null && 
                                 (userAgent == null || !userAgent.contains("Mozilla"));
            
            if (isAutoCancel) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            } else {
                response.sendRedirect(request.getContextPath()+"/parent/paymentitems?error=cancel_failed");
            }
        }
    }
}
