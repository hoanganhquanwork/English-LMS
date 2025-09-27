<%-- 
    Document   : course-create
    Created on : Sep 27, 2025, 5:29:00 PM
    Author     : Lenovo
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nội dung Khóa học - Lập trình Python cơ bản</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
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
                    <h2>Nội dung Khóa học</h2>
                    <p class="page-subtitle">Khóa học: ${course.title}</p>
                </div>
            </div>

            <!-- Course Info Card -->
            <div class="course-info-card">
                <div class="course-header">
                    <div class="course-thumbnail">
                        <i >${course.thumbnail}</i>
                    </div>
                    <div class="course-details">
                        <h3>${course.title}</h3>
                        <p>${course.description}</p>
                        <div class="course-stats">
                            <div class="stat">
                                <i class="fas fa-book"></i>
                                <span>${fn:length(moduleList)} modules</span>
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
                            <a href="course-content.html" class="sidebar-link active">
                                <i class="fas fa-play-circle"></i>
                                Nội dung khóa học
                            </a>
                            <a href="course-students.html" class="sidebar-link">
                                <i class="fas fa-users"></i>
                                Học sinh
                            </a>
                            <a href="assignments.html" class="sidebar-link">
                                <i class="fas fa-tasks"></i>
                                Bài tập
                            </a>
                            <a href="#" class="sidebar-link">
                                <i class="fas fa-chart-bar"></i>
                                Báo cáo tiến độ
                            </a>
                            <a href="#" class="sidebar-link">
                                <i class="fas fa-comments"></i>
                                Thảo luận
                            </a>
                            <a href="#" class="sidebar-link">
                                <i class="fas fa-cog"></i>
                                Cài đặt khóa học
                            </a>
                        </nav>
                    </div>

                    <!-- Quick Stats -->

                </aside>

                <!-- Main Content -->
                <main class="main-content">

                    <!-- Modules List -->
                    <div class="module-list">
                        <div class="section-header">
                            <h3><i class="fas fa-list"></i> Danh sách Modules</h3>
                            <div class="table-actions">
                                <button class="btn btn-primary" onclick="openCreateModuleModal()">
                                    <i class="fas fa-plus"></i> Tạo Module
                                </button>
                            </div>
                        </div>

                        <div id="modulesContainer">
                            <c:forEach var="h" items="${requestScope.moduleList}">
                                <div class="module-item">
                                    <div class="module-info">
                                        <div class="module-name">Module ${h.orderIndex}: ${h.title}</div>
                                        <div class="module-description">${h.description}</div>
                                        <div class="module-meta">
                                            <span><i class="fas fa-sort-numeric-up"></i> Thứ tự: ${h.orderIndex}</span>
                                        </div>
                                    </div>
                                    <div class="module-actions">
                                        <button class="btn-icon" 
                                                title="Sửa" 
                                                onclick="editModule('${h.moduleId}', '${h.title}', '${h.description}')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <a href="deleteModule?moduleId=${h.moduleId}&courseId=${course.courseId}" 
                                           class="btn-icon danger" 
                                           title="Xóa"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa module này không?');">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>

                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Create Module Modal -->
        <div id="createModuleModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-plus-circle"></i> Tạo Module Mới</h3>
                    <button class="modal-close" onclick="closeCreateModuleModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="moduleForm" action="addModule" method="post">
                        <input type="hidden" name="courseId" value="${course.courseId}" />
                        <input type="hidden" name="moduleId" id="moduleId" />  
                        <div class="form-row">
                            <div class="form-group">
                                <label for="moduleName">Tên Module *</label>
                                <input type="text" id="moduleName" name="moduleName" placeholder="Nhập tên module..." required>
                            </div>

                        </div>

                        <div class="form-group">
                            <label for="moduleDescription">Mô tả Module</label>
                            <textarea id="moduleDescription" name="moduleDescription" placeholder="Mô tả nội dung module..."></textarea>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeCreateModuleModal()">Hủy</button>
                    <button type="submit" id="submitBtn" form="moduleForm" class="btn btn-primary">Tạo Module</button>
                </div>
            </div>
        </div>

        <script src="js/course-content.js"></script>
    </body>
</html>
