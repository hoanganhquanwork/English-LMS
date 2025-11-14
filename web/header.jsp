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
        <c:if test="${sessionScope.user == null or sessionScope.user.role == 'Student'}">
            <header class="py-2">
                <div class="container d-flex align-items-center justify-content-between" style="padding: 0px;">      
                    <div class="d-flex align-items-center flex-shrink-0">
                        <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/image/logo/logo.png" 
                                                                               alt="hi" height="28" class="me-3"></a>
                        <a href="${pageContext.request.contextPath}/courseSearching" class="nav-link me-3">Khám phá</a>
                        <c:if test="${sessionScope.user != null}">
                            <a href="${pageContext.request.contextPath}/myLearning" class="nav-link me-3">Khóa học của tôi</a>
                            <a href="${pageContext.request.contextPath}/flashcard" class="nav-link me-3">Flashcard</a>
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
                            <a href="${pageContext.request.contextPath}/courseRequest" class="text-dark fs-5 me-3" 
                               title="Liên kết tài khoản phụ huynh và yêu cầu khóa học">
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
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/updateStudentProfile">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/changeUserPassword">Cài đặt mật khẩu</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/studentVocab">Từ điển của tôi</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reportList">Báo lỗi hệ thống</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </div>
                    </div>

                </c:if>
            </c:if>
            <c:if test="${sessionScope.user.role == 'Parent'}">
                <%
                    String currentPage = (String) request.getAttribute("currentPage");
                    if (currentPage == null) currentPage = "";
                %>

                <header class="py-2 border-bottom">
                    <div class="container d-flex align-items-center justify-content-between">

                        <!-- Logo bên trái -->
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="flex-shrink-0">
                            <img src="${pageContext.request.contextPath}/image/logo/logo.png" alt="logo" height="28">
                        </a>

                        <!-- Menu ở giữa, cách đều -->
                        <nav class="d-flex justify-content-center flex-grow-1 parent-nav">
                            <a href="${pageContext.request.contextPath}/parent/dashboard"
                               class="nav-link <%= "dashboard".equals(currentPage) ? "fw-semibold text-primary" : "" %>">Trang chủ</a>
                            <a href="${pageContext.request.contextPath}/parentlinkstudent"
                               class="nav-link <%= "children".equals(currentPage) ? "fw-semibold text-primary" : "" %>">Quản lý con</a>
                            <a href="${pageContext.request.contextPath}/parent/progress"
                               class="nav-link <%= "progress".equals(currentPage) ? "fw-semibold text-primary" : "" %>">Tiến độ học tập</a>
                            <a href="${pageContext.request.contextPath}/parent/approvals"
                               class="nav-link <%= "approvals".equals(currentPage) ? "fw-semibold text-primary" : "" %>">Phê duyệt</a>
                            <a href="${pageContext.request.contextPath}/parent/paymentitems"
                               class="nav-link <%= "payments".equals(currentPage) ? "fw-semibold text-primary" : "" %>">Thanh toán</a>
                            <a href="${pageContext.request.contextPath}/parent/orders"
                               class="nav-link <%= "orders".equals(currentPage) ? "fw-semibold text-primary" : "" %>">Đơn hàng</a>
                        </nav>

                        <!-- Avatar bên phải -->
                        <div class="dropdown flex-shrink-0">
                            <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" 
                               id="parentDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture == null ? 'image/avatar/avatar_0.png' : sessionScope.user.profilePicture}" 
                                     alt="User Avatar" class="rounded-circle" 
                                     style="width:36px; height:36px; object-fit:cover;">
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="parentDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/parent/profile">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/changeUserPassword">Cài đặt mật khẩu</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reportList">Báo lỗi hệ thống</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </div>

                    </div>
                </header>
            </c:if>
        </header>
    </body>

</html>

