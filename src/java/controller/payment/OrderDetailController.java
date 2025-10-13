package controller.payment;

import dal.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.entity.Orders;

@WebServlet("/parent/orderdetail")
public class OrderDetailController extends HttpServlet {

    private final OrderDAO dao = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect("paymentitems");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        Orders order = dao.getOrderDetail(orderId);

        if (order == null) {
            response.sendRedirect("paymentitems?error=notfound");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/parent/order_detail.jsp").forward(request, response);
    }
}
