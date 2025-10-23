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
        <h2>🧾 Mục chờ thanh toán</h2>
        <p class="lead">Xem và chọn các khóa học đã được duyệt để thanh toán.</p>
    </div>

    <c:if test="${not empty error}">
        <div style="background:#fee2e2;color:#b91c1c;padding:8px 12px;border-radius:6px;margin-bottom:16px;">
            ${error}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty items}">
         <div class="empty-state">
            <div class="empty-icon">📭</div>
            <h3>Chưa có khóa học chờ thanh toán</h3>
            <p>Hiện tại bạn chưa có khóa học nào chờ thanh toán.</p>
        </div>
        </c:when>

        <c:otherwise>
            <form method="post" action="paymentitems" onsubmit="return confirmSelection()">
                <div class="children-list">
                    <c:forEach var="item" items="${items}">
                        <div class="payment-item">    
                            <div class="payment-item-content">
                                <div class="course-info-section">
                                    <div class="child-avatar">
                                        <img src="${empty item.student.user.profilePicture 
                                                    ? 'https://via.placeholder.com/80x80/4f46e5/ffffff?text=HS'
                                                    : item.student.user.profilePicture}"
                                             alt="Avatar" />
                                    </div>

                                    <div class="course-details">
                                        <h3 class="course-title">${item.course.title}</h3>
                                        <p class="student-name">👨‍🎓 Học sinh: ${item.student.user.fullName}</p>
                                        <div class="course-meta">
                                            <span class="status-badge pending">⏳ Chờ thanh toán</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="price-section">
                                    <div class="price-info">
                                        <c:choose>
                                            <c:when test="${not empty item.course.price}">
                                                <span class="price-label">Giá khóa học:</span>
                                                <span class="price-value">
                                                    <fmt:formatNumber value="${item.course.price}" type="number" groupingUsed="true" /> VND
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-error">❌ Giá không có</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="payment-action">
                                        <label class="payment-checkbox">
                                            <!-- GẮN data-price để JS đọc số -->
                                            <input type="checkbox"
                                                   name="selectedItem"
                                                   value="${item.requestId}"
                                                   <c:if test="${empty item.course.price}">disabled</c:if>
                                                   data-price="${empty item.course.price ? 0 : item.course.price}" />
                                            <span class="checkbox-custom"></span>
                                            <span class="checkbox-text">Chọn thanh toán</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- KHU VỰC HIỂN THỊ TỔNG THEO LỰA CHỌN -->
                <div class="payment-summary" style="display:flex;justify-content:space-between;align-items:center;margin:16px 0;padding:12px 16px;border:1px solid #e5e7eb;border-radius:10px;background:#f9fafb;">
                    <div>
                        <strong>Đã chọn: </strong> <span id="selCount">0</span> mục
                        <br> <br>
                        <strong>Tổng số tiền: </strong> <span class ="price-value" id="selTotal">0 VND</span>
                    </div>
                    <small class="muted">Tổng tiền được cập nhật theo các mục đã chọn</small>
                </div>

                <div class="payment-footer">
                    <button type="submit" class="payment-submit-btn">
                        <span class="btn-icon">💳</span>
                        <span class="btn-text">Thanh toán các mục đã chọn</span>
                    </button>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</main>

<footer>
        <jsp:include page="/footer.jsp" />
</footer>

<script>
    const fmtVND = new Intl.NumberFormat('vi-VN');

    function recalcTotal() {
        let sum = 0;
        let count = 0;
        document.querySelectorAll('input[name="selectedItem"]:checked').forEach(cb => {
            count++;
            const p = parseFloat(cb.dataset.price || '0');
            if (!Number.isNaN(p)) sum += p;
        });
        document.getElementById('selCount').textContent = count.toString();
        document.getElementById('selTotal').textContent = fmtVND.format(Math.round(sum)) + ' VND';
    }

    function confirmSelection() {
        const checked = document.querySelectorAll('input[name="selectedItem"]:checked');
        if (checked.length === 0) {
            alert('Vui lòng chọn ít nhất một khóa học để thanh toán!');
            return false;
        }
        const totalText = document.getElementById('selTotal').textContent;
        return confirm('Bạn có chắc muốn tạo đơn thanh toán cho ' + checked.length + ' khóa học đã chọn?'
                       + '\nTổng thanh toán: ' + totalText);
    }

    // Lắng nghe thay đổi checkbox
    document.addEventListener('change', function (e) {
        if (e.target && e.target.name === 'selectedItem') {
            recalcTotal();
        }
    });

   
</script>
