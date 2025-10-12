package controller.payment;

import service.OrderService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import service.OrderService;
import service.PaymentService;

@WebServlet("/parent/vnpay-return")
public class VNPayReturnController extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();
    private final OrderService orderService = new OrderService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String txnRef = request.getParameter("vnp_TxnRef");
        String responseCode = request.getParameter("vnp_ResponseCode");
        boolean success = "00".equals(responseCode);
        paymentService.updatePaymentStatus(txnRef, success ? "captured" : "failed");
        int orderId = -1;
        if (txnRef != null && txnRef.startsWith("ORD")) {
            try {
               orderId = Integer.parseInt(txnRef.split("_")[0].substring(3));
            } catch (NumberFormatException e) {
            }
        }
        if (success) {
            paymentService.markOrderPaidByTxn(txnRef);
            orderService.updateOrderPaidSuccess(orderId);
            request.setAttribute("message", "✅ Thanh toán thành công qua VNPay!");
        } else {
            orderService.cancelOrder(orderId);
            request.setAttribute("error", "❌ Thanh toán thất bại hoặc bị hủy!");
        }

        request.getRequestDispatcher("/parent/order_detail.jsp").forward(request, response);
    }
}
