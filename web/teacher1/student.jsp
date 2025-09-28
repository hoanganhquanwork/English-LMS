<%-- 
    Document   : student
    Created on : Sep 28, 2025, 1:20:58 AM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Học sinh - Lập trình Python cơ bản</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="dashboard.html" class="brand">
                        <div class="logo"></div>
                        <span>EduPlatform</span>
                    </a>
                    <div class="nav">
                        <a href="instructorDashboard?id=3">Dashboard</a>
                        <a href="manage?id=3">Khóa học</a>                     

                    </div>
                    <button class="hamburger">
                        <i class="fas fa-bars"></i>
                    </button>
                </nav>
            </div>
        </header>

        <div class="container">

            <!-- Page Title -->
            <div class="page-title">
                <div>
                    <h2>Học sinh trong khóa</h2>
                    <p class="page-subtitle">Khóa học: ${course.title}</p>
                </div>
            </div>

            <!-- Course Info Card -->
            <div class="course-info-card">
                <div class="course-header">
                    <div class="course-thumbnail">
                        
                    </div>
                    <div class="course-details">
                        <h3>${course.title}</h3>
                        <p>${course.description}</p>
                        <div class="course-stats">
                            <div class="stat">
                                <i class="fas fa-users"></i>
                                <span>${fn:length(studentList)} học sinh</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-layout">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="sidebar-card">
                        <h4>Menu Khóa học</h4>
                        <nav class="sidebar-menu">
                            <a href="manageModule?courseId=${course.courseId}" class="sidebar-link">
                                <i class="fas fa-play-circle"></i>
                                Nội dung khóa học
                            </a>
                            <a href="courseStudents?courseId=${course.courseId}" class="sidebar-link active">
                                <i class="fas fa-users"></i>
                                Học sinh
                            </a>
                        </nav>
                    </div>

                    <!-- Quick Stats -->
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <!-- Filters and Search -->
                    <div class="filters-section">
                        <form method="get" action="courseStudents">
                            <input type="hidden" name="courseId" value="${course.courseId}" />
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" name="keyword" value="${keyword}" placeholder="Tìm kiếm học sinh...">
                            </div>
                            <div class="filter-group">
                                <select name="status" class="filter-select" onchange="this.form.submit()">
                                    <option value="all" ${status=="all" ? "selected" : ""}>Tất cả trạng thái</option>
                                    <option value="active" ${status=="active" ? "selected" : ""}>Đang học</option>
                                    <option value="completed" ${status=="completed" ? "selected" : ""}>Đã hoàn thành</option>
                                </select>
                            </div>
                        </form>
                    </div>

                    <!-- Students Table -->
                    <div class="students-section">

                        <div class="table-container">
                            <table class="students-table">
                                <thead>
                                    <tr>

                                        <th>Học sinh</th>
                                        <th>Email</th>

                                        <th>Trạng thái</th>
                                        <th>Ngày tham gia</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="h" items="${requestScope.studentList}">
                                        <tr>
                                            <td>
                                                <div class="student-info">
                                                    <div class="student-avatar">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div>
                                                        <div class="student-name">${h.user.fullName}</div>
                                                        <div class="student-id">ID: ST${h.user.userId}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${h.user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${h.status eq 'active'}">
                                                        <span class="status-badge active">Đang học</span>
                                                    </c:when>
                                                    <c:when test="${h.status eq 'completed'}">
                                                        <span class="status-badge completed">Đã hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">${en.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${h.enrolledAt}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-icon" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>


                                </tbody>
                            </table>
                        </div>

                    </div>
            </div>


        </main>
    </div>
</div>
</body>
</html>
