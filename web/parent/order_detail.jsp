<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    request.setAttribute("currentPage", "orders");
%>

<jsp:include page="../header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

<main class="container d-flex flex-column min-vh-100">
    <div class="contain flex-grow-1">
        <div class="page-title">
            <h2>💳 Chi tiết đơn hàng #${order.orderId}</h2>
            <p class="lead">Xem lại thông tin đơn hàng và các khóa học được chọn thanh toán.</p>
        </div>

        <div class="order-info-card">
            <div class="order-header">
                <div class="order-status-section">
                    <h3 class="order-status-title">📋 Thông tin đơn hàng</h3>
                    <div class="status-container">
                        <span class="status-label">Trạng thái:</span>
                                <span class="status-badge active">✅ Đã thanh toán</span>                          
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
                                <a href="${pageContext.request.contextPath}/courseInformation?courseId=${item.course.courseId}" class="btn primary" target="_blank"> Xem thông tin khóa học </a>
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

        
    </div>  
</main>


<footer>
    <jsp:include page="/footer.jsp" />
</footer>

