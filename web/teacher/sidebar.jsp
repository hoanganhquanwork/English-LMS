<%-- 
    Document   : sidebar
    Created on : Sep 23, 2025, 9:08:16 PM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<<<<<<< HEAD
=======
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

>>>>>>> main
  <aside class="card admin-card admin-sidebar">
      <h4>Instructor</h4>
      <nav class="admin-menu">
        <a class="admin-link" href="instructorDashboard">Dashboard</a>
        <a class="admin-link" href="manage">Courses</a>
        <a class="admin-link" href="questions">Questions</a>
<<<<<<< HEAD
      </nav>
=======
        <a class="admin-link" href="gradeListServlet">Chấm Assignment</a>
      </nav>
      
      <div class="sidebar-user">
        <img src="${empty sessionScope.user.profilePicture 
                    ? pageContext.request.contextPath.concat('/image/avatar/avatar_0.png') 
                    : pageContext.request.contextPath.concat('/').concat(sessionScope.user.profilePicture)}" 
             alt="Avatar" class="user-avatar">
        <span>${sessionScope.user.fullName}</span>

        <div class="sidebar-dropdown">
            <a href="teacher-profile">
                <i class="fas fa-user"></i> Hồ sơ cá nhân
            </a>
            <a href="changePassword">
                <i class="fas fa-key"></i> Đổi mật khẩu
            </a>
            <a href="logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
>>>>>>> main
    </aside>
