package controller.payment;

import service.OrderService;
import service.EnrollmentService;
import service.PaymentService;
import dal.OrderItemDAO;
import model.entity.OrderItem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/parent/vnpay-return")
public class VNPayReturnController extends HttpServlet {
    
    private final PaymentService paymentService = new PaymentService();
    private final OrderService orderService = new OrderService();
    private final EnrollmentService eService = new EnrollmentService();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String txnRef = request.getParameter("vnp_TxnRef");
        String responseCode = request.getParameter("vnp_ResponseCode");
        boolean success = "00".equals(responseCode);

        // Cập nhật Payment
        paymentService.updatePaymentStatus(txnRef, success ? "captured" : "failed");

        int orderId = -1;
        if (txnRef != null && txnRef.startsWith("ORD")) {
            try {
                orderId = Integer.parseInt(txnRef.split("_")[0].substring(3)); // ví dụ ORD38_1234 → 38
            } catch (NumberFormatException ignored) {}
        }

        String result = "fail";

        if (success && orderId > 0) {
            paymentService.markOrderPaidByTxn(txnRef);
            orderService.updateOrderPaidSuccess(orderId);

            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
            for (OrderItem item : items) {
                if (item.getCourse() != null && item.getStudent() != null) {
                    int courseId = item.getCourse().getCourseId();
                    int studentId = item.getStudent().getUserId();
                    eService.enrollAfterPayment(courseId, studentId);
                }
            }

            result = "success";
        } else {
            if (orderId > 0) {
                orderService.cancelOrder(orderId);
            }
        }

        request.setAttribute("result", result);
        request.getRequestDispatcher("/parent/vnpay_result.jsp").forward(request, response);
    }
}
