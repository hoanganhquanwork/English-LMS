package service;

import dal.CourseRequestDAO;
import dal.OrderDAO;
import dal.OrderItemDAO;
import dal.PaymentDAO;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import model.entity.CourseRequest;

/**
 * Luồng thanh toán (mới):
 * 1) initiatePayment(parentId, requestIds):
 *    - Validate CR thuộc parent & status=unpaid
 *    - Tạo Order (pending), tính tổng tiền
 *    - Tạo Payment (initiated) với txnRef = "ORD{orderId}_R{r1-r2-...}"
 *
 * 2) handleReturn(txnRef, success):
 *    - Cập nhật trạng thái Payment captured/failed
 *    - Parse txnRef để lấy orderId + requestIds
 *    - Nếu success:
 *        + Mark Order paid
 *        + Tạo OrderItems từ từng CourseRequest
 *        + Enroll và chốt CourseRequest -> 'approved'
 *      Nếu fail:
 *        + Hủy Order (cancelled) và dọn dẹp cần thiết
 */
public class PaymentService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO itemDAO = new OrderItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final CourseRequestDAO crdao = new CourseRequestDAO();
    private final EnrollmentService enrollmentService = new EnrollmentService();

    public static final String METHOD_VNPAY = "ewallet"; 

    public static class InitResult {
        public final int orderId;
        public final double amount;
        public final String txnRef;
        public InitResult(int orderId, double amount, String txnRef) {
            this.orderId = orderId; this.amount = amount; this.txnRef = txnRef;
        }
    }

 
    public InitResult initiatePayment(int parentId, List<Integer> requestIds) {
        if (requestIds == null || requestIds.isEmpty()) {
            throw new IllegalArgumentException("Danh sách request trống.");
        }

        // Tạo Order 'pending' (total DB có thể để 0, tổng dùng cho payment)
        int orderId = orderDAO.createOrder(parentId, BigDecimal.ZERO);
        if (orderId <= 0) throw new RuntimeException("Tạo Order thất bại.");

        double total = 0d;
        StringBuilder ref = new StringBuilder("ORD").append(orderId).append("_R");
        boolean first = true;

        for (Integer reqId : requestIds) {
            if (reqId == null) continue;
            CourseRequest cr = crdao.getById(reqId);
            if (cr == null || cr.getParent() == null) continue;
            if (cr.getParent().getUserId() != parentId) continue;
            if (!"unpaid".equalsIgnoreCase(cr.getStatus())) continue;

            total += cr.getCourse().getPrice().doubleValue();
            if (!first) ref.append("-");
            ref.append(reqId);
            first = false;
        }

        if (total <= 0) throw new IllegalStateException("Không có CourseRequest 'unpaid' hợp lệ.");

        String txnRef = ref.toString(); // ví dụ: ORD38_R12-19-25
        paymentDAO.insertPayment(orderId, total, METHOD_VNPAY, txnRef); // status='initiated'
        return new InitResult(orderId, total, txnRef);
    }

 
    public boolean handleReturn(String txnRef, boolean success) {
        // Update trạng thái payment
        paymentDAO.updatePaymentStatus(txnRef, success ? "captured" : "failed");

        // Parse txnRef -> lấy orderId + list requestIds: ORD{orderId}_R{r1-r2-...}
        int orderId = -1;
        List<Integer> reqIds = new ArrayList<>();
        try {
               if (txnRef != null && txnRef.startsWith("ORD")) {
            // Bỏ phần timestamp (ví dụ: "_1761673803343") nếu có
            int lastUnderscore = txnRef.lastIndexOf('_');
            int rIndex = txnRef.indexOf("_R");
            String cleanRef = (lastUnderscore > rIndex)
                    ? txnRef.substring(0, lastUnderscore)
                    : txnRef;

            // Tách phần ORD{orderId} và R{reqIds}
            String[] parts = cleanRef.split("_R");
            orderId = Integer.parseInt(parts[0].substring(3));

            if (parts.length > 1) {
                for (String s : parts[1].split("-")) {
                    if (!s.isBlank()) reqIds.add(Integer.parseInt(s));
                }
            }
        }
        } catch (Exception ignore) {}

        if (orderId <= 0) return false;

        if (success) {
            // Đánh dấu Order đã thanh toán (Orders -> paid + paid_at)
            paymentDAO.updateOrderPaidByTxn(txnRef);

            //  tạo OrderItems + Enroll + chốt CR
            for (Integer reqId : reqIds) {
                CourseRequest cr = crdao.getById(reqId);
                if (cr == null) continue;
                if (!"unpaid".equalsIgnoreCase(cr.getStatus())) continue;

                double price = cr.getCourse().getPrice().doubleValue();
                itemDAO.createForOrder(
                        orderId,
                        reqId,
                        cr.getCourse().getCourseId(),
                        cr.getStudent().getUserId(),
                        price
                );

                enrollmentService.enrollAfterPayment(
                        cr.getCourse().getCourseId(),
                        cr.getStudent().getUserId()
                );

                crdao.updateStatus(reqId, "approved");
            }
            return true;
        } else {
            // Thanh toán thất bại -> hủy Order
            new OrderService().cancelOrder(orderId);
            return false;
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

    // Sinh chữ ký HMAC SHA512 (phục vụ VNPay)
    public String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) hash.append(String.format("%02x", b));
            return hash.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Lỗi tạo HMAC SHA512", ex);
        }
    }
}
