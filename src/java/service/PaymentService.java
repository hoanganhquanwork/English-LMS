package service;

import dal.OrderDAO;
import dal.OrderItemDAO;
import java.math.BigDecimal;
import java.util.List;

public class PaymentService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO itemDAO = new OrderItemDAO();

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
}
