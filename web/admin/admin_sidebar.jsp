<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />


<aside class="sidebar">
    <div>
        <!-- ===== Header / Logo ===== -->
        <div class="sidebar-header">
            <a href="dashboard-manager" class="logo">
            <img src="${pageContext.request.contextPath}/views-manager/icon/logo.png" alt="Logo">
        </a>
        </div>

        <!-- ===== Navigation ===== -->
        <nav class="sidebar-nav">

            <a href="${pageContext.request.contextPath}/AdminUserList"
               class="${pageContext.request.requestURI.contains('/AdminUserList') ? 'active' : ''}">
                <i class="fas fa-users"></i> Quản lý Users
            </a>

            <a href="${pageContext.request.contextPath}/adminCreateUsers"
               class="${pageContext.request.requestURI.contains('/adminCreateUsers') ? 'active' : ''}">
                <i class="fas fa-user-plus"></i> Tạo tài khoản
            </a>

            <a href="${pageContext.request.contextPath}/admin/report-list"
               class="${pageContext.request.requestURI.contains('/report-list') ? 'active' : ''}">
                <i class="fas fa-chart-bar"></i> Quản lý báo lỗi
            </a>

            <a href="${pageContext.request.contextPath}/AdminReportTypeList"
               class="${pageContext.request.requestURI.contains('/AdminReportTypeList') ? 'active' : ''}">
                <i class="fas fa-bell"></i> Danh sách lỗi mặc định
                <c:if test="${not empty sessionScope.unreadCount && sessionScope.unreadCount > 0}">
                    <span class="badge">${sessionScope.unreadCount}</span>
                </c:if>
            </a>
        </nav>
    </div>

    <!-- ===== User Section ===== -->
    <div class="sidebar-user">
        <c:if test="${user.profilePicture == null}">
            <img src="${pageContext.request.contextPath}/image/avatar/avatar_0.png" alt="avatar" class="user-avatar">

        </c:if>
        <c:if test="${user.profilePicture != null}">
            <img src="${pageContext.request.contextPath}/${user.profilePicture}" alt="avatar" class="user-avatar">
        </c:if>
        <span>${sessionScope.user.fullName}</span>

        <div class="sidebar-dropdown">
            <a href="${pageContext.request.contextPath}/admin/profile">
                <i class="fas fa-user"></i> Hồ sơ cá nhân
            </a>
            <a href="${pageContext.request.contextPath}/admin/changePassword">
                <i class="fas fa-key"></i> Đổi mật khẩu
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="text-danger">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</aside>
