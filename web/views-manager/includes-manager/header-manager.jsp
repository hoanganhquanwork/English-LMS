<%-- includes/header-manager.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Header -->
<header class="header">
    <div class="container">
        <div class="top-header">
            <a href="/manager/dashboard" class="logo">
                <img src="${pageContext.request.contextPath}/assets/icon/logo.png" alt="Logo">
            </a>

            <div class="header-actions">
                <div class="user-dropdown">
                    <button class="avatar-btn" onclick="toggleDropdown(event)">
                        <img src="${empty sessionScope.user.profilePicture 
                                    ? pageContext.request.contextPath.concat('/views-manager/icon/default.png') 
                                    : sessionScope.user.profilePicture}"
                             alt="Manager Avatar" class="user-avatar">
                        <span>${sessionScope.user.fullName}</span>
                        <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </button> 

                    <div class="dropdown-menu" id="userDropdown">
                        <a href="${pageContext.request.contextPath}/manager-profile" class="dropdown-item">
                            <i class="fas fa-user dropdown-icon"></i> Hồ sơ cá nhân
                        </a>
                        <a href="logout" class="dropdown-item">
                            <i class="fas fa-sign-out-alt dropdown-icon"></i> Đăng xuất
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="navigation-bar">
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/manager/dashboard" class="active">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/coursemanager">
                    <i class="fas fa-book"></i> Quản lý khóa học
                </a>
            </nav>
        </div>
    </div>
</header>

<script>
    function toggleDropdown(event) {
        event.stopPropagation();
        document.getElementById("userDropdown").classList.toggle("show");
    }

    window.addEventListener("click", function () {
        document.getElementById("userDropdown").classList.remove("show");
    });
</script>