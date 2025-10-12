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

    <div class="child-item">
        <p><strong>Trạng thái:</strong>
            <c:choose>
                <c:when test="${order.status == 'pending'}">
                    <span class="status-badge pending">Chờ thanh toán</span>
                </c:when>
                <c:when test="${order.status == 'paid'}">
                    <span class="status-badge active">Đã thanh toán</span>
                </c:when>
                <c:when test="${order.status == 'cancelled'}">
                    <span class="status-badge rejected">Đã hủy</span>
                </c:when>
            </c:choose>
        </p>

        <p><strong>Ngày tạo:</strong> ${order.formattedCreatedAt}</p>
        <c:if test="${not empty order.formattedPaidAt}">
            <p><strong>Thanh toán lúc:</strong> ${order.formattedPaidAt}</p>
        </c:if>
    </div>

    <div class="children-list">
        <c:forEach var="item" items="${order.items}">
            <div class="child-item">
                <div class="child-header">
                    <div class="child-basic-info">
                        <h3>${item.course.title}</h3>
                        <p class="child-email">Học sinh: ${item.student.user.fullName}</p>
                    </div>
                    <div class="child-status" style="text-align:right;">
                        <p class="link-date">
                            <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="child-item" style="margin-top: 24px;">
        <h3 style="text-align:right;">
            Tổng tiền: 
            <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> VND
        </h3>
    </div>

    <c:if test="${order.status == 'pending'}">
        <div style="text-align:center; margin-top:24px;">
            <form method="post" action="${pageContext.request.contextPath}/parent/vnpay-initiate">
                <input type="hidden" name="orderId" value="${order.orderId}" />
                <button type="submit" class="btn success" style="font-size:16px; padding:10px 30px;">
                    ✅ Tiến hành thanh toán (VNPAY)
                </button>
            </form>
        </div>
    </c:if>

    <c:if test="${order.status == 'pending'}">
        <form action="${pageContext.request.contextPath}/parent/cancelorder" method="get" style="display:inline;">
            <input type="hidden" name="orderId" value="${order.orderId}" />
            <button type="submit" class="btn btn-danger"
                    onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này không?')">
                Hủy đơn hàng
            </button>
        </form>
    </c:if>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>

