<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<fmt:setLocale value="vi_VN" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Cài đặt tài khoản | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent-profile-styles.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

    </head>
    <body>
        <!-- Header -->
        <%@ include file="parent_header.jsp" %>

        <!-- Main -->
        <main class="container">
            <div class="page-title">
                <h2>Cài đặt tài khoản</h2>
                <p class="lead">Cập nhật thông tin cá nhân và quản lý tài khoản.</p>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty updateFail}">
                <div class="alert error">${updateFail}</div>
            </c:if>
            <c:if test="${not empty updateSuccess}">
                <div class="alert success">${updateSuccess}</div>
            </c:if>

            <!-- Layout 2 cột -->
            <section class="settings-grid">
                <!-- Cột trái: ảnh đại diện -->
                <aside class="settings-aside card panel">
                    <form action="parentUpdatePicture" method="post" enctype="multipart/form-data">
                        <div class="avatar-wrapper">
                            <c:set var="user" value="${sessionScope.user}" />
                            <c:choose>
                                <c:when test="${empty user.profilePicture}">
                                    <img src="${pageContext.request.contextPath}/image/avatar/avatar_0.png"
                                         alt="avatar" class="profile-avatar" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${user.profilePicture}"
                                         alt="avatar" class="profile-avatar" />
                                </c:otherwise>
                            </c:choose>

                            <label for="avatar-upload" class="btn-save ghost">Đổi ảnh đại diện</label>
                            <input type="file" id="avatar-upload" name="avatar"
                                   accept="image/png, image/jpeg"
                                   onchange="this.form.submit()">
                            <p class="profile-upload-desc">JPG hoặc PNG, tối đa 5MB</p>
                        </div>
                    </form>
                </aside>

                <!-- Cột phải: thông tin cá nhân -->
                <section class="settings-form card panel">
                    <h3>Thông tin cá nhân</h3>
                    <form method="post" action="parentUpdateProfile">
                        <div class="field">
                            <label>Họ và tên</label>
                            <input class="input" type="text" name="full_name" value="${user.fullName}" required />
                        </div>

                        <div class="field">
                            <label>Email</label>
                            <input class="input" type="email" name="email" value="${user.email}" required />
                        </div>

                        <div class="field">
                            <label>Điện thoại</label>
                            <input class="input" type="text" name="phone" value="${user.phone}" />
                        </div>

                        <div class="field">
                            <label>Giới tính</label>
                            <select class="input" name="gender">
                                <option value="">-- Chọn --</option>
                                <option value="male"   ${user.gender == 'male'   ? 'selected' : ''}>Nam</option>
                                <option value="female" ${user.gender == 'female' ? 'selected' : ''}>Nữ</option>
                                <option value="other"  ${user.gender == 'other'  ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="field">
                            <label>Ngày sinh</label>
                            <input class="input" type="date" name="date_of_birth" value="${user.dateOfBirth}" />
                        </div>

                        <div class="field">
                            <label>Địa chỉ</label>
                            <input class="input" type="text" name="address" value="${parent.address}" />
                        </div>

                        <div class="field">
                            <label>Nghề nghiệp</label>
                            <input class="input" type="text" name="occupation" value="${parent.occupation}" />
                        </div>

                        <div class="actions">
                            <button class="btn-save" type="submit">Lưu thay đổi</button>
                        </div>
                    </form>
                </section>
            </section>
        </main>

        <!-- Footer -->
<<<<<<< HEAD
        <jsp:include page="/footer.jsp" />
=======
        
<footer>
        <jsp:include page="/footer.jsp" />
</footer>
>>>>>>> main
    </body>
</html>
