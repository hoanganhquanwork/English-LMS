<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Dashboard quản trị</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-dashboard.css">
    </head>
    <body>

        <nav class="topbar shadow-sm">
            <div class="container-fluid px-4 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <span class="brand-dot"></span>
                    <span class="fw-semibold">Admin Dashboard</span>
                </div>
                <a class="text-decoration-none small text-muted" href="#"><i class="bi bi-box-arrow-right me-1"></i>Đăng xuất</a>
            </div>
        </nav>

        <div class="page">
            <aside class="aside">
                <div class="aside-box">
                    <div class="aside-title">Menu quản trị</div>
                    <a class="aside-item active" href="#">Dashboard</a>
                    <a class="aside-item" href="#">Quản lý User</a>
                </div>
            </aside>

            <main class="main">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h2 class="fw-bold m-0">Dashboard Quản trị</h2>
                    <!--                    <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                            <i class="bi bi-plus-lg me-1"></i> Thêm user
                                        </a>-->

                </div>

                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-people"></i></div>
                            <div>
                                <div class="stat-number">${totalUsers}</div>
                                <div class="stat-label">Tổng số người dùng</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-mortarboard"></i></div>
                            <div>
                                <div class="stat-number">${totalActiveCourses}</div>
                                <div class="stat-label">Khóa học đang hoạt động</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-person-workspace"></i></div>
                            <div>
                                <div class="stat-number">${totalTeachers}</div>
                                <div class="stat-label">Giáo viên</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card card-panel">
                    <div class="card-header bg-white border-0 pt-3 pb-0">
                        <div class="text-center fw-semibold text-muted small mb-3">Quản lý Người dùng</div>
                    </div>
                    <div class="card-body">

                        <form action="<%=ctx%>/AdminUserController" method="get" class="row g-2 mb-3">
                            <input type="hidden" name="action" value="list"/>
                            <input type="hidden" name="size" value="${empty size ? 4 : size}"/>
                            <div class="col-md-3">
                                <select name="role" class="form-select">
                                    <option value="">--Tất cả vai trò--</option>
                                    <option value="Student"    ${param.role=='Student'    ? 'selected' : ''}>Student</option>
                                    <option value="Instructor" ${param.role=='Instructor' ? 'selected' : ''}>Instructor</option>
                                    <option value="Manager"    ${param.role=='Manager'    ? 'selected' : ''}>Manager</option>
                                    <option value="Parent"     ${param.role=='Parent'     ? 'selected' : ''}>Parent</option>
                                    <option value="Admin"      ${param.role=='Admin'      ? 'selected' : ''}>Admin</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select name="status" class="form-select">
                                    <option value="">--Tất cả trạng thái--</option>
                                    <option value="active"      ${param.status=='active'      ? 'selected' : ''}>Active</option>
                                    <option value="deactivated" ${param.status=='deactivated' ? 'selected' : ''}>Deactivated</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <input name="keyword" value="${fn:escapeXml(param.keyword)}"
                                       class="form-control" placeholder="Từ khóa (username/email)"/>
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-filter w-100"><i class="bi bi-funnel me-1"></i>Lọc</button>
                            </div>
                        </form>

                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th style="width:40%">Thông tin</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th class="text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="<%=ctx%>/assets/default-avatar.png" class="avatar me-2" alt="">
                                                    <div>
                                                        <div class="fw-semibold">${u.username}</div>
                                                        <div class="text-muted small">${u.email}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge role-badge">${u.role}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.status == 'active'}">
                                                        <span class="badge status-badge active">HOẠT ĐỘNG</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge status-badge inactive">KHÔNG HOẠT ĐỘNG</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${u.createdAt != null}">
                                                    <fmt:parseDate value="${fn:substring(u.createdAt,0,19)}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="cdt"/>
                                                    <fmt:formatDate value="${cdt}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </td>
                                            <td class="text-end">
                                                <button type="button" class="btn btn-sm btn-outline-primary me-1 editBtn" title="Sửa"
                                                        data-id="${u.userId}">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>

                                                <c:url var="delUrl" value="/AdminUserController">
                                                    <c:param name="action" value="delete"/>
                                                    <c:param name="id" value="${u.userId}"/>
                                                </c:url>
                                                <a href="${delUrl}" class="btn btn-sm btn-outline-danger" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc muốn xóa?');">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr><td colspan="5" class="text-center text-muted py-4">Không có dữ liệu</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-between align-items-center mt-2">
                                <div class="small text-muted">Trang ${page} / ${totalPages}</div>
                                <nav>
                                    <ul class="pagination pagination-sm mb-0">
                                        <c:url var="baseUrl" value="/AdminUserController">
                                            <c:param name="action" value="list"/>
                                            <c:param name="role" value="${param.role}"/>
                                            <c:param name="status" value="${param.status}"/>
                                            <c:param name="keyword" value="${param.keyword}"/>
                                            <c:param name="size" value="${size}"/>
                                        </c:url>
                                        <li class="page-item ${page==1?'disabled':''}">
                                            <a class="page-link" href="${baseUrl}&page=${page-1}">Trước</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${p==page?'active':''}">
                                                <a class="page-link" href="${baseUrl}&page=${p}">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${page==totalPages?'disabled':''}">
                                            <a class="page-link" href="${baseUrl}&page=${page+1}">Sau</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>

                    </div>
                </div>
            </main>
        </div>

        <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <form method="post" action="<%=ctx%>/AdminUserController">
                        <div class="modal-header">
                            <h5 class="modal-title">Chỉnh sửa user</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="id" id="editUserId"/>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Username</label>
                                    <input class="form-control" id="editUsername" name="username" required/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" id="editEmail" name="email" required/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="editPhone" name="phone"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="editDob" name="date_of_birth"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giới tính</label>
                                    <select class="form-select" id="editGender" name="gender">
                                        <option value="">--Chọn--</option>
                                        <option value="male">Nam</option>
                                        <option value="female">Nữ</option>
                                        <option value="other">Khác</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Vai trò</label>
                                    <select class="form-select" id="editRole" name="role">
                                        <option>Student</option><option>Instructor</option>
                                        <option>Manager</option><option>Parent</option><option>Admin</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" id="editStatus" name="status">
                                        <option value="active">Active</option>
                                        <option value="deactivated">Deactivated</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary" type="submit"><i class="bi bi-save me-1"></i>Lưu</button>
                            <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
document.addEventListener('DOMContentLoaded', function () {
    var ctx = '<%=ctx%>';

    document.querySelectorAll('.editBtn').forEach(function (btn) {
        btn.addEventListener('click', async function () {
            var id = btn.getAttribute('data-id');
            try {
                var url = ctx + '/AdminUserController?action=getUserJson&id=' + encodeURIComponent(id);
                var res = await fetch(url, {headers: {'Accept': 'application/json'}});
                if (!res.ok)
                    throw new Error('HTTP ' + res.status);

                var u = await res.json();
                document.getElementById('editUserId').value = u.userId || '';
                document.getElementById('editUsername').value = u.username || '';
                document.getElementById('editEmail').value = u.email || '';
                document.getElementById('editRole').value = u.role || 'Student';
                document.getElementById('editStatus').value = u.status || 'active';

                document.getElementById('editPhone').value = u.phone || '';
                document.getElementById('editDob').value = u.dateOfBirth || '';
                document.getElementById('editGender').value = u.gender || '';

                new bootstrap.Modal(document.getElementById('editUserModal')).show();
            } catch (e) {
                alert('Không tải được dữ liệu user: ' + e.message);
            }
        });
    });
});

        </script>   
    </body>
</html>
