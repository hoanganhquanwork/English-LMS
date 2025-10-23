<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN" />

<%
    request.setAttribute("currentPage", "approvals");
%>

<%@ include file="parent_header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

<main class="container">
    <div class="page-title">
        <h2>📋 Phê duyệt yêu cầu đăng ký khóa học</h2>
        <p class="lead">Xem xét và phê duyệt các yêu cầu đăng ký từ con em.</p>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-section">
        <div class="filter-tabs">
            <form method="get" action="approvals" class="filter-form">
                <input type="hidden" name="status" value="pending" />
                <button type="submit"
                        class="filter-btn ${selectedStatus == 'pending' || empty selectedStatus ? 'active' : ''}">
                    <span class="filter-icon">⏳</span>
                    <span class="filter-text">Chờ duyệt</span>
                    <span class="filter-count">(${counts['pending'] != null ? counts['pending'] : 0})</span>
                </button>
            </form>

            <form method="get" action="approvals" class="filter-form">
                <input type="hidden" name="status" value="approved" />
                <button type="submit"
                        class="filter-btn ${selectedStatus == 'approved' ? 'active' : ''}">
                    <span class="filter-icon">✅</span>
                    <span class="filter-text">Đã duyệt</span>
                    <span class="filter-count">(${counts['approved'] != null ? counts['approved'] : 0})</span>
                </button>
            </form>

            <form method="get" action="approvals" class="filter-form">
                <input type="hidden" name="status" value="rejected" />
                <button type="submit"
                        class="filter-btn ${selectedStatus == 'rejected' ? 'active' : ''}">
                    <span class="filter-icon">❌</span>
                    <span class="filter-text">Đã từ chối</span>
                    <span class="filter-count">(${counts['rejected'] != null ? counts['rejected'] : 0})</span>
                </button>
            </form>
        </div>
    </div>

    <!-- Danh sách yêu cầu -->
    <section class="approval-list">
        <c:choose>
            <c:when test="${empty requests}">
                <div class="empty-state">
                    <div class="empty-icon">📭</div>
                    <h3>Không có yêu cầu nào phù hợp</h3>
                    <p>Hiện tại không có yêu cầu nào trong trạng thái này.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="approval-grid">
                    <c:forEach var="req" items="${requests}">
                        <div class="approval-card ${req.status}">
                            <div class="card-header">
                                <div class="student-info">
                                    <c:choose>
                                        <c:when test="${empty req.student.user.profilePicture}">
                                            <img class="avatar"
                                                 src="https://via.placeholder.com/60x60/4f46e5/ffffff?text=HS"
                                                 alt="Avatar" />
                                        </c:when>
                                        <c:otherwise>
                                            <img class="avatar"
                                                 src="${pageContext.request.contextPath}/${req.student.user.profilePicture}"
                                                 alt="Avatar" />
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="student-details">
                                        <h4 class="student-name">${req.student.user.fullName}</h4>
                                        <p class="request-date">📅 ${req.formattedCreatedAt}</p>
                                    </div>
                                </div>

                                <div class="status-container">
                                    <c:choose>
                                        <c:when test="${req.status eq 'pending'}">
                                            <span class="status-badge pending">⏳ Chờ duyệt</span>
                                        </c:when>
                                        <c:when test="${req.status eq 'approved'}">
                                            <span class="status-badge active">✅ Đã duyệt</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge rejected">❌ Đã từ chối</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="course-info">
                                <h3 class="course-title">${req.course.title}</h3>
                                <div class="course-meta">
                                    <span class="meta-item">🎓 ${not empty req.student.gradeLevel ? req.student.gradeLevel : 'Không rõ lớp'}</span>
                                    <span class="meta-item">🏫 ${not empty req.student.institution ? req.student.institution : 'Không rõ trường'}</span>
                                </div>
                                <div class="price-section">
                                    <span class="price-label">Giá khóa học:</span>
                                    <span class="price-value">
                                        <fmt:formatNumber value="${req.course.price}" type="number" groupingUsed="true" /> VNĐ
                                    </span>
                                </div>
                            </div>

                            <c:if test="${not empty req.note}">
                                <div class="reason-box">
                                    <h5>📝 Ghi chú:</h5>
                                    <p>${req.note}</p>
                                </div>
                            </c:if>

                            <c:if test="${req.status == 'pending'}">
                                <div class="action-buttons">
                                    <form method="post" action="approvals" class="action-form">
                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                        <input type="hidden" name="action" value="approved" />
                                        <input type="hidden" name="note" value="" />
                                        <button type="button" class="approve-btn" onclick="confirmAction(this, 'approve')">
                                            <span class="btn-icon">✅</span>
                                            <span class="btn-text">Phê duyệt</span>
                                        </button>
                                    </form>

                                    <form method="post" action="approvals" class="action-form">
                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                        <input type="hidden" name="action" value="rejected" />
                                        <input type="hidden" name="note" value="" />
                                        <button type="button" class="reject-btn" onclick="confirmAction(this, 'reject')">
                                            <span class="btn-icon">❌</span>
                                            <span class="btn-text">Từ chối</span>
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <c:if test="${req.status == 'approved' && not empty req.formattedDecidedAt}">
                                <div class="decision-info">
                                    <span class="decision-label">✅ Phê duyệt lúc:</span>
                                    <span class="decision-date">${req.formattedDecidedAt}</span>
                                </div>
                            </c:if>
                            <c:if test="${req.status == 'rejected' && not empty req.formattedDecidedAt}">
                                <div class="decision-info">
                                    <span class="decision-label">❌ Từ chối lúc:</span>
                                    <span class="decision-date">${req.formattedDecidedAt}</span>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>


<script>
    function confirmAction(button, type) {
        let message = '';
        let requireReason = false;

        if (type === 'approve') {
            message = 'Bạn có chắc chắn muốn PHÊ DUYỆT yêu cầu này không?';
        } else if (type === 'reject') {
            message = 'Vui lòng nhập lý do từ chối:';
            requireReason = true;
        }

        let note = '';
        if (requireReason) {
            note = prompt(message);
            if (note === null || note.trim() === '') {
                alert('Bạn phải nhập lý do để từ chối!');
                return;
            }
        } else {
            if (!confirm(message)) return;
        }

        const form = button.closest('form');
        form.querySelector('input[name="note"]').value = note;
        form.submit();
    }
</script>

<footer>
        <jsp:include page="/footer.jsp" />
</footer>
