<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    request.setAttribute("currentPage", "orders");
%>

<%@ include file="parent_header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

<main class="container">
    <div class="page-title">
        <h2>🧾 Quản lý đơn hàng</h2>
        <p class="lead">Xem và quản lý các đơn hàng của bạn.</p>
    </div>

    <!-- Bộ lọc trạng thái -->
    <div class="filter-section">
        <div class="filter-tabs">
            <button class="filter-btn active" onclick="showTab('pending')">
                <span class="filter-icon">⏳</span>
                <span class="filter-text">Chờ thanh toán</span>
            </button>
            <button class="filter-btn" onclick="showTab('paid')">
                <span class="filter-icon">✅</span>
                <span class="filter-text">Đã thanh toán</span>
            </button>
        </div>
    </div>

    <!-- Danh sách Pending -->
    <div id="tab-pending" class="order-tab">
        <c:if test="${not empty pendingOrders}">
            <div class="orders-grid">
                <c:forEach var="order" items="${pendingOrders}">
                    <div class="order-card pending">
                        <div class="order-card-header">
                            <div class="order-info">
                                <h3 class="order-id">📋 Đơn hàng #${order.orderId}</h3>
                                <p class="order-date">📅 ${order.formattedCreatedAt}</p>
                            </div>
                            <div class="order-status">
                                <span class="status-badge pending">⏳ Chờ thanh toán</span>
                            </div>
                        </div>

                        <div class="order-items">
                            <h4 class="items-title">📚 Khóa học:</h4>
                            <div class="items-list">
                                <c:forEach var="item" items="${order.items}">
                                    <div class="order-item">
                                        <div class="item-info">
                                            <span class="course-name">${item.course.title}</span>
                                            <span class="student-name">👨‍🎓 ${item.student.user.fullName}</span>
                                        </div>
                                        <span class="item-price">
                                            <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="order-footer">
                            <div class="total-amount">
                                <span class="total-label">💰 Tổng tiền:</span>
                                <span class="total-value">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> VND
                                </span>
                            </div>
                            <a href="${pageContext.request.contextPath}/parent/orderdetail?orderId=${order.orderId}"
                               class="view-order-btn">
                                <span class="btn-icon">👁️</span>
                                <span class="btn-text">Xem chi tiết</span>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty pendingOrders}">
            <div class="empty-state">
                <div class="empty-icon">📭</div>
                <h3>Không có đơn hàng chờ thanh toán</h3>
                <p>Hiện tại bạn chưa có đơn hàng nào đang chờ thanh toán.</p>
            </div>
        </c:if>
    </div>

    <!-- Danh sách Paid -->
    <div id="tab-paid" class="order-tab" style="display:none;">
        <c:if test="${not empty paidOrders}">
            <div class="orders-grid">
                <c:forEach var="order" items="${paidOrders}">
                    <div class="order-card paid">
                        <div class="order-card-header">
                            <div class="order-info">
                                <h3 class="order-id">📋 Đơn hàng #${order.orderId}</h3>
                                <p class="order-date">💰 ${order.formattedPaidAt}</p>
                            </div>
                            <div class="order-status">
                                <span class="status-badge active">✅ Đã thanh toán</span>
                            </div>
                        </div>

                        <div class="order-items">
                            <h4 class="items-title">📚 Khóa học:</h4>
                            <div class="items-list">
                                <c:forEach var="item" items="${order.items}">
                                    <div class="order-item">
                                        <div class="item-info">
                                            <span class="course-name">${item.course.title}</span>
                                            <span class="student-name">👨‍🎓 ${item.student.user.fullName}</span>
                                        </div>
                                        <span class="item-price">
                                            <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="order-footer">
                            <div class="total-amount">
                                <span class="total-label">💰 Tổng tiền:</span>
                                <span class="total-value">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> VND
                                </span>
                            </div>
                            <a href="${pageContext.request.contextPath}/parent/orderdetail?orderId=${order.orderId}"
                               class="view-order-btn">
                                <span class="btn-icon">👁️</span>
                                <span class="btn-text">Xem chi tiết</span>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty paidOrders}">
            <div class="empty-state">
                <div class="empty-icon">📭</div>
                <h3>Không có đơn hàng đã thanh toán</h3>
                <p>Hiện tại bạn chưa có đơn hàng nào đã được thanh toán.</p>
            </div>
        </c:if>
    </div>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>

<script>
    function showTab(tabName) {
        document.querySelectorAll('.order-tab').forEach(div => div.style.display = 'none');
        document.getElementById('tab-' + tabName).style.display = 'block';

        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
    }
</script>

