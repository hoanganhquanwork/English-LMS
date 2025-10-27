<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    request.setAttribute("currentPage", "dashboard");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Dashboard Phụ huynh | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css">
    </head>

    <body>
        <%@ include file="parent_header.jsp" %>

        <main class="container">

            <div class="page-title">
                <h2>Dashboard Phụ huynh</h2>
                <p class="lead">Quản lý việc học của con em và theo dõi tiến độ học tập.</p>
            </div>

            <div class="progress-overview">
                <div class="overview-card">
                    <div class="card-icon">👨‍👩‍👧‍👦</div>
                    <div class="card-content">
                        <h2>${vm.childAccounts}</h3>
                            <p>Tài khoản con</p>
                    </div>
                </div>

                <div class="overview-card">
                    <div class="card-icon">📚</div>
                    <div class="card-content">
                        <h2>${vm.purchasedCourses}</h3>
                            <p>Khóa học đã mua</p>
                    </div>
                </div>

                <div class="overview-card">
                    <div class="card-icon">📖</div>
                    <div class="card-content">
                        <h2>${vm.activeCourses}</h3>
                            <p>Khóa học đang học</p>
                    </div>
                </div>

                <div class="overview-card">
                    <div class="card-icon">⏳</div>
                    <div class="card-content">
                        <h2>${vm.pendingRequests}</h3>
                            <p>Yêu cầu chờ duyệt</p>
                    </div>
                </div>

                <div class="overview-card">
                    <div class="card-icon">💳</div>
                    <div class="card-content">
                        <h2>${vm.pendingPayments}</h3>
                            <p>Khóa học chờ thanh toán</p>
                    </div>
                </div>
            </div>

            <!-- CHILDREN OVERVIEW -->
            <div class="progress-section">
                <h2>Tổng quan tài khoản con</h3>

                    <div class="children-grid">
                        <c:forEach var="child" items="${vm.children}">
                            <div class="child-card approved">
                                <div class="child-header">
                                    <div class="child-info">
                                        <h4 class="child-name">Học sinh: ${child.fullName}</h4>
                                        <p class="child-email">Email: ${child.email}</p>
                                    </div>
                                </div>
                                <div class="child-details">
                                    <div class="detail-item">
                                        <span class="detail-label">Khóa học đăng ký:</span>
                                        <span class="detail-value">${child.totalCourses}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Tiến độ học tập:</span>
                                        <span class="detail-value">${child.progress}%</span>
                                    </div>
                                </div>
                                <div class="child-actions">
                                    <a href="${pageContext.request.contextPath}/parent/progress?studentId=${child.studentId}" class="btn primary">Xem tiến độ</a>
                                </div>
                            </div>
                        </c:forEach>


                        <c:if test="${empty vm.children}">
                            <p class="muted">Chưa có tài khoản con nào được liên kết.</p>
                        </c:if>

                    </div>
                    <div style="text-align: right; margin: 30px;">
                        <a href="${pageContext.request.contextPath}/parent/progress" class="btn secondary">Vào trang tiến độ</a>
                    </div>
            </div>


            <!-- PENDING APPROVALS -->
            <div class="analytics-section">
                <h2>Yêu cầu chờ phê duyệt</h2>


                <div class="approval-grid">
                    <c:forEach var="r" items="${vm.pendingApprovals}" begin="0" end="3">
                        <div class="approval-card pending">
                            <div class="course-info">
                                <h4 class="course-title">${r.course.title}</h4>
                                <div class="price-section">
                                    <span class="meta-item">Học phí:</span>
                                    <span class="detail-value">
                                        <fmt:formatNumber value="${r.course.price}" type="currency" currencySymbol="VNĐ " maxFractionDigits="0" />
                                    </span>
                                </div>
                            </div>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/courseInformation?courseId=${r.course.courseId}" class="btn primary" target="_blank">
                                    📖 Xem thông tin khóa học
                                </a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty vm.pendingApprovals}">
                        <p class="muted">Không có yêu cầu nào đang chờ phê duyệt.</p>
                    </c:if>

                    <c:if test="${fn:length(vm.pendingApprovals) > 4}">
                        <div class="muted" style="text-align: center; margin-top: 16px; padding: 16px; background: var(--bg); border-radius: var(--radius); border: 2px dashed var(--border);">
                            <p style="margin: 0; font-weight: 600; color: var(--brand);">
                                📋 Còn ${fn:length(vm.pendingApprovals) - 4} khóa học khác đang chờ phê duyệt
                            </p>
                            <p style="margin: 8px 0 0 0; font-size: 14px;">
                                Nhấn "Xem tất cả" để xem danh sách đầy đủ
                            </p>
                        </div>
                    </c:if>
                </div>
                <div style="text-align: right; margin: 30px;">
                    <a href="${pageContext.request.contextPath}/parent/approvals" class="btn secondary">Vào trang phê duyệt</a>
                </div>
            </div>

            <!-- PENDING PAYMENTS -->
            <div class="analytics-section">
                <h2>Khóa học chờ thanh toán</h2>

                <div class="approval-grid">
                    <c:forEach var="payment" items="${vm.pendingPaymentsList}" begin="0" end="3">
                        <div class="approval-card pending">
                            <div class="course-info">
                                <h4 class="course-title">${payment.course.title}</h4>
                                <div class="course-meta">
                                    <span class="meta-item">Học sinh: ${payment.student.user.fullName}</span>
                                    <span class="meta-item">Email: ${payment.student.user.email}</span>
                                </div>
                                <div class="price-section">
                                    <span class="meta-item">Học phí:</span>
                                    <span class="detail-value">
                                        <fmt:formatNumber value="${payment.course.price}" type="currency" currencySymbol="VNĐ " maxFractionDigits="0" />
                                    </span>
                                </div>
                            </div>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/courseInformation?courseId=${payment.course.courseId}" class="btn primary" target="_blank">
                                    📖 Xem thông tin khóa học
                                </a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty vm.pendingPaymentsList}">
                        <p class="muted">Không có khóa học nào đang chờ thanh toán.</p>
                    </c:if>

                    <c:if test="${fn:length(vm.pendingPaymentsList) > 4}">
                        <div class="muted" style="text-align: center; margin-top: 16px; padding: 16px; background: var(--bg); border-radius: var(--radius); border: 2px dashed var(--border);">
                            <p style="margin: 0; font-weight: 600; color: var(--brand);">
                                💳 Còn ${fn:length(vm.pendingPayments) - 4} khóa học khác đang chờ thanh toán
                            </p>
                            <p style="margin: 8px 0 0 0; font-size: 14px;">
                                Nhấn "Vào trang thanh toán" để xem danh sách đầy đủ
                            </p>
                        </div>
                    </c:if>
                </div>
                <div style="text-align: right; margin: 30px;">
                    <a href="${pageContext.request.contextPath}/parent/payment_items" class="btn secondary">Vào trang thanh toán</a>
                </div>
            </div>


            <!-- PENDING LINK REQUESTS -->
            <div class="analytics-section">
                <h2>Yêu cầu chờ liên kết tài khoản</h2>


                <div class="approval-grid">
                    <c:forEach var="req" items="${vm.linkRequests}" begin="0" end="3">
                        <div class="approval-card pending">
                            <div class="course-info">
                                <h4 class="course-title">Yêu cầu từ học sinh: ${req.student.fullName}</h4>
                                <div class="course-meta">
                                    <span class="meta-item">Email: ${req.student.email}</span>
                                    <span class="meta-item">Ngày gửi: 
                                        <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty vm.linkRequests}">
                        <p class="muted">Không có yêu cầu liên kết nào đang chờ xử lý.</p>
                    </c:if>

                    <c:if test="${fn:length(vm.linkRequests) > 4}">
                        <div class="muted" style="text-align: center; margin-top: 16px; padding: 16px; background: var(--bg); border-radius: var(--radius); border: 2px dashed var(--border);">
                            <p style="margin: 0; font-weight: 600; color: var(--brand);">
                                📋 Còn ${fn:length(vm.linkRequests) - 4} yêu cầu liên kết khác đang chờ xử lý
                            </p>
                            <p style="margin: 8px 0 0 0; font-size: 14px;">
                                Nhấn "Xem tất cả" để xem danh sách đầy đủ
                            </p>
                        </div>
                    </c:if>
                </div>
                <div style="text-align: right; margin: 30px;">
                    <a href="${pageContext.request.contextPath}/parentlinkstudent?filter=pending" class="btn secondary">Vào trang quản lý con</a>
                </div>
            </div>
        </main>

        <jsp:include page="/footer.jsp" />
    </body>
</html>
