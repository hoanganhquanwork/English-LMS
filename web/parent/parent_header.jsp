<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Mỗi JSP trước khi include header nên set request attribute currentPage
    // Ví dụ: request.setAttribute("currentPage", "children");
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
%>

<header class="header">
    <div class="container top-header">
        <a class="brand" href="../index.html">
            <div class="logo"></div>
            <span>LinguaTrack</span>
        </a>

        <div class="header-actions">
            <a href="notifications.html" class="notification-bell">
                <span class="bell-icon">🔔</span>
                <span class="notification-badge">2</span>
            </a>

            <div class="user-dropdown">
                <button class="avatar-btn" onclick="toggleUserDropdown()">
                    <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture == null ? 'image/avatar/avatar_0.png' :sessionScope.user.profilePicture}" 
                         alt="User Avatar" 
                         class="rounded-circle me-2" 
                         style="width:36px; height:36px; object-fit:cover;">

                    <span class="dropdown-arrow">▼</span>
                </button>
                <div class="dropdown-menu" id="userDropdown">
                    <a href="${pageContext.request.contextPath}/parent/profile" class="dropdown-item">👤 Profile</a>
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">🚪 Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container navigation-bar">
        <nav class="nav">
            <a href="dashboard.html"
               class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/parentlinkstudent"
               class="<%= "children".equals(currentPage) ? "active" : "" %>">Quản lý con</a>
            <a href="enrollments.html"
               class="<%= "enrollments".equals(currentPage) ? "active" : "" %>">Đăng ký khóa học</a>
            <a href="approvals.html"
               class="<%= "approvals".equals(currentPage) ? "active" : "" %>">Phê duyệt</a>
            <a href="payments.html"
               class="<%= "payments".equals(currentPage) ? "active" : "" %>">Thanh toán</a>
            <a href="progress.html"
               class="<%= "progress".equals(currentPage) ? "active" : "" %>">Tiến độ</a>
        </nav>
        <button class="hamburger btn ghost">☰</button>
    </div>
</header>

<script>
    // User dropdown toggle
    function toggleUserDropdown() {
        const dropdown = document.getElementById('userDropdown');
        const avatarBtn = document.querySelector('.avatar-btn');
        dropdown.classList.toggle('show');
        avatarBtn.classList.toggle('active');
    }

    // Đóng dropdown khi click ra ngoài
    window.onclick = function (event) {
        const dropdown = document.getElementById('userDropdown');
        const avatarBtn = document.querySelector('.avatar-btn');
        if (!event.target.closest('.user-dropdown')) {
            dropdown.classList.remove('show');
            avatarBtn.classList.remove('active');
        }
    };

</script>
