package controller.payment;

import service.OrderService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import model.entity.Orders;
import model.entity.Users;

@WebServlet("/parent/orders")
public class OrderListController extends HttpServlet {

    private final OrderService service = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        Users parent = (Users) session.getAttribute("user");
        int parentId = parent.getUserId();

        List<Orders> paidOrders = service.getOrdersByParentAndStatus(parentId, "paid");

        request.setAttribute("paidOrders", paidOrders);

        request.getRequestDispatcher("/parent/order_list.jsp").forward(request, response);
    }
}
