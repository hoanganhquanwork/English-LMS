package service;

import dal.OrderDAO;
import dal.OrderItemDAO;
import java.math.BigDecimal;
import java.util.List;
import model.entity.OrderItem;
import model.entity.Orders;

public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    public boolean cancelOrder(int orderId) {
        try {
            // 1. Cập nhật trạng thái đơn
            boolean updated = orderDAO.updateStatus(orderId, "cancelled");
            if (!updated) {
                return false;
            }

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

    public List<Orders> getOrdersByParentAndStatus(Integer parentId, String status) {
        return loadOrdersWithItems(parentId, status);
    }

    private List<Orders> loadOrdersWithItems(int parentId, String status) {
        List<Orders> orders = orderDAO.getOrdersByParentAndStatus(parentId, status);

        for (Orders order : orders) {
            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
            order.setItems(items);
        }

        return orders;
    }

    public Orders getOrderDetail(String orderIdStr) {
        int orderId = Integer.parseInt(orderIdStr);
        Orders order = orderDAO.getOrderDetail(orderId);
        if(order!=null && order.getStatus().equalsIgnoreCase("paid")){
            return order;
        }
        return null;
    }

}
