package controller.payment;

import dal.OrderItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.entity.OrderItem;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import model.entity.Users;
import service.PaymentService;

@WebServlet("/parent/paymentitems")
public class PaymentItemsController extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();
    private final OrderItemDAO itemDAO = new OrderItemDAO();

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
        List<OrderItem> items = itemDAO.getPendingItemsByParent(parentId);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/parent/payment_items.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users parent = (Users) session.getAttribute("user");
        int parentId = parent.getUserId();
        String[] selected = request.getParameterValues("selectedItem");

        if (selected == null || selected.length == 0) {
            request.setAttribute("error", "Vui lòng chọn ít nhất một mục để thanh toán!");
            doGet(request, response);
            return;
        }

        List<Integer> itemIds = Arrays.stream(selected)
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        int orderId = paymentService.createOrderFromItems(parentId, itemIds);
        
        if (orderId > 0) {
            response.sendRedirect("orderdetail?orderId=" + orderId);
        } else {
            request.setAttribute("error", "Tạo đơn hàng thất bại. Vui lòng thử lại.");
            doGet(request, response);
        }
        
    }
}
