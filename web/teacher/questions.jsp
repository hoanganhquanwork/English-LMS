<%-- 
    Document   : questions
    Created on : Dec 27, 2024
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
        <title>Danh sách Câu hỏi - ${course.title}</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .table-container {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .questions-table {
                width: 100%;
                border-collapse: collapse;
            }

            .questions-table th {
                background: #f8f9fa;
                padding: 16px;
                text-align: left;
                font-weight: 600;
                color: #2c3e50;
                border-bottom: 2px solid #e9ecef;
            }

            .questions-table td {
                padding: 16px;
                border-bottom: 1px solid #e9ecef;
                vertical-align: middle;
            }

            .questions-table tr:hover {
                background: #f8f9fa;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }

            .btn {
                padding: 8px 12px;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-edit {
                background: #f39c12;
                color: white;
            }

            .btn-edit:hover {
                background: #e67e22;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(243, 156, 18, 0.3);
            }

            .btn-delete {
                background: #e74c3c;
                color: white;
            }

            .btn-delete:hover {
                background: #c0392b;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
            }

            .btn-view {
                background: #3498db;
                color: white;
            }

            .btn-view:hover {
                background: #2980b9;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
            }
        </style>
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
                    <h2>Danh sách Câu hỏi</h2>
                    <p class="page-subtitle">Khóa học: ${course.title}</p>
                </div>
            </div>

            <!-- Course Info Card -->
            <div class="course-info-card">
                <div class="course-header">
                    <div class="course-thumbnail">
                        <i>${course.thumbnail}</i>
                    </div>
                    <div class="course-details">
                        <h3>${course.title}</h3>
                        <p>${course.description}</p>
                        <div class="course-stats">
                            <div class="stat">
                                <i class="fas fa-question-circle"></i>
                                <span>0 câu hỏi</span>
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
                            <a href="manageModule?courseId=${course.courseId}" class="sidebar-link ">
                                <i class="fas fa-play-circle"></i>
                                Nội dung khóa học
                            </a>
                            <a href="courseStudents?courseId=${course.courseId}" class="sidebar-link">
                                <i class="fas fa-users"></i>
                                Học sinh
                            </a>
                            <a href="ManageQuestionServlet?courseId=${course.courseId}" class="sidebar-link active">
                                <i class="fas fa-question-circle"></i>
                                Câu hỏi
                            </a>
                        </nav>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <!-- Questions Page -->
                    <div class="questions-page">
                        <!-- Navigation Tabs -->
                        <div class="questions-nav">
                            <div class="nav-tabs">
                                <!--                                <a href="#" class="nav-tab">Ngân hàng câu hỏi</a>-->
                                <a href="#" class="nav-tab active">Câu hỏi</a>
                            </div>
                        </div>

                        <!-- Filter and Search Section -->
                        <div class="questions-filter">
                            <div class="filter-left">
                                <button class="btn btn-outline">
                                    <i class="fas fa-filter"></i>
                                    Bộ lọc
                                </button>

                                <div class="search-input">
                                    <input type="text" placeholder="Tiêu đề">
                                    <i class="fas fa-search"></i>
                                </div>
                            </div>
                            <div class="filter-right">

                                <div class="dropdown">
                                    <button class="btn btn-outline dropdown-toggle">
                                        Sắp xếp theo
                                    </button>
                                </div>
                                <a href="addQuestion?courseId=${param.courseId}" class="btn btn-primary">
                                    <i class="fas fa-plus"></i>
                                    Thêm câu hỏi
                                </a>
                            </div>
                        </div>

                        <!-- Questions Content -->
                        <div class="questions-content">
                            <div class="table-container">
                                <table class="questions-table">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Tên Module</th>
                                            <th>Số câu hỏi</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <c:forEach var="entry" items="${moduleQuestionMap}" varStatus="status">
                                            <tr>
                                                <td>${entry.key.orderIndex}</td>
                                                <td>${entry.key.title}</td>
                                                <td>${entry.value}</td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="updateQuestion?courseId=${course.courseId}&moduleId=${entry.key.moduleId}" 
                                                           class="btn btn-view">
                                                            <i class="fas fa-eye"></i>
                                                            Xem
                                                        </a>
                                                        <a href="add-questions.jsp?courseId=${param.courseId}&moduleId=${module.moduleId}" 
                                                           class="btn btn-edit">
                                                            <i class="fas fa-edit"></i>
                                                            Chỉnh sửa
                                                        </a>
                                                        <a href="deleteModule?courseId=${param.courseId}&moduleId=${module.moduleId}" 
                                                           class="btn btn-delete"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa module này không?')">
                                                            <i class="fas fa-trash"></i>
                                                            Xóa
                                                        </a>
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

        <script>
            // Add any specific JavaScript for questions page here
            document.addEventListener('DOMContentLoaded', function () {
                // Initialize any page-specific functionality
                console.log('Questions page loaded');
            });
        </script>
    </body>
</html>
