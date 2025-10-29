<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý khóa học</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-style.css?v=20' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    </head>
    <body class="dashboard">
        <jsp:include page="includes-manager/sidebar-manager.jsp"/>

        <main class="main-content">
            <div class="container">
                <div class="page-header">
                    <h1 class="page-title">Quản lý khóa học</h1>
                    <p class="page-subtitle">Duyệt, chỉnh giá và xem chi tiết khóa học</p>
                </div>

                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success">${sessionScope.message}</div>
                    <c:remove var="message" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger">${sessionScope.errorMessage}</div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="filter-panel">
                    <form method="get" action="coursemanager" class="filter-form">
                        <div class="filter-grid">
                            <div class="filter-group">
                                <label for="status">Trạng thái</label>
                                <select name="status" id="status">
                                    <option value="all" ${status == 'all' ? 'selected' : ''}>Tất cả</option>
                                    <option value="submitted" ${status == 'submitted' ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="approved" ${status == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                    <option value="rejected" ${status == 'rejected' ? 'selected' : ''}>Từ chối</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="keyword">Từ khóa</label>
                                <input type="text" id="keyword" name="keyword" value="${keyword}" placeholder="Tìm theo tên hoặc giáo viên...">
                            </div>

                            <div class="filter-group">
                                <label for="sort">Sắp xếp</label>
                                <select name="sort" id="sort">
                                    <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="oldest" ${sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="category">Danh mục</label>
                                <select name="categoryId" id="category">
                                    <option value="0" ${categoryId == 0 ? 'selected' : ''}>Tất cả</option>
                                    <c:forEach var="cat" items="${categoryList}">
                                        <option value="${cat.categoryId}" ${categoryId == cat.categoryId ? 'selected' : ''}>
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>


                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary"><i class="fa fa-search"></i> Lọc</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="table-header">
                    <h2 class="table-title">Danh sách khóa học</h2>
                    <div class="bulk-actions">
                        <button form="bulkForm" type="submit" class="btn btwn-success" onclick="return setBulkAction('approve')">
                            <i class="fa fa-check"></i> Duyệt hàng loạt
                        </button>
                        <button type="button" class="btn btn-danger" onclick="return setBulkAction('reject')">
                            <i class="fa fa-times"></i> Từ chối hàng loạt
                        </button>
                    </div>
                </div>

                <table class="table">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)"></th>
                            <th>Khóa học</th>
                            <th>Giáo viên</th>
                            <th>Ngày gửi</th>
                            <th>Trạng thái</th>
                            <th>Giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="course" items="${courseList}" varStatus="loop">
                            <tr>
                                <td><input type="checkbox" name="courseIds" value="${course.courseId}" form="bulkForm"></td>

                                <td>
                                    <div class="course-info">
                                        <img src="${course.thumbnail != null ? course.thumbnail : '/views-manager/icon/default.png'}" class="thumbnail">
                                        <div>
                                            <strong>${course.title}</strong><br>
                                            <small class="muted">${course.category.name}</small>
                                        </div>
                                    </div>
                                </td>
                                
                                <td>
                                    <div class="teacher-info">
                                        <img src="${course.createdBy.user.profilePicture != null ? course.createdBy.user.profilePicture : '/views-manager/icon/default.png'}" class="avatar">
                                        <div>
                                            <strong>${course.createdBy.user.fullName}</strong><br>
                                            <small>${course.createdBy.user.email}</small>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <strong>${createdDateList[loop.index]}</strong><br>
                                    <small class="muted">${createdTimeList[loop.index]}</small>
                                </td>

                                <td><span class="status-badge ${course.status}">${course.status}</span></td>

                                <td>
                                    <form method="post" action="coursemanager" class="price-inline-form" onsubmit="return disableSubmit(this)">
                                        <input type="hidden" name="action" value="setPrice">
                                        <input type="hidden" name="courseId" value="${course.courseId}">
                                        <input type="hidden" name="status" value="${status}">
                                        <input type="hidden" name="keyword" value="${keyword}">
                                        <input type="hidden" name="sort" value="${sort}">
                                        <input type="number" name="price" step="1000" min="0" value="${course.price}" class="price-inline-input" required>
                                        <button type="submit" class="price-inline-btn"><i class="fas fa-save"></i></button>
                                    </form>
                                </td>

                                <td>
                                    <a href="${pageContext.request.contextPath}/coursedetail?courseId=${course.courseId}"
                                       class="btn btn-outline" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <c:choose>
                                        <c:when test="${course.status == 'submitted'}">
                                            <form method="post" action="coursemanager" class="inline" onsubmit="return disableSubmit(this)">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="courseIds" value="${course.courseId}">
                                                <input type="hidden" name="status" value="${status}">
                                                <input type="hidden" name="keyword" value="${keyword}">
                                                <input type="hidden" name="sort" value="${sort}">
                                                <button type="submit" class="btn btn-success"><i class="fas fa-check"></i></button>
                                            </form>
                                            <button type="button" class="btn btn-danger" onclick="openSingleReject('${course.courseId}')">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </c:when>

                                        <c:when test="${course.status == 'approved'}">
                                            <button type="button" class="btn btn-danger" onclick="openSingleReject('${course.courseId}')">
                                                <i class="fas fa-ban"></i>
                                            </button>
                                        </c:when>

                                        <c:when test="${course.status == 'rejected'}">
                                            <form method="post" action="coursemanager" class="inline" onsubmit="return disableSubmit(this)">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="courseIds" value="${course.courseId}">
                                                <input type="hidden" name="status" value="${status}">
                                                <input type="hidden" name="keyword" value="${keyword}">
                                                <input type="hidden" name="sort" value="${sort}">
                                                <button type="submit" class="btn btn-success"><i class="fas fa-rotate"></i></button>
                                            </form>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>

        <form method="post" action="coursemanager" id="bulkForm" style="display:none;">
            <input type="hidden" name="action" id="bulkAction">
            <input type="hidden" name="status" value="${status}">
            <input type="hidden" name="keyword" value="${keyword}">
            <input type="hidden" name="sort" value="${sort}">
        </form>

        <div id="rejectModal" class="modal">
            <div class="modal-content">
                <h3>Nhập lý do từ chối</h3>
                <p id="rejectCount" class="muted"></p>
                <form id="rejectForm" method="post" action="coursemanager" onsubmit="return disableSubmit(this)">
                    <input type="hidden" name="action" id="rejectAction">
                    <input type="hidden" name="courseIds" id="rejectCourseIds">
                    <input type="hidden" name="status" value="${status}">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <input type="hidden" name="sort" value="${sort}">
                    <textarea name="rejectReason" placeholder="Nhập lý do..." required></textarea>
                    <div class="modal-buttons">
                        <button type="submit" class="btn btn-danger">Gửi lý do</button>
                        <button type="button" class="btn btn-secondary" onclick="closeRejectModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleSelectAll(source) {
                document.querySelectorAll('input[name="courseIds"][form="bulkForm"]').forEach(cb => cb.checked = source.checked);
            }
            function setBulkAction(action) {
                const checked = document.querySelectorAll('input[name="courseIds"][form="bulkForm"]:checked');
                if (!checked.length) {
                    alert("Vui lòng chọn ít nhất một khóa học!");
                    return false;
                }
                if (action === 'approve') {
                    document.getElementById('bulkAction').value = 'bulkApprove';
                    document.getElementById('bulkForm').submit();
                    return false;
                }
                if (action === 'reject') {
                    const ids = Array.from(checked).map(cb => cb.value).join(',');
                    openRejectModal('bulkReject', ids);
                    return false;
                }
            }
            function openRejectModal(action, ids) {
                document.getElementById('rejectAction').value = action;
                document.getElementById('rejectCourseIds').value = ids;
                const count = ids.split(',').filter(Boolean).length;
                document.getElementById('rejectCount').textContent =
                        count > 1 ? `Bạn đang từ chối ${count} khóa học.` : `Bạn đang từ chối 1 khóa học.`;
                document.getElementById('rejectModal').style.display = 'flex';
            }
            function openSingleReject(id) {
                openRejectModal('reject', id);
            }
            function closeRejectModal() {
                document.getElementById('rejectModal').style.display = 'none';
            }
            function disableSubmit(form) {
                const btn = form.querySelector('button[type="submit"]');
                if (btn) {
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                }
                return true;
            }
        </script>
    </body>
</html>