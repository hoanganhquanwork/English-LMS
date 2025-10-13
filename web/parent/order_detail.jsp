<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    request.setAttribute("currentPage", "payments");
%>

<%@ include file="parent_header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

<main class="container">
    <div class="page-title">
        <h2>💳 Chi tiết đơn hàng #${order.orderId}</h2>
        <p class="lead">Xem lại thông tin đơn hàng trước khi thanh toán.</p>
    </div>

    <div class="order-info-card">
        <div class="order-header">
            <div class="order-status-section">
                <h3 class="order-status-title">📋 Thông tin đơn hàng</h3>
                <div class="status-container">
                    <span class="status-label">Trạng thái:</span>
                    <c:choose>
                        <c:when test="${order.status == 'pending'}">
                            <span class="status-badge pending">⏳ Chờ thanh toán</span>
                        </c:when>
                        <c:when test="${order.status == 'paid'}">
                            <span class="status-badge active">✅ Đã thanh toán</span>
                        </c:when>
                        <c:when test="${order.status == 'cancelled'}">
                            <span class="status-badge rejected">❌ Đã hủy</span>
                        </c:when>
                    </c:choose>
                </div>
            </div>
            
            <div class="order-dates">
                <div class="date-item">
                    <span class="date-label">📅 Ngày tạo:</span>
                    <span class="date-value">${order.formattedCreatedAt}</span>
                </div>
                <c:if test="${not empty order.formattedPaidAt}">
                    <div class="date-item">
                        <span class="date-label">💰 Thanh toán lúc:</span>
                        <span class="date-value">${order.formattedPaidAt}</span>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="course-items-section">
        <h3 class="section-title">📚 Khóa học trong đơn hàng</h3>
        <div class="course-items-list">
            <c:forEach var="item" items="${order.items}">
                <div class="course-item">
                    <div class="course-item-content">
                        <div class="course-info">
                            <h4 class="course-title">${item.course.title}</h4>
                            <p class="student-info">👨‍🎓 Học sinh: ${item.student.user.fullName}</p>
                        </div>
                        <div class="course-price">
                            <span class="price-value">
                                <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="total-amount-card">
        <div class="total-amount-content">
            <span class="total-label">💰 Tổng tiền:</span>
            <span class="total-value">
                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> VND
            </span>
        </div>
    </div>

    <c:if test="${order.status == 'pending'}">
        <div class="action-buttons">
            <form method="post" action="${pageContext.request.contextPath}/parent/vnpay-initiate" class="payment-form">
                <input type="hidden" name="orderId" value="${order.orderId}" />
                <button type="submit" class="payment-btn">
                    <span class="btn-icon">💳</span>
                    <span class="btn-text">Tiến hành thanh toán (VNPAY)</span>
                </button>
            </form>
            
            <form action="${pageContext.request.contextPath}/parent/cancelorder" method="get" class="cancel-form">
                <input type="hidden" name="orderId" value="${order.orderId}" />
                <button type="submit" class="cancel-btn"
                        onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này không?')">
                    <span class="btn-icon">❌</span>
                    <span class="btn-text">Hủy đơn hàng</span>
                </button>
            </form>
        </div>
    </c:if>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>

