<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <a href="dashboard-manager" class="logo">
            <img src="${pageContext.request.contextPath}/views-manager/icon/logo.png" alt="Logo">
        </a>
    </div>
    <nav class="sidebar-nav">
        <a href="dashboard-manager" 
           class="${pageContext.request.requestURI.endsWith('/dashboard-manager') ? 'active' : ''}">
            <i class="fas fa-home"></i> Dashboard
        </a>

        <a href="coursemanager"
           class="${pageContext.request.requestURI.contains('/coursemanager') ? 'active' : ''}">
            <i class="fas fa-book"></i> Quản lý khóa học
        </a>

        <a href="cate-topic"
           class="${pageContext.request.requestURI.contains('/cate-topic') ? 'active' : ''}">
           <i class="fa fa-layer-group"></i> Quản lý chủ đề và danh mục
        </a>

        <a href="revenue-report"
           class="${pageContext.request.requestURI.contains('/revenue-report') ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i> Báo cáo
        </a>
        <a href="coursepublish"
           class="${pageContext.request.requestURI.contains('/coursepublish') ? 'active' : ''}">
            <i class="fas fa-calendar-days"></i> Lịch đăng khóa học
        </a>
        <a href="manager-flashcard"
           class="${pageContext.request.requestURI.contains('/manager-flashcard') ? 'active' : ''}">
            <i class="fa fa-clone"></i> Quản lí flashcard
        </a>
        <a href="question-manager"
           class="${pageContext.request.requestURI.contains('question-manager') ? 'active' : ''}">
            <i class="fa fa-question"></i> Quản lí câu hỏi
        </a>
    </nav>

    <div class="sidebar-user">
        <img src="${empty sessionScope.user.profilePicture 
                    ? pageContext.request.contextPath.concat('/views-manager/icon/default.png') 
                    : sessionScope.user.profilePicture}" 
             alt="Avatar" class="user-avatar">
        <span>${sessionScope.user.fullName}</span>

        <div class="sidebar-dropdown">
            <a href="manager-profile">
                <i class="fas fa-user"></i> Hồ sơ cá nhân
            </a>
            <a href="changeManagerPassword">
                <i class="fas fa-key"></i> Đổi mật khẩu
            </a>
            <a href="logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</aside>