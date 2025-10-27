<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Chỉnh sửa người dùng</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
    </head>
    <body>
        <nav class="topbar shadow-sm">
            <div class="container-fluid px-4 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <span class="brand-dot"></span>
                    <span class="fw-semibold">Chỉnh sửa người dùng</span>
                </div>
                <a class="text-decoration-none small text-muted"
                   href="${pageContext.request.contextPath}/AdminUserList">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại
                </a>
            </div>
        </nav>

        <div class="page">
            <main class="main">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h2 class="fw-bold m-0">Chỉnh sửa người dùng</h2>
                </div>

                <div class="card card-panel">
                    <div class="card-body">
                        <form method="post" action="<%=ctx%>/AdminUserEdit">
                            <input type="hidden" name="id" value="${user.userId}"/>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Username</label>
                                    <input class="form-control" name="username" value="${user.username}" required/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="${user.email}" required/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" value="${user.phone}"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="text" class="form-control" value="${user.dateOfBirth}" name="date_of_birth"/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giới tính</label>
                                    <select class="form-select" name="gender">
                                        <option value="">--Chọn--</option>
                                        <option value="male" ${user.gender == 'male' ? 'selected' : ''}>Nam</option>
                                        <option value="female" ${user.gender == 'female' ? 'selected' : ''}>Nữ</option>
                                        <option value="other" ${user.gender == 'other' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Vai trò</label>
                                    <select class="form-select" name="role">
                                        <option value="Student" ${user.role == 'Student' ? 'selected' : ''}>Student</option>
                                        <option value="Instructor" ${user.role == 'Instructor' ? 'selected' : ''}>Instructor</option>
                                        <option value="Manager" ${user.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                        <option value="Parent" ${user.role == 'Parent' ? 'selected' : ''}>Parent</option>
                                        <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status" required>
                                        <option value="active" ${user.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="deactivated" ${user.status == 'deactivated' ? 'selected' : ''}>Vô hiệu hóa</option>
                                    </select>
                                    <div class="form-text">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Chọn "Vô hiệu hóa" để tạm dừng tài khoản thay vì xóa vĩnh viễn
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4">
                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-save me-1"></i>Lưu thay đổi
                                </button>
                                <a href="<%=ctx%>/AdminUserList" class="btn btn-secondary">
                                    <i class="bi bi-x-lg me-1"></i>Hủy
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
