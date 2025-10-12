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
    <div class="filter-tabs" style="text-align:center; margin-bottom:20px;">
        <button class="filter-btn active" onclick="showTab('pending')">Chờ thanh toán</button>
        <button class="filter-btn" onclick="showTab('paid')">Đã thanh toán</button>
    </div>

    <!-- Danh sách Pending -->
    <div id="tab-pending" class="order-tab">
        <c:if test="${not empty pendingOrders}">
            <c:forEach var="order" items="${pendingOrders}">
                <div class="child-item">
                    <div class="child-header">
                        <div class="child-basic-info">
                            <h4>Đơn hàng #${order.orderId}</h4>
                            <p>Ngày tạo: ${order.formattedCreatedAt}</p>
                        </div>
                        <div class="child-status" style="text-align:right;">
                            <span class="status-badge pending">Chờ thanh toán</span>
                            <p><strong>Tổng:</strong>
                                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> VND
                            </p>
                            <a href="${pageContext.request.contextPath}/parent/orderdetail?orderId=${order.orderId}"
                               class="btn success">Xem đơn hàng</a>
                        </div>
                    </div>

                    <div class="child-detail">
                        <ul>
                            <c:forEach var="item" items="${order.items}">
                               
                                    <li>     
                                    Tên khóa học: <strong>${item.course.title}</strong> 
                                    <br>
                                    Giá: <strong>
                                        <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND </strong>  <br>
                                        Học sinh mua: <strong>${item.student.user.fullName} </strong> 
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty pendingOrders}">
            <p style="text-align:center; color:#666;">Không có đơn hàng chờ thanh toán.</p>
        </c:if>
    </div>

    <!-- Danh sách Paid -->
    <div id="tab-paid" class="order-tab" style="display:none;">
        <c:if test="${not empty paidOrders}">
            <c:forEach var="order" items="${paidOrders}">
                <div class="child-item">
                    <div class="child-header">
                        <div class="child-basic-info">
                            <h4>Đơn hàng #${order.orderId}</h4>
                            <p>Thanh toán lúc: ${order.formattedPaidAt}</p>
                        </div>
                        <div class="child-status" style="text-align:right;">
                            <span class="status-badge active">Đã thanh toán</span>
                            <p><strong>Tổng:</strong>
                                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> VND
                            </p>
                            <a href="${pageContext.request.contextPath}/parent/orderdetail?orderId=${order.orderId}"
                               class="btn success">Xem đơn hàng</a>
                        </div>
                    </div>

                    <div class="child-detail">
                        <ul>
                            <c:forEach var="item" items="${order.items}">
                                <li>     
                                    Tên khóa học: <strong>${item.course.title}</strong> 
                                    <br>
                                    Giá: <strong>
                                        <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND </strong>  <br>
                                        Học sinh mua: <strong>${item.student.user.fullName} </strong> 
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty paidOrders}">
            <p style="text-align:center; color:#666;">Không có đơn hàng đã thanh toán.</p>
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
