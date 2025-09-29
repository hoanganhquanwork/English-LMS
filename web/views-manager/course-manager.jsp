<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý khóa học</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-style.css?v=3' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    </head>
    <body class="dashboard">
        <%@ include file="includes-manager/header-manager.jsp" %>
        <main class="main-content">
            <div class="container">
                <div class="page-header">
                    <h1 class="page-title">Quản lý khóa học</h1>
                    <p class="page-subtitle">Duyệt và quản lý các khóa học được gửi bởi giáo viên</p>
                </div>
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
                                <input type="text" id="keyword" name="keyword" value="${keyword}"
                                       placeholder="Tìm theo tên hoặc giáo viên...">
                            </div>
                            <div class="filter-group">
                                <label for="sort">Sắp xếp</label>
                                <select name="sort" id="sort">
                                    <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="oldest" ${sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                </select>
                            </div>
                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-search"></i> Lọc
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-warning" style="margin: 10px 0; padding: 10px; background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; border-radius: 4px;">
                        ${errorMessage}
                    </div>
                </c:if>
                <form method="post" action="coursemanager" id="bulkForm">
                    <input type="hidden" name="action" id="bulkAction">
                    <div class="table-header">
                        <h2 class="table-title">Danh sách khóa học</h2>
                        <div class="bulk-actions">
                            <button type="submit" class="btn btn-success"
                                    onclick="return setBulkAction('approve')">
                                <i class="fa fa-check"></i> Duyệt hàng loạt
                            </button>
                            <button type="submit" class="btn btn-danger"
                                    onclick="return setBulkAction('reject')">
                                <i class="fa fa-times"></i> Từ chối hàng loạt
                            </button>
                        </div>
                    </div>
                </form>

                <table class="table">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)"></th>
                            <th>Khóa học</th>
                            <th>Giáo viên</th>
                            <th>Ngày gửi</th>
                            <th>Trạng thái</th>
                            <th>Giá tiền</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="course" items="${courseList}" varStatus="loop">
                            <tr>
                                <td>
                                    <input type="checkbox" name="courseIds" value="${course.courseId}" form="bulkForm">
                                </td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <img src="${course.thumbnail != null ? course.thumbnail : '/views-manager/icon/default.png'}"
                                             alt="Course Thumbnail"
                                             style="width: 60px; height: 40px; border-radius: 4px; object-fit: cover;">
                                        <div>
                                            <strong>${course.title}</strong><br>
                                            <small style="color: var(--muted);">${course.category.name}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <img src="${course.createdBy.user.profilePicture != null ? course.createdBy.user.profilePicture : '/views-manager/default.png'}"
                                             alt="Teacher Avatar"
                                             style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                                        <div>
                                            <strong>${course.createdBy.user.fullName}</strong><br>
                                            <small style="color: var(--muted);">${course.createdBy.user.email}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <strong>${createdDateList[loop.index]}</strong><br>
                                    <small style="color: #888;">${createdTimeList[loop.index]}</small>
                                </td>
                                <td>
                                    <span class="status-badge ${course.status}">
                                        ${course.status}
                                    </span>
                                </td>
                                <td>
                                    <form method="post" action="coursemanager" style="display:flex; gap:8px;">
                                        <input type="hidden" name="action" value="setPrice">
                                        <input type="hidden" name="source" value="list">
                                        <input type="hidden" name="courseId" value="${course.courseId}">
                                        <input type="number" name="price" step="1000" min="0"
                                               value="${course.price}"
                                               style="width:100px; padding:4px; border:1px solid var(--border); border-radius: var(--radius);">
                                        <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                    </form>
                                </td>
                                <td>
                                    <a href="coursemanager?action=detail&courseId=${course.courseId}" 
                                       class="btn btn-outline" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <form method="post" action="coursemanager" style="display:inline;">
                                        <input type="hidden" name="courseIds" value="${course.courseId}">
                                        <input type="hidden" name="action" value="approve">
                                        <button type="submit" class="btn btn-success"><i class="fas fa-check"></i></button>
                                    </form>

                                    <form method="post" action="coursemanager" style="display:inline;">
                                        <input type="hidden" name="courseIds" value="${course.courseId}">
                                        <input type="hidden" name="action" value="reject">
                                        <button type="submit" class="btn btn-danger"><i class="fas fa-times"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>

        <script>
            function toggleSelectAll(source) {
                const checkboxes = document.querySelectorAll('input[name="courseIds"][form="bulkForm"]');
                checkboxes.forEach(cb => cb.checked = source.checked);
            }

            function setBulkAction(action) {
                const checked = document.querySelectorAll('input[name="courseIds"][form="bulkForm"]:checked');
                if (checked.length === 0) {
                    alert("Vui lòng chọn ít nhất một khóa học!");
                    return false;
                }
                document.getElementById('bulkAction').value = action;
                return true;
            }
        </script>
    </body>
</html>