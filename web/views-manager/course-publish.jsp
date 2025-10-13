<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Lịch đăng khóa học</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-style.css?v=63' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    </head>

    <body class="dashboard">
        <jsp:include page="includes-manager/sidebar-manager.jsp" />

        <main class="main-content">
            <div class="container">
                <div class="page-header">
                    <h1 class="page-title">Lịch đăng khóa học</h1>
                    <p class="page-subtitle">
                        Quản lý trạng thái khóa học đã duyệt, đăng và gỡ đăng
                    </p>
                </div>

                <div class="filter-panel">
                    <form method="get" action="coursepublish" class="filter-form">
                        <div class="filter-grid">
                            <div class="filter-group">
                                <label for="status">Trạng thái</label>
                                <select name="status" id="status">
                                    <option value="all" ${status == 'all' ? 'selected' : ''}>Tất cả</option>
                                    <option value="approved" ${status == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                    <option value="publish" ${status == 'publish' ? 'selected' : ''}>Đã đăng</option>
                                    <option value="unpublish" ${status == 'unpublish' ? 'selected' : ''}>Đã gỡ đăng</option>
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
                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-search"></i> Lọc
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>

                <table class="table">
                    <thead>
                        <tr>
                            <th>Khóa học</th>
                            <th>Giáo viên</th>
                            <th>Ngày duyệt</th>
                            <th>Trạng thái</th>
                            <th>Giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="course" items="${courseList}" varStatus="loop">
                            <tr>
                                <td>
                                    <div class="course-info">
                                        <img src="${course.thumbnail != null ? course.thumbnail : '/views-manager/icon/default.png'}"
                                             alt="Thumbnail" class="thumbnail">
                                        <div>
                                            <strong>${course.title}</strong><br>
                                            <small class="muted">${course.category.name}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="teacher-info">
                                        <img src="${course.createdBy.user.profilePicture != null ? course.createdBy.user.profilePicture : '/views-manager/icon/default.png'}"
                                             alt="Avatar" class="avatar">
                                        <div>
                                            <strong>${course.createdBy.user.fullName}</strong><br>
                                            <small class="muted">${course.createdBy.user.email}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <strong>${createdDateList[loop.index]}</strong><br>
                                    <small class="muted">${createdTimeList[loop.index]}</small>
                                </td>
                                <td><span class="status-badge ${course.status}">${course.status}</span></td>
                                <td>${course.price}</td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/coursedetail?courseId=${course.courseId}" 
                                           class="btn btn-outline" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <c:choose>
                                            <c:when test="${course.status == 'approved'}">
                                                <form method="post" action="coursepublish" style="display:inline;">
                                                    <input type="hidden" name="courseIds" value="${course.courseId}">
                                                    <input type="hidden" name="action" value="publish">
                                                    <button type="submit" class="btn btn-primary" title="Đăng ngay">
                                                        <i class="fas fa-upload"></i>
                                                    </button>
                                                </form>
                                                <button type="button" class="btn btn-secondary" title="Đặt lịch đăng"
                                                        onclick="openScheduleModal(${course.courseId})">
                                                    <i class="fas fa-calendar-alt"></i>
                                                </button>
                                            </c:when>
                                            <c:when test="${course.status == 'publish'}">
                                                <form method="post" action="coursepublish" style="display:inline;">
                                                    <input type="hidden" name="courseIds" value="${course.courseId}">
                                                    <input type="hidden" name="action" value="unpublish">
                                                    <button type="submit" class="btn btn-danger" title="Gỡ đăng khóa học">
                                                        <i class="fas fa-download"></i>
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${course.status == 'unpublish'}">
                                                <form method="post" action="coursepublish" style="display:inline;">
                                                    <input type="hidden" name="courseIds" value="${course.courseId}">
                                                    <input type="hidden" name="action" value="republish">
                                                    <button type="submit" class="btn btn-success" title="Đăng lại khóa học">
                                                        <i class="fas fa-rotate-right"></i>
                                                    </button>
                                                </form>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div id="scheduleModal" class="modal">
                <div class="modal-content">
                    <h3>Chọn ngày đăng</h3>
                    <form method="post" action="coursepublish" id="scheduleForm">
                        <input type="hidden" name="action" value="schedule">
                        <input type="hidden" name="courseIds" id="scheduleCourseId">
                        <input type="date" name="publishDate" required>
                        <div class="modal-buttons">
                            <button type="submit" class="btn btn-primary">Lưu</button>
                            <button type="button" class="btn btn-secondary" onclick="closeScheduleModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <script>
            function openScheduleModal(id) {
                document.getElementById("scheduleCourseId").value = id;
                document.getElementById("scheduleModal").style.display = "flex";
            }
            function closeScheduleModal() {
                document.getElementById("scheduleModal").style.display = "none";
            }
            setTimeout(() => {
                document.querySelectorAll('.alert').forEach(a => a.remove());
            }, 3000);
        </script>
    </body>
</html>