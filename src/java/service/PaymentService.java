package service;

import dal.CourseRequestDAO;
import dal.OrderDAO;
import dal.OrderItemDAO;
import dal.PaymentDAO;
import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import model.entity.CourseRequest;
import model.entity.Payment;
import model.entity.Users;
import util.EmailUtil;

public class PaymentService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderItemDAO itemDAO = new OrderItemDAO();
    private final OrderService orderService = new OrderService();
    private final EnrollmentService eService = new EnrollmentService();
    private final CourseRequestDAO crdao = new CourseRequestDAO();

    private static class ParsedRef {
        int orderId = -1;
        List<Integer> reqIds = new ArrayList<>();
    }

    private ParsedRef parseRef(String txnRef) {
        ParsedRef p = new ParsedRef();
        if (txnRef != null && txnRef.startsWith("ORD")) {
            try {
                String core = txnRef.substring(3);
                String[] a = core.split("_R");
                p.orderId = Integer.parseInt(a[0]);
                if (a.length > 1) {
                    String reqPart = a[1].split("_")[0];
                    for (String s : reqPart.split("-")) {
                        if (!s.isBlank()) p.reqIds.add(Integer.parseInt(s));
                    }
                }
            } catch (Exception ignore) {}
        }
        return p;
    }

    public String handleVNPayReturn(HttpServletRequest request) {
        String txnRef = request.getParameter("vnp_TxnRef");
        String responseCode = request.getParameter("vnp_ResponseCode");
        boolean success = "00".equals(responseCode);

        // cập nhật trạng thái thanh toán
        updatePaymentStatus(txnRef, success ? "captured" : "failed");

        ParsedRef ref = parseRef(txnRef);
        String result = "fail";

        if (success && ref.orderId > 0) {
            markOrderPaidByTxn(txnRef);

            for (Integer reqId : ref.reqIds) {
                CourseRequest cr = crdao.getById(reqId);
                if (cr == null || !"unpaid".equalsIgnoreCase(cr.getStatus())) continue;

                int courseId  = cr.getCourse().getCourseId();
                int studentId = cr.getStudent().getUserId();
                double price  = cr.getCourse().getPrice().doubleValue();

                try {
                    itemDAO.createForOrder(ref.orderId, reqId, courseId, studentId, price);
                } catch (RuntimeException ignoreDup) {
                }

                eService.enrollAfterPayment(courseId, studentId);
                crdao.updateStatus(reqId, "approved");
                crdao.updateNoteForRequest(reqId, "Phụ huynh đã thanh toán thành công");
                sendPaymentSuccessEmail(ref.orderId, txnRef);
            }
            result = "success";
        } else {
            if (ref.orderId > 0) {
                orderService.cancelOrder(ref.orderId);
            }
        }
        return result;
    }

    public void sendPaymentSuccessEmail(int orderId, String txnRef) {
        try {
            Payment payment = paymentDAO.getPaymentByTxnRef(txnRef);
            Users parent = orderDAO.getOrderOwner(orderId);
            if (parent == null) {
                return;
            }
            String html = """
            <html>
              <body style="font-family:'Segoe UI',sans-serif;line-height:1.7;color:#333;background-color:#f8f9fa;padding:30px;">
                <div style="max-width:600px;margin:0 auto;background:#fff;border-radius:10px;box-shadow:0 4px 10px rgba(0,0,0,0.1);overflow:hidden;">
                  <div style="background-color:#4CAF50;color:#fff;padding:20px 30px;text-align:center;">
                    <h2 style="margin:0;font-size:22px;">Thanh toán thành công 🎉</h2>
                  </div>

                  <div style="padding:30px;">
                    <p>Xin chào <b>%s</b>,</p>
                    <p>Bạn đã thanh toán thành công đơn hàng <b>#%d</b> qua <b>VNPay</b>.</p>

                    <table style="width:100%%;border-collapse:collapse;margin-top:15px;">
                      <tr style="background:#f0f8f4;">
                        <td style="padding:10px 12px;font-weight:bold;">Số tiền</td>
                        <td style="padding:10px 12px;text-align:right;">%,.0f VND</td>
                      </tr>
                      <tr>
                        <td style="padding:10px 12px;font-weight:bold;">Mã giao dịch</td>
                        <td style="padding:10px 12px;text-align:right;">%s</td>
                      </tr>
                      <tr style="background:#f0f8f4;">
                        <td style="padding:10px 12px;font-weight:bold;">Thời gian</td>
                        <td style="padding:10px 12px;text-align:right;">%s</td>
                      </tr>
                    </table>

                    <p style="margin-top:25px;">Cảm ơn bạn đã sử dụng <b>LinguaTrack</b> để đồng hành trong việc học ngoại ngữ của con bạn.</p>

                    <div style="text-align:center;margin-top:25px;">
                      <a href="http://localhost:9999/EnglishLMS/parent/orders" 
                         style="display:inline-block;background-color:#4CAF50;color:#fff;text-decoration:none;
                                padding:10px 25px;border-radius:6px;font-weight:500;">
                        Xem lại các đơn hàng đã thanh toán
                      </a>
                    </div>

                    <hr style="margin:30px 0;border:none;border-top:1px solid #ddd;">
                    <p style="font-size:13px;color:#777;text-align:center;">
                      Đây là email tự động, vui lòng không trả lời.<br>
                      © 2025 LinguaTrack. All rights reserved.
                    </p>
                  </div>
                </div>
              </body>
            </html>
""".formatted(
                    parent.getFullName(),
                    orderId,
                    payment.getAmount(),
                    payment.getTxnRef(),
                    payment.getCapturedAt()
            );

            EmailUtil.send(parent.getEmail(),
                    "LinguaTrack: Thanh toán thành công",
                    html);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public double getOrderTotal(int orderId) {
        return paymentDAO.getOrderTotal(orderId);
    }

    public void createPayment(int orderId, double amount, String method, String txnRef) {
        if (!paymentDAO.hasPaymentForOrder(orderId)) {
            paymentDAO.insertPayment(orderId, amount, method, txnRef);
        }
    }

    public void updatePaymentStatus(String txnRef, String status) {
        paymentDAO.updatePaymentStatus(txnRef, status);
    }

    public void markOrderPaidByTxn(String txnRef) {
        paymentDAO.updateOrderPaidByTxn(txnRef);
    }

    public void cancelPaymentByOrder(int orderId) {
        paymentDAO.deletePaymentByOrder(orderId);
    }


}
