<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="parent_header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

<main class="container" style="margin-top:40px;">
    <div class="page-title">
        <h2>💰 Kết quả thanh toán</h2>
    </div>

    <div class="child-item" style="text-align:center; padding:30px;">
        <c:choose>
            <c:when test="${result eq 'success'}">
                <h3 style="color:#16a34a;">✅ Thanh toán thành công!</h3>
                <p>Đơn hàng #${orderId} đã được thanh toán thành công.</p>
                <p><strong>Mã giao dịch:</strong> ${txnRef}</p>
                <p><strong>Số tiền:</strong> 
                    <fmt:formatNumber value="${amount}" pattern="#,##0" /> VND
                </p>
                <p><strong>Thời gian thanh toán:</strong> ${payDate}</p>
            </c:when>

            <c:otherwise>
                <h3 style="color:#dc2626;">❌ Thanh toán thất bại</h3>
                <p>Rất tiếc, giao dịch không thành công hoặc đã bị hủy.</p>
                <p><strong>Mã giao dịch:</strong> ${txnRef}</p>
                <p><strong>Đơn hàng:</strong> #${orderId}</p>
                <p>Vui lòng thử lại hoặc kiểm tra trạng thái đơn hàng.</p>
            </c:otherwise>
        </c:choose>

        <div style="margin-top:30px;">
            <a href="${pageContext.request.contextPath}/parent/orders" class="btn success" 
               style="padding:10px 25px; font-size:16px;">
                🔙 Quay lại danh sách đơn hàng
            </a>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>
