package controller.payment;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

import model.entity.CourseRequest;
import model.entity.Users;
import service.CourseRequestService;
import dal.OrderDAO;

@WebServlet("/parent/paymentitems")
public class PaymentItemsController extends HttpServlet {

    private final CourseRequestService crService = new CourseRequestService();
    private final OrderDAO orderDAO = new OrderDAO();

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

        List<CourseRequest> items = crService.getRequests(parentId, "unpaid");
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

        String[] selected = request.getParameterValues("selectedItem"); // requestId[]
        if (selected == null || selected.length == 0) {
            request.setAttribute("error", "Vui lòng chọn ít nhất một mục để thanh toán!");
            doGet(request, response);
            return;
        }

        List<Integer> requestIds = Arrays.stream(selected)
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        int orderId = orderDAO.createOrder(parentId, BigDecimal.ZERO);
        if (orderId <= 0) {
            request.setAttribute("error", "Tạo đơn hàng thất bại. Vui lòng thử lại.");
            doGet(request, response);
            return;
        }

        request.setAttribute("orderId", String.valueOf(orderId));
        request.setAttribute("requestIds", requestIds.stream()
                .map(String::valueOf).collect(Collectors.joining("-")));

        request.getRequestDispatcher("/parent/vnpay-initiate").forward(request, response);
    }
}
