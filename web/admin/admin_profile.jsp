<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Hồ sơ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
    </head>
    <body>
        <%@ include file="admin_sidebar.jsp" %>

        <div class="main-content">
            <h2 class="fw-bold mb-4">Hồ sơ quản trị viên</h2>
            <c:if test="${not empty success}">
                <div style="color: green">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="color: red"> ${error}</div>
            </c:if>
            <div class="profile-container">
                <!-- Cột trái: Avatar -->
                <div class="profile-left">
                    <form action="<%=ctx%>/admin/avatar" method="post" enctype="multipart/form-data">
                        <div class="profile-card">
                            <c:set var="user" value="${sessionScope.user}" />
                            <c:if test="${user.profilePicture == null}">
                                <!--<img src="${pageContext.request.contextPath}/image/avatar/avatar_0.png" alt="avatar" class="profile-avatar">-->
                                <img src="${pageContext.request.contextPath}/image/avatar/avatar_0.png" alt="avatar" class="profile-avatar">

                            </c:if>
                            <c:if test="${user.profilePicture != null}">
                                <img src="${pageContext.request.contextPath}/${user.profilePicture}" alt="avatar" class="profile-avatar">
                            </c:if>
                            <div class="profile-upload">
                                <label for="avatar-upload" ><u>Đổi ảnh đại diện</u></label>
                                <input type="file" id="avatar-upload" name="avatar"
                                       accept="image/png, image/jpeg" onchange="this.form.submit()" style ="visibility: hidden;" >
                            </div>
                            <div class="profile-upload-desc">JPG hoặc PNG, tối đa 5MB</div>
                        </div>
                    </form>
                </div>

                <!-- Cột phải: Form thông tin -->
                <div class="profile-right">
                    <form action="<%=ctx%>/admin/updateprofile" method="post" enctype="multipart/form-data">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ và tên</label>
                                <input type="text" name="full_name" value="${adminProfile.fullName}" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" value="${adminProfile.email}" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Điện thoại</label>
                                <input type="text" name="phone" value="${adminProfile.phone}" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngày sinh</label>
                                <input type="date" name="date_of_birth" value="${adminProfile.dateOfBirth}" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Giới tính</label>
                                <select name="gender" class="form-select">
                                    <option value="">-- Chọn --</option>
                                    <option value="male" ${adminProfile.gender == 'male' ? 'selected' : ''}>Nam</option>
                                    <option value="female" ${adminProfile.gender == 'female' ? 'selected' : ''}>Nữ</option>
                                    <option value="other" ${adminProfile.gender == 'other' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>
                        <div class="text-end mt-4">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-save me-1"></i> Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>
