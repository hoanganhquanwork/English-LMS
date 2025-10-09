<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Đánh dấu tab "Quản lý con" đang active
    request.setAttribute("currentPage", "children");
%>

<%@ include file="parent_header.jsp" %>
<link rel="stylesheet" href="css/parent_link_approval.css" />

<main class="container">
    <div class="page-title">
        <h2>Quản lý tài khoản liên kết</h2>
        <p class="lead">Liên kết và quản lý tài khoản học sinh của bạn.</p>

        <div class="filter-tabs">
            <form method="get" action="parentlinkstudent" style="display:inline;">
                <input type="hidden" name="filter" value="approved" />
                <button type="submit"
                        class="filter-btn ${param.filter == 'approved' || empty param.filter ?  'active' : ''}">
                    Đã kết nối (${approvedCount})
                </button>
            </form>

            <form method="get" action="parentlinkstudent" style="display:inline;">
                <input type="hidden" name="filter" value="pending" />
                <button type="submit"
                        class="filter-btn ${param.filter == 'pending' ? 'active' : ''}">
                    Chờ duyệt (${pendingCount})
                </button>
            </form>

            <form method="get" action="parentlinkstudent" style="display:inline;">
                <input type="hidden" name="filter" value="closed" />
                <button type="submit"
                        class="filter-btn ${param.filter == 'closed' ? 'active' : ''}">
                    Đã hủy / Từ chối (${closedCount})
                </button>
            </form>
        </div>
    </div>

    <div class="children-list">
        <c:choose>
            <c:when test="${empty requests}">
                <div class="empty-message">
                    <c:choose>
                        <c:when test="${filter eq 'approved'}">Hiện chưa có liên kết nào được duyệt.</c:when>
                        <c:when test="${filter eq 'closed'}">Chưa có yêu cầu bị hủy hoặc từ chối.</c:when>
                        <c:otherwise>Không có yêu cầu đang chờ duyệt.</c:otherwise>
                    </c:choose>
                </div>
            </c:when>

            <c:otherwise>
                <c:forEach var="r" items="${requests}">
                    <div class="child-item">
                        <div class="child-header">
                            <div class="child-avatar">
                                <img src="${empty r.student.profilePicture 
                                            ? 'https://via.placeholder.com/80x80/ccc/ffffff?text=HS' 
                                            : r.student.profilePicture}" 
                                     alt="Avatar" />
                            </div>

                            <div class="child-basic-info">
                                <h3>${r.student.fullName}</h3>
                                <p class="child-email">Email: ${r.student.email}</p>
                                <p class="child-details">Mã HS: ${r.studentId}</p>
                            </div>

                            <div class="child-status">
                                <c:choose>
                                    <c:when test="${r.status eq 'approved'}">
                                        <span class="status-badge active">Đang hoạt động</span>
                                        <p class="link-date">Liên kết từ:
                                            <fmt:formatDate value="${r.decidedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </c:when>

                                    <c:when test="${r.status eq 'pending'}">
                                        <span class="status-badge pending">Chờ xác nhận</span>
                                        <p class="link-date">Yêu cầu liên kết:
                                            <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </c:when>

                                    <c:when test="${r.status eq 'canceled'}">
                                        <span class="status-badge canceled">Đã hủy liên kết</span>
                                        <p class="link-date">Hủy lúc:
                                            <fmt:formatDate value="${r.decidedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </c:when>

                                    <c:when test="${r.status eq 'rejected'}">
                                        <span class="status-badge rejected">Đã từ chối</span>
                                        <p class="link-date">Từ chối lúc:
                                            <fmt:formatDate value="${r.decidedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </c:when>
                                </c:choose>

                                <c:if test="${not empty r.note}">
                                    <p class="note">Lý do: ${r.note}</p>
                                </c:if>
                            </div>
                        </div>

                        <div class="child-actions">
                            <c:if test="${r.status eq 'pending'}">
                                <form method="post" action="parentlinkstudent" class="action-form" style="display:inline;">
                                    <input type="hidden" name="requestId" value="${r.requestId}" />
                                    <input type="hidden" name="action" value="approve" />
                                    <input type="hidden" name="note" value="" />
                                    <button type="button" class="btn success" onclick="confirmAction(this, 'approve')">
                                        Xác nhận liên kết
                                    </button>
                                </form>

                                <form method="post" action="parentlinkstudent" class="action-form" style="display:inline;">
                                    <input type="hidden" name="requestId" value="${r.requestId}" />
                                    <input type="hidden" name="action" value="reject" />
                                    <input type="hidden" name="note" value="" />
                                    <button type="button" class="btn danger outline" onclick="confirmAction(this, 'reject')">
                                        Từ chối
                                    </button>
                                </form>
                            </c:if>

                            <c:if test="${r.status eq 'approved'}">
                                <form method="post" action="parentlinkstudent" class="action-form" style="display:inline;">
                                    <input type="hidden" name="requestId" value="${r.requestId}" />
                                    <input type="hidden" name="action" value="cancel" />
                                    <input type="hidden" name="note" value="" />
                                    <button type="button" class="btn danger outline" onclick="confirmAction(this, 'cancel')">
                                        Hủy liên kết
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<footer class="footer">
    <div class="container bottom">© 2025 LinguaTrack</div>
</footer>

<script>
    function toggleUserDropdown() {
        const dropdown = document.getElementById('userDropdown');
        const avatarBtn = document.querySelector('.avatar-btn');
        dropdown.classList.toggle('show');
        avatarBtn.classList.toggle('active');
    }

    window.onclick = function (event) {
        const dropdown = document.getElementById('userDropdown');
        const avatarBtn = document.querySelector('.avatar-btn');
        if (!event.target.closest('.user-dropdown')) {
            dropdown.classList.remove('show');
            avatarBtn.classList.remove('active');
        }
    };

    // ✅ Hộp thoại xác nhận & nhập lý do
    function confirmAction(button, actionType) {
        let message = '';
        let needReason = false;

        if (actionType === 'approve') {
            message = 'Bạn có chắc chắn muốn xác nhận liên kết này không?';
        } else if (actionType === 'reject') {
            message = 'Vui lòng nhập lý do từ chối:';
            needReason = true;
        } else if (actionType === 'cancel') {
            message = 'Vui lòng nhập lý do hủy liên kết:';
            needReason = true;
        }

        let note = '';
        if (needReason) {
            note = prompt(message);
            if (note === null || note.trim() === '') {
                alert('Bạn phải nhập lý do để thực hiện hành động này!');
                return;
            }
        } else {
            if (!confirm(message)) return;
        }

        // Gán lý do vào input hidden và submit form
        const form = button.closest('form');
        form.querySelector('input[name="note"]').value = note;
        form.submit();
    }
</script>
