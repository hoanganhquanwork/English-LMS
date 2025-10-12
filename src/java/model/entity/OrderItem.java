package model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Ánh xạ bảng OrderItems trong DB:
 *   - Mỗi OrderItem tương ứng với một khóa học (Course) được chọn để thanh toán
 *   - Có thể thuộc về một Order tổng (order_id != null)
 */
public class OrderItem {

    private int orderItemId;
    private Orders order;           // chứa thông tin đơn hàng tổng (nếu đã gộp)
    private CourseRequest request;  // yêu cầu học sinh gốc
    private Course course;          // khóa học
    private StudentProfile student; // học sinh đăng ký
    private BigDecimal priceVnd;    // giá tiền
    private LocalDateTime createdAt; // (optional, có thể thêm để hiển thị sau)

    public OrderItem() {}

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    public CourseRequest getRequest() {
        return request;
    }

    public void setRequest(CourseRequest request) {
        this.request = request;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public StudentProfile getStudent() {
        return student;
    }

    public void setStudent(StudentProfile student) {
        this.student = student;
    }

    public BigDecimal getPriceVnd() {
        return priceVnd;
    }

    public void setPriceVnd(BigDecimal priceVnd) {
        this.priceVnd = priceVnd;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

   
}
