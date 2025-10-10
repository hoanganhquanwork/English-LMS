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
        <h2>Phê duyệt yêu cầu đăng ký khóa học</h2>
        <p class="lead">Xem xét và phê duyệt các yêu cầu đăng ký từ con em.</p>

        <!-- Tabs -->
        <div class="filter-tabs">
            <form method="get" action="approvals" style="display:inline;">
                <input type="hidden" name="status" value="pending" />
                <button type="submit"
                        class="filter-btn ${selectedStatus == 'pending' || empty selectedStatus ? 'active' : ''}">
                    Chờ duyệt (${counts['pending'] != null ? counts['pending'] : 0})
                </button>
            </form>

            <form method="get" action="approvals" style="display:inline;">
                <input type="hidden" name="status" value="approved" />
                <button type="submit"
                        class="filter-btn ${selectedStatus == 'approved' ? 'active' : ''}">
                    Đã duyệt (${counts['approved'] != null ? counts['approved'] : 0})
                </button>
            </form>

            <form method="get" action="approvals" style="display:inline;">
                <input type="hidden" name="status" value="rejected" />
                <button type="submit"
                        class="filter-btn ${selectedStatus == 'rejected' ? 'active' : ''}">
                    Đã từ chối (${counts['rejected'] != null ? counts['rejected'] : 0})
                </button>
            </form>
        </div>
    </div>

    <!-- Danh sách yêu cầu -->
    <section class="approval-list">
        <c:choose>
            <c:when test="${empty requests}">
                <p class="muted">Không có yêu cầu nào phù hợp.</p>
            </c:when>

            <c:otherwise>
                <c:forEach var="req" items="${requests}">
                    <div class="approval-card">
                        <div class="card-header">
                            <div class="student-info">
                                <c:choose>
                                    <c:when test="${empty req.student.user.profilePicture}">
                                        <img class="avatar"
                                             src="https://via.placeholder.com/55x55/4f46e5/ffffff?text=HS"
                                             alt="Avatar" />
                                    </c:when>
                                    <c:otherwise>
                                        <img class="avatar"
                                             src="${pageContext.request.contextPath}/${req.student.user.profilePicture}"
                                             alt="Avatar" />
                                    </c:otherwise>
                                </c:choose>

                                <div>
                                    <strong>${req.student.user.fullName}</strong><br />
                                    <span class="muted-text">${req.formattedCreatedAt}</span>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${req.status eq 'pending'}">
                                    <span class="badge urgent">Chờ duyệt</span>
                                </c:when>
                                <c:when test="${req.status eq 'approved'}">
                                    <span class="status-badge active">Đã duyệt</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge rejected">Đã từ chối</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="course-info">
                            <h3>${req.course.title}</h3>
                            <div class="meta">
                                <span>🎓 ${not empty req.student.gradeLevel ? req.student.gradeLevel : 'Không rõ lớp'}</span>
                                <span>🏫 ${not empty req.student.institution ? req.student.institution : 'Không rõ trường'}</span>
                            </div>
                            <div class="price">
                                <strong>
                                    <fmt:formatNumber value="${req.course.price}" type="number" groupingUsed="true" />
                                </strong> VNĐ
                            </div>
                        </div>

                        <c:if test="${not empty req.note}">
                            <div class="reason-box">
                                <h5>Ghi chú:</h5>
                                <p>${req.note}</p>
                            </div>
                        </c:if>

                        <c:if test="${req.status == 'pending'}">
                            <div class="actions">
                                <form method="post" action="approvals" style="display:inline;" class="action-form">
                                    <input type="hidden" name="requestId" value="${req.requestId}" />
                                    <input type="hidden" name="action" value="approved" />
                                    <input type="hidden" name="note" value="" />
                                    <button type="button" class="btn success" onclick="confirmAction(this, 'approve')">
                                        ✓ Phê duyệt
                                    </button>
                                </form>

                                <form method="post" action="approvals" style="display:inline;" class="action-form">
                                    <input type="hidden" name="requestId" value="${req.requestId}" />
                                    <input type="hidden" name="action" value="rejected" />
                                    <input type="hidden" name="note" value="" />
                                    <button type="button" class="btn danger outline" onclick="confirmAction(this, 'reject')">
                                        ✗ Từ chối
                                    </button>
                                </form>
                            </div>
                        </c:if>

                        <c:if test="${req.status == 'approved' && not empty req.formattedDecidedAt}">
                            <p class="link-date">Phê duyệt lúc: ${req.formattedDecidedAt}</p>
                        </c:if>
                        <c:if test="${req.status == 'rejected' && not empty req.formattedDecidedAt}">
                            <p class="link-date">Từ chối lúc: ${req.formattedDecidedAt}</p>
                        </c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>

<script>
    // ✅ Hàm xác nhận duyệt / từ chối (có nhập lý do)
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
