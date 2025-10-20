<%-- 
    Document   : studentProfile
    Created on : Sep 24, 2025, 7:18:30 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-profile.css"/>

    </head>
    <body>
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <div class="profile-main">
            <!-- LEFT: Avatar -->
            <div class="profile-left">
                <form action="updatePictureProfile" method="post" enctype="multipart/form-data">
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
                                   accept="image/png, image/jpeg" onchange="this.form.submit()">
                        </div>
                        <div class="profile-upload-desc">JPG hoặc PNG, tối đa 5MB</div>
                    </div>
                </form>
            </div>

            <!-- RIGHT: Info -->
            <form action="updateStudentProfile" method="post">
                <div class="profile-right">
                    <div class="profile-form-title">THÔNG TIN CÁ NHÂN</div>


                    <div class="profile-form-row">
                        <div class="profile-form-group">
                            <label>Tên đăng nhập</label>
                            <input type="text" name="username" value="${sessionScope.user.username}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Họ và tên</label>
                            <input type="text" name="fullName" value="${sessionScope.user.fullName}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Vai trò</label>
                            <input type="text" name="role" value="${sessionScope.user.role}" readonly>
                        </div>
                    </div>

                    <div class="profile-form-row">
                        <div class="profile-form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="${sessionScope.user.email}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" value="${sessionScope.user.phone}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Ngày sinh</label>
                            <input type="date" name="dob" value="${sessionScope.user.dateOfBirth}" readonly>
                        </div>
                    </div>
                    <div class="profile-form-row">
                        <div class="profile-form-group">
                            <label>Giới tính</label>
                            <select name="gender" disabled>
                                <option value="male"   ${sessionScope.user.gender=='male'?'selected':''}>Nam</option>
                                <option value="female" ${sessionScope.user.gender=='female'?'selected':''}>Nữ</option>
                                <option value="other"  ${sessionScope.user.gender=='other'?'selected':''}>Khác</option>
                            </select>
                        </div>
                        <c:set var="student" value="${requestScope.student}"/>

                        <div class="profile-form-group">
                            <label>Địa chỉ</label>
                            <input type="text" name="address" value="${student.address}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Cấp học / Lớp</label>
                            <input type="text" name="gradeLevel" value="${student.gradeLevel}" readonly>
                        </div>
                    </div>
                    <div class="profile-form-group">
                        <label>Trường học</label>
                        <input type="text" name="institution" value="${student.institution}" readonly>
                    </div>
                    <div>
                        <button type="button" class="profile-edit-btn" onclick="edit()">Chỉnh sửa</button>
                        <button type="submit" class="profile-save-btn" style="display:none;">Lưu</button>
                    </div>

                    <div class="messages">
                        <p class="success">${requestScope.updateSuccess}</p>
                        <p class="error">${requestScope.updateFail}</p>
                    </div>
                </div>
            </form>
        </div>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>

    <script>
        function edit() {
            let inputs = document.querySelectorAll(".profile-form-group input, .profile-form-group select");
            let unchange = ['username', 'role', 'email'];

            for (let i = 0; i < inputs.length; i++) {
                let input = inputs[i];
                if (unchange.indexOf(input.name) === -1) {
                    input.removeAttribute("readonly");
                    input.removeAttribute("disabled");
                }
            }
            document.querySelector('.profile-edit-btn').style.display = 'none';
            document.querySelector('.profile-save-btn').style.display = 'inline-block';
        }
    </script>
</html>
