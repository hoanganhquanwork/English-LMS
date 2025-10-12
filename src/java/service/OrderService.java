package service;

import dal.OrderDAO;
import dal.OrderItemDAO;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    public boolean cancelOrder(int orderId) {
        try {
            // 1. Cập nhật trạng thái đơn
            boolean updated = orderDAO.updateStatus(orderId, "cancelled");
            if (!updated) return false;

            // 2. Xóa liên kết order_id trong OrderItems
            orderItemDAO.clearOrderItems(orderId);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateOrderPaidSuccess(int orderId) {
        orderDAO.updateOrderPaidSuccess(orderId);
    }
}
