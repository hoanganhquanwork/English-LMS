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
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
    </head>
    <body>

        <nav class="topbar shadow-sm">
            <div class="container-fluid px-4 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <span class="brand-dot"></span>
                    <span class="fw-semibold">Admin Dashboard</span>
                </div>
                <a class="text-decoration-none small text-muted"
                   href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Đăng xuất
                </a>


            </div>
        </nav>

        <div class="page">
            <aside class="aside">
                <div class="aside-box">
                    <div class="aside-title">Menu quản trị</div>
                    <a class="aside-item active" href="#">Quản lí Users</a>
                </div>
            </aside>

            <main class="main">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h2 class="fw-bold m-0">Dashboard Quản trị</h2>

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
                            <div class="stat-icon"><i class="bi bi-person-check"></i></div>
                            <div>
                                <div class="stat-number">${totalActiveUsers}</div>
                                <div class="stat-label">Tài khoản hoạt động</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-person-x"></i></div>
                            <div>
                                <div class="stat-number">${totalDeactivatedUsers}</div>
                                <div class="stat-label">Tài khoản bị vô hiệu hóa</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card card-panel">
                    <div class="card-header bg-white border-0 pt-3 pb-0">
                        <div class="text-center fw-semibold text-muted small mb-3">Quản lý Người dùng</div>
                    </div>
                    <div class="card-body">

                        <form action="<%=ctx%>/AdminUserList" method="get" class="row g-2 mb-3">
                           
                            <c:choose>
                                <c:when test="${not empty param.role or not empty param.status or not empty param.keyword}">
                                     <div class="col-md-2">
                                <select name="size" class="form-select">
                                    <option value="10">Phân trang</option>
                                    <option value="20" ${size=='20' ? 'selected' : ''}>20 kết quả mỗi trang</option>
                                    <option value="30" ${size=='30' ? 'selected' : ''}>30 kết quả mỗi trang</option>
                                    <option value="40" ${size=='40' ? 'selected' : ''}>40 kết quả mỗi trang</option>
                                    <option value="50" ${size=='50' ? 'selected' : ''}>50 kết quả mỗi trang</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="role" class="form-select">
                                    <option value="">Vai trò</option>
                                    <c:forEach var="role" items="${availableRoles}">
                                        <option value="${role}" ${param.role == role ? 'selected' : ''}>${role}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="status" class="form-select">
                                    <option value="">Trạng thái</option>
                                    <option value="active" ${param.status=='active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="deactivated" ${param.status=='deactivated' ? 'selected' : ''}>Vô hiệu hóa</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input name="keyword" value="${fn:escapeXml(param.keyword)}"
                                       class="form-control" placeholder="Từ khóa (username/email)"/>
                            </div>
                                    <div class="col-md-2">
                                        <button class="btn btn-filter w-100" type="submit">
                                            <i class="bi bi-funnel me-1"></i>Lọc
                                        </button>
                                    </div>
                                    <div class="col-md-2">
                                        <a href="<%=ctx%>/AdminUserList" class="btn btn-outline-secondary w-100">
                                            <i class="bi bi-x-circle me-1"></i> Xóa bộ lọc
                                        </a>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                     <div class="col-md-2">
                                <select name="size" class="form-select">
                                    <option value="10">Phân trang</option>
                                    <option value="20" ${size=='20' ? 'selected' : ''}>20 kết quả mỗi trang</option>
                                    <option value="30" ${size=='30' ? 'selected' : ''}>30 kết quả mỗi trang</option>
                                    <option value="40" ${size=='40' ? 'selected' : ''}>40 kết quả mỗi trang</option>
                                    <option value="50" ${size=='50' ? 'selected' : ''}>50 kết quả mỗi trang</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="role" class="form-select">
                                    <option value="">Vai trò</option>
                                    <c:forEach var="role" items="${availableRoles}">
                                        <option value="${role}" ${param.role == role ? 'selected' : ''}>${role}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="status" class="form-select">
                                    <option value="">Trạng thái</option>
                                    <option value="active" ${param.status=='active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="deactivated" ${param.status=='deactivated' ? 'selected' : ''}>Vô hiệu hóa</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <input name="keyword" value="${fn:escapeXml(param.keyword)}"
                                       class="form-control" placeholder="Từ khóa (username/email)"/>
                            </div>
                                    <div class="col-md-2">
                                        <button class="btn btn-filter w-100" type="submit">
                                            <i class="bi bi-funnel me-1"></i>Lọc
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>

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
                                                        <span class="badge status-badge inactive">VÔ HIỆU HÓA</span>
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
                                                <button type="button" class="btn btn-sm btn-outline-primary me-1 editBtn" 
                                                        title="Sửa" data-id="${u.userId}">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>

                                                <c:choose>
                                                    <c:when test="${u.status == 'active'}">
                                                        <a href="<%=ctx%>/AdminUserStatus?id=${u.userId}&action=deactivate" 
                                                           class="btn btn-sm btn-outline-warning" title="Vô hiệu hóa"
                                                           onclick="return confirm('Bạn có chắc muốn vô hiệu hóa tài khoản này?');">
                                                            <i class="bi bi-pause-circle"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="<%=ctx%>/AdminUserStatus?id=${u.userId}&action=activate" 
                                                           class="btn btn-sm btn-outline-success" title="Kích hoạt"
                                                           onclick="return confirm('Bạn có chắc muốn kích hoạt tài khoản này?');">
                                                            <i class="bi bi-play-circle"></i>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
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
                                        <c:url var="baseUrl" value="/AdminUserList">
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

        <!-- Edit User Modal -->
        <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <form id="editUserForm" method="post" action="<%=ctx%>/AdminUserEdit">
                        <div class="modal-header">
                            <h5 class="modal-title">Chỉnh sửa người dùng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
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
                                        <c:forEach var="role" items="${availableRoles}">
                                            <option value="${role}">${role}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" id="editStatus" name="status" required>
                                        <option value="active">Hoạt động</option>
                                        <option value="deactivated">Vô hiệu hóa</option>
                                    </select>
                                    <div class="form-text">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Chọn "Vô hiệu hóa" để tạm dừng tài khoản thay vì xóa vĩnh viễn
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary" type="submit">
                                <i class="bi bi-save me-1"></i>Lưu thay đổi
                            </button>
                            <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Hidden iframe for loading user data -->
        <iframe id="hiddenFrame" name="hiddenFrame" style="display: none;"></iframe>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                               document.addEventListener('DOMContentLoaded', function () {
                                                                   var ctx = '<%=ctx%>';
                                                                   var editModal = new bootstrap.Modal(document.getElementById('editUserModal'));

                                                                   // Handle edit button clicks
                                                                   document.querySelectorAll('.editBtn').forEach(function (btn) {
                                                                       btn.addEventListener('click', function () {
                                                                           var userId = btn.getAttribute('data-id');

                                                                           // Show loading state
                                                                           btn.innerHTML = '<i class="bi bi-hourglass-split"></i>';
                                                                           btn.disabled = true;

                                                                           // Create a form to load user data
                                                                           var form = document.createElement('form');
                                                                           form.method = 'GET';
                                                                           form.action = ctx + '/AdminUserEdit';
                                                                           form.target = 'hiddenFrame';
                                                                           form.style.display = 'none';

                                                                           var idInput = document.createElement('input');
                                                                           idInput.type = 'hidden';
                                                                           idInput.name = 'id';
                                                                           idInput.value = userId;
                                                                           form.appendChild(idInput);

                                                                           document.body.appendChild(form);
                                                                           form.submit();

                                                                           // Reset button state
                                                                           btn.innerHTML = '<i class="bi bi-pencil-square"></i>';
                                                                           btn.disabled = false;
                                                                       });
                                                                   });

                                                                   // Listen for iframe load to populate form
                                                                   document.getElementById('hiddenFrame').addEventListener('load', function () {
                                                                       try {
                                                                           var iframeDoc = this.contentDocument || this.contentWindow.document;
                                                                           var userData = extractUserDataFromPage(iframeDoc);

                                                                           if (userData) {
                                                                               // Populate form fields
                                                                               document.getElementById('editUserId').value = userData.userId || '';
                                                                               document.getElementById('editUsername').value = userData.username || '';
                                                                               document.getElementById('editEmail').value = userData.email || '';
                                                                               document.getElementById('editPhone').value = userData.phone || '';
                                                                               document.getElementById('editDob').value = userData.dateOfBirth || '';
                                                                               document.getElementById('editGender').value = userData.gender || '';
                                                                               document.getElementById('editRole').value = userData.role || 'Student';
                                                                               document.getElementById('editStatus').value = userData.status || 'active';

                                                                               // Show modal
                                                                               editModal.show();
                                                                           }
                                                                       } catch (error) {
                                                                           console.error('Error loading user data:', error);
                                                                           alert('Không thể tải dữ liệu người dùng');
                                                                       }
                                                                   });

                                                                   // Function to extract user data from the loaded page
                                                                   function extractUserDataFromPage(doc) {
                                                                       try {
                                                                           var userId = doc.querySelector('input[name="id"]')?.value || '';
                                                                           var username = doc.querySelector('input[name="username"]')?.value || '';
                                                                           var email = doc.querySelector('input[name="email"]')?.value || '';
                                                                           var phone = doc.querySelector('input[name="phone"]')?.value || '';
                                                                           var dob = doc.querySelector('input[name="date_of_birth"]')?.value || '';
                                                                           var gender = doc.querySelector('select[name="gender"]')?.value || '';
                                                                           var role = doc.querySelector('select[name="role"]')?.value || '';
                                                                           var status = doc.querySelector('select[name="status"]')?.value || '';

                                                                           return {
                                                                               userId: userId,
                                                                               username: username,
                                                                               email: email,
                                                                               phone: phone,
                                                                               dateOfBirth: dob,
                                                                               gender: gender,
                                                                               role: role,
                                                                               status: status
                                                                           };
                                                                       } catch (error) {
                                                                           return null;
                                                                       }
                                                                   }
                                                               });
        </script>   
    </body>
</html>
