<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Hồ sơ phụ huynh | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container navbar">
                <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
                    <div class="logo"></div><span>LinguaTrack</span>
                </a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/courses">Khóa học</a>
                    <a href="${pageContext.request.contextPath}/my-courses">My Courses</a>
                    <a href="${pageContext.request.contextPath}/parent/profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/parent/settings">Settings</a>
                </nav>
                <button class="hamburger btn ghost">☰</button>
            </div>
        </header>

        <!-- Main -->
        <main class="container">
            <div class="page-title">
                <h2>Hồ sơ phụ huynh</h2>
                <p class="lead">Thông tin tài khoản và liên hệ.</p>
            </div>

            <section class="grid" style="grid-template-columns: 320px 1fr; gap: 20px;">
                <!-- Sidebar -->
                <aside class="card panel" style="text-align:center;">
                    <div style="display:inline-grid; gap:10px; justify-items:center;">
                        <c:choose>
                            <c:when test="${not empty user.profilePicture}">
                                <img src="${user.profilePicture}" alt="avatar"
                                     style="width:120px;height:120px;border-radius:999px;object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                <div style="width:120px;height:120px;border-radius:999px;background:#1e293b;
                                     color:#fff;display:grid;place-items:center;font-size:46px;font-weight:700;">
                                    <c:out value="${fn:substring(user.fullName,0,1)}"/>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div><strong><c:out value="${user.fullName}" /></strong></div>
                        <div class="muted">Phụ huynh</div>
                        <a class="btn secondary" href="${pageContext.request.contextPath}/parent/settings">Chỉnh sửa hồ sơ</a>
                    </div>
                </aside>

                <!-- Main info -->
                <section class="grid" style="gap:20px;">
                    <div class="card panel">
                        <h3>Thông tin liên hệ</h3>
                        <p>Email: <strong><c:out value="${user.email}" /></strong></p>
                        <p>Điện thoại: <strong><c:out value="${user.phone}" /></strong></p>
                        <p>Giới tính: 
                            <strong>
                                <c:out value="${user.gender == 'male' ? 'Nam' : (user.gender == 'female' ? 'Nữ' : 'Khác')}" />
                            </strong>
                        </p>
                        <p>Ngày sinh: 
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty user.dateOfBirth}">${user.dateOfBirth}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>
                    </div>

                    <div class="card panel">
                        <h3>Thông tin bổ sung</h3>
                        <p>Địa chỉ: <strong><c:out value="${parent.address}" /></strong></p>
                        <p>Nghề nghiệp: <strong><c:out value="${parent.occupation}" /></strong></p>
                    </div>
                </section>
            </section>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container top">
                <div>
                    <h4>LinguaTrack</h4>
                    <div class="muted">Nền tảng học tiếng Anh trực tuyến.</div>
                </div>
                <div>
                    <h4>Khóa học</h4>
                    <a href="${pageContext.request.contextPath}/courses">Tất cả khóa học</a>
                </div>
                <div>
                    <h4>Hỗ trợ</h4>
                    <a href="#">Trung tâm trợ giúp</a>
                </div>
                <div>
                    <h4>Pháp lý</h4>
                    <a href="#">Điều khoản</a>
                </div>
            </div>
            <div class="container bottom">© 2025 LinguaTrack</div>
        </footer>
    </body>
</html>
