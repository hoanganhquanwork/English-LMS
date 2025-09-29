<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ Quản lý</title>
    <link rel="stylesheet" href="<c:url value='/css/manager-style.css' />">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
</head>
<body class="profile">

    <%@ include file="includes-manager/header-manager.jsp" %>

    <main class="settings-container">
        <h1>Hồ sơ Quản lý</h1>
        <p>Cập nhật thông tin cá nhân và nghề nghiệp của bạn.</p>

        <c:if test="${not empty message}">
            <div style="color: green; margin-bottom: 10px;">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="color: red; margin-bottom: 10px;">${error}</div>
        </c:if>

        <div class="settings-card">
            <section class="profile-card">
                <div class="avatar"></div>
                <h3>${user.fullName}</h3>
                <p class="role">Manager</p>
                <button class="btn btn-outline">Đổi mật khẩu</button>
            </section>

            <section class="form-card">
                <form action="manager-profile" method="post">

                    <label>Họ tên</label>
                    <input type="text" name="fullName" value="${user.fullName}" readonly>

                    <label>Email</label>
                    <input type="email" name="email" value="${user.email}" readonly>

                    <label>Ngày sinh</label>
                    <input type="date" name="dateOfBirth" value="${user.dateOfBirth}" readonly>

                    <label>Chức vụ</label>
                    <input type="text" name="position" value="${profile.position}" readonly>

                    <label>Chuyên môn</label>
                    <input type="text" name="specialization" value="${profile.specialization}" readonly>

                    <div class="form-actions">
                        <button type="button" id="editBtn" class="btn btn-primary" onclick="enableEdit()">
                            Thay đổi thông tin
                        </button>

                        <div id="saveCancelGroup" style="display: none;">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            <button type="button" class="btn btn-secondary" onclick="cancelEdit()">Hủy</button>
                        </div>
                    </div>
                </form>
            </section>
        </div>
    </main>
    <script>
        function enableEdit() {
            document.querySelectorAll('.form-card input').forEach(el => el.removeAttribute('readonly'));
            document.getElementById("editBtn").style.display = "none";
            document.getElementById("saveCancelGroup").style.display = "inline-block";
        }

        function cancelEdit() {
            document.querySelectorAll('.form-card input').forEach(el => el.setAttribute('readonly', true));
            document.getElementById("saveCancelGroup").style.display = "none";
            document.getElementById("editBtn").style.display = "inline-block";
        }
    </script>
</body>
</html>