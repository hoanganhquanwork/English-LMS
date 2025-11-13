package controller.payment;

import service.OrderService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.entity.Orders;

@WebServlet("/parent/orderdetail")
public class OrderDetailController extends HttpServlet {

    private final OrderService oService = new OrderService() ;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect("orders");
            return;
        }
        Orders order = oService.getOrderDetail(orderIdStr);

        if (order == null) {
            response.sendRedirect("orders");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/parent/order_detail.jsp").forward(request, response);
    }
}
