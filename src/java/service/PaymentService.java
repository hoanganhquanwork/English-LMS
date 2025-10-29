package service;

import dal.OrderDAO;
import dal.PaymentDAO;
import model.entity.Payment;
import model.entity.Users;
import util.EmailUtil;

public class PaymentService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

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
                      <a href="http://localhost:8080/EnglishLMS/parent/orders" 
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
