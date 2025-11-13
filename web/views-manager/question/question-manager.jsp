<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Ngân hàng câu hỏi — EnglishLMS Manager</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="<c:url value='/css/manager-question.css?v=514' />">
    </head>
    <body>
        <jsp:include page="../includes-manager/sidebar-manager.jsp" />

        <main>
            <h2>Ngân hàng câu hỏi</h2>

            <c:if test="${not empty sessionScope.message}">
                <div class="alert success">${sessionScope.message}</div>
                <c:remove var="message" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert error">${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <form method="get" action="question-manager" class="filter-bar">
                <div class="search-box">
                    <input type="text" name="keyword" placeholder="Tìm nội dung câu hỏi..." value="${param.keyword}">
                </div>
                <div class="filters">
                    <select name="status">
                        <option value="all" ${param.status == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="submitted" ${param.status == 'submitted' ? 'selected' : ''}>Submitted</option>
                        <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                        <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                        <option value="archived" ${param.status == 'archived' ? 'selected' : ''}>Archived</option>
                    </select>
                    <select name="type">
                        <option value="all" ${param.type == 'all' ? 'selected' : ''}>Tất cả loại</option>
                        <option value="mcq_single" ${param.type == 'mcq_single' ? 'selected' : ''}>Trắc nghiệm</option>
                        <option value="text" ${param.type == 'text' ? 'selected' : ''}>Tự luận</option>
                    </select>
                    <select name="topicId">
                        <option value="all" ${param.topicId == 'all' ? 'selected' : ''}>Tất cả chủ đề</option>
                        <c:forEach var="t" items="${topics}">
                            <option value="${t.topicId}" ${param.topicId eq t.topicId.toString() ? 'selected' : ''}>${t.name}</option>
                        </c:forEach>
                    </select>
                    <div class="instructor-search">
                        <input type="text" id="instructorInput" name="instructor"
                               placeholder="Tên giảng viên..."
                               value="${param.instructor}" autocomplete="off">
                        <div id="instructorSuggest" class="suggest-box"></div>
                    </div>
                    <button class="btn btn-approve" type="submit"><i class="fa fa-search"></i></button>
                </div>
            </form>

            <form method="post" action="question-manager" id="bulkForm">
                <div class="bulk-actions">
                    <button type="button" class="btn btn-success" onclick="return setBulkAction('approved')">
                        <i class="fa fa-check"></i> Duyệt hàng loạt
                    </button>
                    <button type="button" class="btn btn-danger" onclick="return setBulkAction('rejected')">
                        <i class="fa fa-times"></i> Từ chối hàng loạt
                    </button>
                </div>

                <table id="questionTable">
                    <thead>
                        <tr>
                            <th><input type="checkbox" onclick="toggleSelectAll(this)"></th>
                            <th>ID</th>
                            <th>Nội dung</th>
                            <th>Loại</th>
                            <th>Chủ đề</th>
                            <th>Giảng viên</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>

                        <c:if test="${empty questions}">
                            <tr>
                                <td colspan="8" style="text-align:center; color:#777; padding:16px;">
                                    Không có câu hỏi nào được tạo bởi giảng viên này.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="q" items="${questions}">
                            <tr>
                                <td><input type="checkbox" name="questionIds" value="${q.questionId}" form="bulkForm"></td>
                                <td>${q.questionId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fn:length(q.content) > 150}">
                                            ${fn:substring(q.content, 0, 150)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${q.content}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.type eq 'mcq_single'}">Trắc nghiệm</c:when>
                                        <c:when test="${q.type eq 'text'}">Tự luận</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${empty q.topicName ? '-' : q.topicName}</td>
                                <td>${q.instructorName}</td>
                                <td><span class="status ${q.status}">${q.status}</span></td>
                                <td>
                                    <button type="button" class="btn btn-view" onclick="openDetail(${q.questionId})">
                                        <i class="fa fa-eye"></i>
                                    </button>
                                    <c:choose>
                                        <c:when test="${q.status eq 'submitted'}">
                                            <button type="submit" class="btn btn-approve" name="action" value="approved"
                                                    onclick="addHidden(this.form, 'questionId', ${q.questionId}); return confirmAction(${q.questionId}, 'approved')">
                                                <i class="fa fa-check"></i>
                                            </button>
                                            <button type="button" class="btn btn-reject" onclick="openReject(${q.questionId})">
                                                <i class="fa fa-times"></i>
                                            </button>
                                        </c:when>
                                        <c:when test="${q.status eq 'approved'}">
                                            <button type="submit" class="btn btn-archive" name="action" value="archived"
                                                   onclick="addHidden(this.form, 'questionIds', ${q.questionId}); return confirmAction(${q.questionId}, 'archived')">
                                                <i class="fa fa-box-archive"></i>
                                            </button>
                                        </c:when>
                                        <c:when test="${q.status eq 'rejected'}">
                                        </c:when>
                                        <c:when test="${q.status eq 'rejected' || q.status eq 'archived'}">
                                            <button type="submit" class="btn btn-approve" name="action" value="restore"
                                                      onclick="addHidden(this.form, 'questionIds', ${q.questionId}); return confirmAction(${q.questionId}, 'restore')">
                                                <i class="fa fa-check"></i>
                                            </button>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </form>

            <div id="rejectModal" class="modal">
                <div class="modal-content">
                    <h3>Lý do từ chối</h3>
                    <textarea id="rejectReason" rows="3" placeholder="Nhập lý do từ chối..."></textarea>
                    <div class="modal-buttons">
                        <button class="btn btn-reject" onclick="submitReject()">Xác nhận</button>
                        <button class="btn btn-approve" onclick="closeReject()">Hủy</button>
                    </div>
                </div>
            </div>

            <div id="detailModal" class="modal">
                <div class="modal-content large">
                    <h3>Chi tiết câu hỏi</h3>
                    <div id="questionDetailBody" class="detail-body"></div>
                    <div class="modal-buttons">
                        <button class="btn btn-approve" onclick="closeDetail()">Đóng</button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            let rejectId = null;

            function openReject(id) {
                rejectId = id;
                document.getElementById('rejectModal').style.display = 'flex';
            }

            function closeReject() {
                rejectId = null;
                document.getElementById('rejectModal').style.display = 'none';
            }

            function submitReject() {
                const reason = document.getElementById('rejectReason').value.trim();
                if (!reason)
                    return alert('Vui lòng nhập lý do từ chối!');
                const form = document.getElementById('bulkForm');
                addHidden(form, 'questionIds', rejectId);
                addHidden(form, 'action', 'rejected');
                addHidden(form, 'reason', reason);
                form.submit();
            }

            function confirmAction(id, action) {
                return confirm('Xác nhận thực hiện hành động "' + action + '" cho câu hỏi #' + id + '?');
            }

            function addHidden(form, name, value) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }

            function openDetail(id) {
                fetch('question-manager?action=detail&id=' + id)
                        .then(r => r.text())
                        .then(html => {
                            document.getElementById('questionDetailBody').innerHTML = html;
                            document.getElementById('detailModal').style.display = 'flex';
                        });
            }

            function closeDetail() {
                document.getElementById('detailModal').style.display = 'none';
            }

            function toggleSelectAll(source) {
                document.querySelectorAll('input[name="questionIds"][form="bulkForm"]').forEach(cb => cb.checked = source.checked);
            }

            function setBulkAction(action) {
                const checked = document.querySelectorAll('input[name="questionIds"][form="bulkForm"]:checked');
                if (!checked.length) {
                    alert("Vui lòng chọn ít nhất một câu hỏi!");
                    return false;
                }

                const form = document.getElementById('bulkForm');
                form.querySelectorAll('input[type="hidden"][name="questionIds"]').forEach(e => e.remove());
                checked.forEach(cb => addHidden(form, 'questionIds', cb.value));

                if (action === 'approved') {
                    if (confirm(`Xác nhận duyệt ${checked.length} câu hỏi đã chọn?`)) {
                        addHidden(form, 'action', 'bulkApprove');
                        form.submit();
                    }
                    return false;
                }

                if (action === 'rejected') {
                    rejectId = Array.from(checked).map(cb => cb.value);
                    document.getElementById('rejectModal').style.display = 'flex';
                    return false;
                }
            }



            const ctx = '<%= request.getContextPath() %>';
            const input = document.getElementById('instructorInput');
            const suggestBox = document.getElementById('instructorSuggest');
            let debounceTimer = null;

            input.addEventListener('input', () => {
                const q = input.value.trim();
                clearTimeout(debounceTimer);

                if (!q) {
                    suggestBox.style.display = 'none';
                    return;
                }

                debounceTimer = setTimeout(() => {
                    fetch(ctx + '/question-manager?action=instructor-suggest&q=' + encodeURIComponent(q))
                            .then(response => {
                                if (!response.ok)
                                    throw new Error('Network response was not ok');
                                return response.text();
                            })
                            .then(html => {
                                suggestBox.innerHTML = html;
                                suggestBox.style.display = 'block';
                                suggestBox.querySelectorAll('.suggest-item').forEach(item => {
                                    item.addEventListener('click', () => {
                                        input.value = item.textContent;
                                        suggestBox.style.display = 'none';
                                    });
                                });
                            })
                            .catch(error => {
                                console.error('Fetch error:', error);
                                suggestBox.innerHTML = "<div class='suggest-item muted'>Không thể tải gợi ý</div>";
                                suggestBox.style.display = 'block';
                            });
                }, 300);
            });

            document.addEventListener('click', (e) => {
                if (!suggestBox.contains(e.target) && e.target !== input) {
                    suggestBox.style.display = 'none';
                }
            });

        </script>
    </body>
</html>
