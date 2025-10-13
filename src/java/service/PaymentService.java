package service;

import dal.OrderDAO;
import dal.OrderItemDAO;
import dal.PaymentDAO;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.List;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class PaymentService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO itemDAO = new OrderItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public int createOrderFromItems(int parentId, List<Integer> itemIds) {
        // 1️⃣ Tính tổng tiền
        BigDecimal total = itemDAO.calculateTotalByIds(itemIds);
        if (total.compareTo(BigDecimal.ZERO) <= 0) return -1;

        // 2️⃣ Tạo order mới
        int newOrderId = orderDAO.createOrder(parentId, total);
        if (newOrderId <= 0) return -1;

        // 3️⃣ Gán các item vào order
        boolean success = itemDAO.assignItemsToOrder(itemIds, newOrderId);
        if (!success) return -1;

        return newOrderId;
    }
    
    // Lấy tổng tiền order
    public double getOrderTotal(int orderId) {
        return paymentDAO.getOrderTotal(orderId);
    }

    // Tạo payment nếu chưa tồn tại
    public void createPayment(int orderId, double amount, String method, String txnRef) {
        if (!paymentDAO.hasPaymentForOrder(orderId)) {
            paymentDAO.insertPayment(orderId, amount, method, txnRef);
        }
    }

    // Cập nhật trạng thái thanh toán
    public void updatePaymentStatus(String txnRef, String status) {
        paymentDAO.updatePaymentStatus(txnRef, status);
    }

    // Đánh dấu order đã thanh toán
    public void markOrderPaidByTxn(String txnRef) {
        paymentDAO.updateOrderPaidByTxn(txnRef);
    }

    // Xoá payment khi huỷ order
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
