package model.entity;

import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class Orders {

    private int orderId;
    private ParentProfile parent;
    private String status;
    private String paymentMethod;
    private LocalDateTime paidAt;
    private LocalDateTime createdAt;
    private String formattedPaidAt;
    private String formattedCreatedAt;

    // ✅ Bổ sung 2 trường này
    private List<OrderItem> items;         // danh sách các mục trong đơn
    private BigDecimal totalAmount;        // tổng tiền đơn hàng

    public Orders() {
    }

    // --- Getter/Setter cơ bản ---
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public ParentProfile getParent() {
        return parent;
    }

    public void setParent(ParentProfile parent) {
        this.parent = parent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
        if (createdAt != null) {
            this.formattedCreatedAt = createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
        if (paidAt != null) {
            this.formattedPaidAt = paidAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
    }

    public String getFormattedCreatedAt() {
        return formattedCreatedAt;
    }

    public String getFormattedPaidAt() {
        return formattedPaidAt;
    }
}
