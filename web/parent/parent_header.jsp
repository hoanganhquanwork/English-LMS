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
            <a href="${pageContext.request.contextPath}/parent/dashboard"
               class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/parentlinkstudent"
               class="<%= "children".equals(currentPage) ? "active" : "" %>">Quản lý con</a>
            <a href="${pageContext.request.contextPath}/parent/progress"
               class="<%= "progress".equals(currentPage) ? "active" : "" %>">Tiến độ học tập</a>
            <a href="${pageContext.request.contextPath}/parent/approvals"
               class="<%= "approvals".equals(currentPage) ? "active" : "" %>">Phê duyệt</a>
            <a href="${pageContext.request.contextPath}/parent/paymentitems"
               class="<%= "payments".equals(currentPage) ? "active" : "" %>">Thanh toán</a>
            <a href="${pageContext.request.contextPath}/parent/orders"
               class="<%= "orders".equals(currentPage) ? "active" : "" %>">Đơn hàng</a>
        </nav>
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

