<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Tạo tài khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
        <%@ include file="admin_sidebar.jsp" %>

    </head>
    <body>
        <div class="container-fluid main-content">
            <div class="row">

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
                    <h2 class="mb-4">Tạo tài khoản người dùng</h2>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="adminCreateUsers" method="post" class="border rounded-4 p-4 bg-white shadow-sm" style="max-width: 640px;">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Tên đăng nhập</label>
                            <input class="form-control" name="username" value="${username}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email</label>
                            <input class="form-control" type="email" name="email" value="${email}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Mật khẩu</label>
                            <input class="form-control" type="password" name="password" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Giới tính</label>
                            <select class="form-select" name="gender">
                                <option value="" ${empty gender ? 'selected' : ''}>-- Chọn --</option>
                                <option value="male"   ${gender == 'male' ? 'selected' : ''}>Nam</option>
                                <option value="female" ${gender == 'female' ? 'selected' : ''}>Nữ</option>
                                <option value="other"  ${gender == 'other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Vai trò</label>
                            <select name="role" class="form-select" required>
                                <option value="" disabled ${empty role ? 'selected' : ''}>-- Chọn vai trò --</option>
                                <option value="Admin"      ${role == 'Admin' ? 'selected' : ''}>Admin</option>
                                <option value="Manager"    ${role == 'Manager' ? 'selected' : ''}>Manager</option>
                                <option value="Instructor" ${role == 'Instructor' ? 'selected' : ''}>Instructor</option>
                                <option value="Student"    ${role == 'Student' ? 'selected' : ''}>Student</option>
                                <option value="Parent"     ${role == 'Parent' ? 'selected' : ''}>Parent</option>
                            </select>
                        </div>

                        <div class="text-end">
                            <button class="btn btn-primary px-4" type="submit">Tạo tài khoản</button>
                        </div>
                    </form>
                </main>
            </div>
        </div>
    </body>
</html>
