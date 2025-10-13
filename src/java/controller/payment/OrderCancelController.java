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
            response.sendRedirect(request.getContextPath() + "/parent/paymentitems");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            boolean success = orderService.cancelOrder(orderId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/parent/paymentitems");
            } else {
                response.sendRedirect(request.getContextPath() + "/parent/paymentitems");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/parent/paymentitems");
        }
    }

}
