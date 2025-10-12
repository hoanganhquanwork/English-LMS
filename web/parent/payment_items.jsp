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
            <p class="muted">Hiện chưa có khóa học nào đang chờ thanh toán.</p>
        </c:when>

        <c:otherwise>
            <form method="post" action="paymentitems" onsubmit="return confirmSelection()">
                <div class="children-list">
                    <c:forEach var="item" items="${items}">
                        <div class="child-item">    
                            <div class="child-header">
                                <div class="child-avatar">
                                    <img src="${empty item.student.user.profilePicture 
                                                ? 'https://via.placeholder.com/80x80/4f46e5/ffffff?text=HS'
                                                : item.student.user.profilePicture}"
                                         alt="Avatar" />
                                </div>

                                <div class="child-basic-info">
                                    <h3>${item.course.title}</h3>
                                    <p class="child-email">Học sinh: ${item.student.user.fullName}</p>
                                </div>

                                <div class="child-status" style="text-align:right;">
                                    <span class="status-badge pending">Chờ thanh toán</span>
                                    <p class="link-date">
                                        <c:choose>
                                            <c:when test="${not empty item.priceVnd}">
                                                <fmt:formatNumber value="${item.priceVnd}" type="number" groupingUsed="true" /> VND
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: red;">Giá không có</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>

                            <div class="child-actions">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="selectedItem" value="${item.orderItemId}" />
                                    <span>Chọn thanh toán</span>
                                </label>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div style="text-align:center; margin-top:30px;">
                    <button type="submit" class="btn success" style="font-size:16px; padding:10px 30px;">
                        💳 Thanh toán các mục đã chọn
                    </button>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>

<script>
    function confirmSelection() {
        const checked = document.querySelectorAll('input[name="selectedItem"]:checked');
        if (checked.length === 0) {
            alert('Vui lòng chọn ít nhất một khóa học để thanh toán!');
            return false;
        }
        return confirm('Bạn có chắc muốn tạo đơn thanh toán cho ' + checked.length + ' khóa học đã chọn?');
    }
</script>

<style>
    .checkbox-label {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 15px;
        color: #374151;
    }
    input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
    }
</style>
