<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Hồ sơ phụ huynh | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent-profile-styles.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <!-- Main -->
        <main class="container contain flex-grow-1">
            <div class="page-title">
                <h2>Hồ sơ phụ huynh</h2>
                <p class="lead">Thông tin tài khoản và liên hệ.</p>
            </div>

            <section class="grid profile-layout">
                <!-- Sidebar -->
                <aside class="card panel profile-aside">
                    <div class="profile-aside-inner">
                        <c:choose>
                            <c:when test="${not empty user.profilePicture}">
                                <img src="${pageContext.request.contextPath}/${user.profilePicture}"
                                     alt="avatar"
                                     class="profile-aside-avatar">
                            </c:when>
                            <c:otherwise>
                                <div class="profile-aside-avatar-fallback">
                                    <c:out value="${fn:substring(user.fullName,0,1)}"/>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div><strong style="font-size: 18px"><c:out value="${user.fullName}" /></strong></div>
                        <div class="muted">Phụ huynh</div>
                        <a class="btn-save secondary" 
                           href="${pageContext.request.contextPath}/parentUpdateProfile">Chỉnh sửa hồ sơ</a>
                    </div>
                </aside>

                <!-- Main info -->
                <section class="grid profile-main">
                    <div class="card panel">
                        <h3 class="card-title">Thông tin liên hệ</h3>
                        <p>Email: <strong><c:out value="${user.email}" /></strong></p>
                        <p>Điện thoại: <strong>
                                <c:choose>
                                    <c:when test="${not empty user.phone}"><c:out value="${user.phone}" /></c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong></p>

                    </div>

                    <div class="card panel">
                        <h3 class="card-title">Thông tin cá nhân</h3>
                        <p>Giới tính: 
                            <strong>
                                <c:choose>
                                    <c:when test="${user.gender == 'male'}">Nam</c:when>
                                    <c:when test="${user.gender == 'female'}">Nữ</c:when>
                                    <c:when test="${user.gender == 'other'}">Khác</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>
                        <p>Ngày sinh: 
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty user.formattedDateOfBirth}">
                                        ${user.formattedDateOfBirth}
                                    </c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>



                        <p>Địa chỉ: 
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty parent.address}"><c:out value="${parent.address}" /></c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>
                        <p>Nghề nghiệp: 
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty parent.occupation}"><c:out value="${parent.occupation}" /></c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>
                    </div>
                </section>
            </section>
        </main>

        <!-- Footer -->
        <jsp:include page="/footer.jsp" />

    </body>
</html>
