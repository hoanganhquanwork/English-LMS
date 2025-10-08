<%-- 
    Document   : header-course
    Created on : Oct 7, 2025, 10:07:13 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/course/css/header.css"/>
    </head>
    <body>
        <header class="py-2">
            <div class="container d-flex align-items-center justify-content-between">      
                <div class="d-flex align-items-center flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/image/logo/logo.png" 
                                                                           alt="hi" height="50" class="me-3"></a>
                </div>

                <!--
                                <c:if test="${sessionScope.user == null}">
                                    <a href="${pageContext.request.contextPath}/login" class="me-3 text-decoration-none">Đăng nhập</a>
                                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary fw-semibold">Đăng ký</a>
                                </c:if>-->

                <c:if test="${sessionScope.user != null}">     
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" 
                           id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture == null ? 'image/avatar/avatar_0.png' :sessionScope.user.profilePicture}" 
                                 alt="User Avatar" 
                                 class="rounded-circle me-2" 
                                 style="width:36px; height:36px; object-fit:cover;">
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                            <c:if test="${sessionScope.user.role == 'Student'}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/updateStudentProfile">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/changeStudentPassword">Cài đặt mật khẩu</a></li>
                            </c:if>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                        </ul>

                    </div>
                </c:if>
            </div>
        </header>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</html>
