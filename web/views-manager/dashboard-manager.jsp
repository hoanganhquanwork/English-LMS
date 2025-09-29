<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Manager</title>
    <link rel="stylesheet" href="<c:url value='css/manager-style.css' />">
</head>
<body class="dashboard">

    <%@ include file="includes-manager/header-manager.jsp" %>

    <main class="main-content">
        <div class="container">
            <h1>Xin chào, ${sessionScope.user.fullName} 👋</h1>
            <p>Đây là dashboard dành cho Manager.</p>

            <ul>
                <li><a href="manager-profile">Hồ sơ cá nhân</a></li>
                <li><a href="coursemanager">Quản lý khóa học</a></li>
            </ul>
        </div>
    </main>

    <%@ include file="includes-manager/footer.jsp" %>
</body>
</html>