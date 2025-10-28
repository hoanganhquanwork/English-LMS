<%-- 
    Document   : footer
    Created on : Sep 27, 2025, 4:18:03 PM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css"/>

    </head>
    <body>
        <header class="py-2">
            <div class="container d-flex align-items-center justify-content-between">      
                <div class="d-flex align-items-center flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/image/logo/logo.png" 
                                                                           alt="hi" height="28" class="me-3"></a>
                    <a href="${pageContext.request.contextPath}/courseSearching" class="nav-link me-3">Khám phá</a>
                    <c:if test="${sessionScope.user != null}">
                        <a href="${pageContext.request.contextPath}/myLearning" class="nav-link me-3">Khóa học của tôi</a>
                    </c:if>
                </div>

                <form action="courseSearching" method="get" class="search-wrapper w-100">
                    <div class="input-group search-bar">
                        <input type="text" name="keyWord" value="${requestScope.keyWord}"class="form-control" placeholder="Tìm kiếm khóa học yêu thích">

                        <button type="submit" class="btn btn-search">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>

                <c:if test="${sessionScope.user == null}">
                    <a href="${pageContext.request.contextPath}/login" class="me-3 text-decoration-none">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary fw-semibold">Đăng ký</a>
                </c:if>

                <c:if test="${sessionScope.user != null}">
                    <c:if test="${sessionScope.user.role == 'Student'}">
                        <a href="${pageContext.request.contextPath}/courseRequest" class="text-dark fs-5 me-3">
                            <i class="bi bi-heart"></i>
                        </a>
                    </c:if>

                    <c:if test="${sessionScope.user.role == 'Parent'}">
                        <a href="#" class="text-dark fs-5 me-3">
                            <i class="bi bi-cart3"></i>
                        </a>
                    </c:if>
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
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/changeUserPassword">Cài đặt mật khẩu</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/studentVocab">Từ điển của tôi</a></li>
                                </c:if>

                            <c:if test="${sessionScope.user.role == 'Parent'}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/parent/profile">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/changeUserPassword">Cài đặt mật khẩu</a></li>
                                </c:if>

                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                        </ul>

                    </div>
                </c:if>
            </div>
        </header>
    </body>

</html>
