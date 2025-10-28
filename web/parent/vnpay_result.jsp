<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="parent_header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

<main class="container" style="margin-top:40px;">
    <div class="page-title">
        <h2>💰 Kết quả thanh toán</h2>
    </div>

    <c:choose>
        <c:when test="${result eq 'success'}">
            <!-- Success State -->
            <div class="payment-result-card success">
                <div class="result-animation">
                    <div class="success-icon">🎉</div>
                    <div class="confetti">
                        <div class="confetti-piece"></div>
                        <div class="confetti-piece"></div>
                        <div class="confetti-piece"></div>
                        <div class="confetti-piece"></div>
                        <div class="confetti-piece"></div>
                    </div>
                </div>

                <div class="result-content">
                    <h3 class="result-title success">🎊 Thanh toán thành công!</h3>
                    <p class="result-message">Chúc mừng! Giao dịch của bạn đã được xử lý thành công.</p>

                    <div class="success-message">
                        <p>🎯 Đơn hàng của bạn đã được xác nhận và sẽ được xử lý trong thời gian sớm nhất.</p>
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/parent/orders" class="btn primary">
                        <span class="btn-icon">📋</span>
                        <span class="btn-text">Xem danh sách đơn hàng</span>
                    </a>

                </div>
            </div>
        </c:when>

        <c:otherwise>
            <!-- Error State -->
            <div class="payment-result-card error">
                <div class="result-animation">
                    <div class="error-icon">😔</div>
                </div>

                <div class="result-content">
                    <h3 class="result-title error">❌ Thanh toán không thành công</h3>
                    <p class="result-message">Rất tiếc, giao dịch không thể hoàn tất hoặc đã bị hủy.</p>

                    <div class="error-message">
                        <p>🔄 Vui lòng thử lại thanh toán hoặc liên hệ hỗ trợ nếu vấn đề vẫn tiếp diễn.</p>
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/parent/paymentitems" class="btn primary">
                        <span class="btn-icon">📋</span>
                        <span class="btn-text">Quay lại danh sách chờ thanh toán</span>
                    </a>

                </div>
            </div>
        </c:otherwise>
    </c:choose>


</main>

<footer>
        <jsp:include page="/footer.jsp" />
</footer>
