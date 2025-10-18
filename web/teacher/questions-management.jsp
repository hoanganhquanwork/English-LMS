<%-- 
    Document   : questions-management
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
        <title>Quản lý Câu hỏi</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .container {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                max-width: 1400px;
                margin-left: auto;
                margin-right: auto;
                padding: 0 20px;
            }

            .questions-management-container {
                flex: 1;
                min-width: 0;
            }

            .page-header {
                margin-bottom: 30px;
            }

            .page-title {
                font-size: 28px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .page-subtitle {
                color: #7f8c8d;
                font-size: 16px;
            }

            /* Tab Navigation */
            .tab-navigation {
                display: flex;
                border-bottom: 2px solid #e9ecef;
                margin-bottom: 30px;
            }

            .tab-button {
                padding: 12px 24px;
                background: none;
                border: none;
                font-size: 16px;
                font-weight: 500;
                color: #6c757d;
                cursor: pointer;
                border-bottom: 3px solid transparent;
                transition: all 0.3s ease;
            }

            .tab-button.active {
                color: #2c3e50;
                border-bottom-color: #3498db;
            }

            .tab-button:hover {
                color: #2c3e50;
                background-color: #f8f9fa;
            }

            /* Tab Content */
            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            /* Filter Section */
            .filter-section {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .filter-row {
                display: flex;
                gap: 15px;
                align-items: center;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .filter-label {
                font-weight: 500;
                color: #2c3e50;
                font-size: 14px;
            }

            .filter-select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                min-width: 200px;
            }

            .filter-button {
                padding: 8px 16px;
                background: #3498db;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: background 0.3s;
            }

            .filter-button:hover {
                background: #2980b9;
            }

            /* Table Styles */
            .table-container {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
                padding: 12px 16px;
                border-bottom: 1px solid #e9ecef;
                vertical-align: middle;
                font-size: 14px;
            }

            .questions-table tr:hover {
                background: #f8f9fa;
            }

            .question-content {
                max-width: 900px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                line-height: 1.4;
            }


            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .status-draft {
                background: #fff3cd;
                color: #856404;
            }

            .status-submitted {
                background: #d1ecf1;
                color: #0c5460;
            }

            .status-approved {
                background: #d4edda;
                color: #155724;
            }

            .status-rejected {
                background: #f8d7da;
                color: #721c24;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }

            .btn {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .btn-edit {
                background: #f39c12;
                color: white;
            }

            .btn-edit:hover {
                background: #e67e22;
            }

            .btn-delete {
                background: #e74c3c;
                color: white;
            }

            .btn-delete:hover {
                background: #c0392b;
            }

            .btn-view {
                background: #3498db;
                color: white;
            }

            .btn-view:hover {
                background: #2980b9;
            }

            /* Add Question Form */
            .add-question-form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #2c3e50;
            }

            .form-input, .form-textarea, .form-select {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .form-textarea {
                min-height: 100px;
                resize: vertical;
            }

            .form-row {
                display: flex;
                gap: 15px;
            }

            .form-row .form-group {
                flex: 1;
            }

            .btn-primary {
                background: #3498db;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
            }

            .btn-primary:hover {
                background: #2980b9;
            }

            .empty-state {
                text-align: center;
                padding: 40px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #dee2e6;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                    gap: 15px;
                }
                
                .filter-row {
                    flex-direction: column;
                    align-items: stretch;
                }
                
                .filter-group {
                    width: 100%;
                }
                
                .filter-select {
                    min-width: auto;
                }
                
                .form-row {
                    flex-direction: column;
                }
                
                .action-buttons {
                    flex-wrap: wrap;
                }
                
                .btn {
                    font-size: 11px;
                    padding: 4px 8px;
                }
            }

            /* Sidebar Integration */
            .admin-sidebar {
                width: 250px;
                flex-shrink: 0;
            }

            .admin-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .admin-menu {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .admin-link {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 15px;
                color: #6c757d;
                text-decoration: none;
                border-radius: 6px;
                transition: all 0.3s ease;
                font-size: 14px;
                font-weight: 500;
            }

            .admin-link:hover {
                background: #f8f9fa;
                color: #2c3e50;
            }

            .admin-link.active {
                background: #e3f2fd;
                color: #1976d2;
                border-left: 3px solid #1976d2;
            }

            /* Add Questions Form Styles */
            .add-questions-form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            .questions-content-area {
                min-height: 200px;
                border: 2px dashed #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .empty-questions {
                text-align: center;
                color: #6c757d;
                font-style: italic;
            }

            .actions {
                display: flex;
                gap: 15px;
                align-items: center;
                justify-content: space-between;
            }

            /* Dropdown Styles */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-toggle {
                display: flex;
                align-items: center;
                gap: 8px;
                position: relative;
            }

            .dropdown-toggle i {
                transition: transform 0.3s;
            }

            .dropdown-toggle.active i {
                transform: rotate(180deg);
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                background: white;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                min-width: 250px;
                display: none;
                margin-top: 5px;
            }

            .dropdown-menu.show {
                display: block;
            }

            .dropdown-item {
                padding: 12px 16px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                color: #2c3e50;
                transition: background 0.2s;
                border-bottom: 1px solid #f0f0f0;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                background: #f8f9fa;
            }

            .dropdown-item i {
                width: 20px;
                text-align: center;
                font-size: 16px;
            }

            .dropdown-item:first-child i {
                color: #3498db;
            }

            .dropdown-item:last-child i {
                color: #27ae60;
            }

            .btn-success {
                background: #27ae60;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-success:hover {
                background: #229954;
            }

            /* Question Form Styles */
            .question-form, .text-question-form {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .question-header, .text-question-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #dee2e6;
            }

            .question-number, .text-question-number {
                font-weight: 600;
                color: #2c3e50;
                font-size: 16px;
            }

            .text-question-type {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #27ae60;
                font-size: 14px;
                font-weight: 500;
            }

            .question-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: white;
                resize: vertical;
                min-height: 80px;
            }

            .question-input:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .answer-options {
                margin: 15px 0;
            }

            .answer-option {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
                padding: 10px;
                background: white;
                border-radius: 6px;
                border: 1px solid #e9ecef;
            }

            .correct-answer-checkbox {
                display: none;
            }

            .correct-answer-label {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 24px;
                height: 24px;
                border: 2px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .correct-answer-checkbox:checked + .correct-answer-label {
                background: #27ae60;
                border-color: #27ae60;
                color: white;
            }

            .answer-input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .remove-option-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 6px 10px;
                cursor: pointer;
                font-size: 12px;
            }

            .remove-option-btn:hover {
                background: #c0392b;
            }

            .add-option-btn {
                background: #3498db;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                cursor: pointer;
                font-size: 14px;
                margin-top: 10px;
            }

            .add-option-btn:hover {
                background: #2980b9;
            }

            .file-upload-group {
                margin: 15px 0;
            }

            .file-upload-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .file-upload-input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .file-info {
                font-size: 12px;
                color: #6c757d;
                margin-top: 5px;
            }

            .answer-group {
                margin-bottom: 16px;
            }

            .answer-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .explanation-group {
                margin-top: 15px;
            }

            .explanation-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: white;
                resize: vertical;
                min-height: 60px;
            }

            .explanation-input:focus {
                outline: none;
                border-color: #27ae60;
                box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.1);
            }

            .delete-question-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: auto;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .delete-question-btn:hover {
                background: #c0392b;
            }

            /* Questions Header Styles */
            .questions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .questions-title {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }

            .questions-actions {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .btn-outline {
                background: transparent;
                color: #6c757d;
                border: 2px solid #6c757d;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-outline:hover {
                background: #6c757d;
                color: white;
            }

            .btn-primary {
                background: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary:hover {
                background: #0056b3;
            }

            /* Checkbox Styles */
            .question-checkbox, #selectAll {
                width: 18px;
                height: 18px;
                cursor: pointer;
                accent-color: #007bff;
            }

            .question-checkbox:checked, #selectAll:checked {
                background-color: #007bff;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                animation: fadeIn 0.3s ease;
            }

            .modal.show {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-content {
                background: white;
                border-radius: 12px;
                padding: 30px;
                max-width: 800px;
                width: 90%;
                max-height: 90vh;
                overflow-y: auto;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                animation: slideInUp 0.3s ease;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e9ecef;
            }

            .modal-title {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }

            .close-btn {
                background: none;
                border: none;
                font-size: 24px;
                color: #6c757d;
                cursor: pointer;
                padding: 5px;
                border-radius: 4px;
                transition: all 0.3s;
            }

            .close-btn:hover {
                background: #f8f9fa;
                color: #2c3e50;
            }

            .modal-body {
                margin-bottom: 25px;
            }

            .modal-footer {
                display: flex;
                gap: 15px;
                justify-content: flex-end;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn-cancel {
                background: #6c757d;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-cancel:hover {
                background: #5a6268;
            }

            .btn-save {
                background: #28a745;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-save:hover {
                background: #218838;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
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
                        <a href="instructorDashboard">Dashboard</a>
                        <a href="manage">Khóa học</a>
                        <a href="questions" class="active">Câu hỏi</a>
                    </div>
                    <button class="hamburger">
                        <i class="fas fa-bars"></i>
                    </button>
                </nav>
            </div>
        </header>

        <div class="container">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp" />
            
            <div class="questions-management-container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1 class="page-title">Quản lý Câu hỏi</h1>
                    <p class="page-subtitle">Quản lý và tạo câu hỏi cho khóa học của bạn</p>
                </div>

                <!-- Tab Navigation -->
                <div class="tab-navigation">
                    <button class="tab-button active" onclick="showTab('question-bank')">
                        Ngân hàng câu hỏi
                    </button>
                    <button class="tab-button" onclick="showTab('questions')">
                        Câu hỏi
                    </button>
                </div>

                <!-- Question Bank Tab -->
                <div id="question-bank" class="tab-content active">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form method="GET" action="questions">
                            <div class="filter-row">
                                <div class="filter-group">
                                    <label class="filter-label">Lọc theo chủ đề:</label>
                                    <select name="topicId" class="filter-select">
                                        <option value="">Tất cả chủ đề</option>
                                        <c:forEach var="topic" items="${topics}">
                                            <option value="${topic.topicId}" 
                                                    ${selectedTopicId == topic.topicId ? 'selected' : ''}>
                                                ${topic.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="filter-button">
                                    <i class="fas fa-filter"></i> Lọc
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Questions Table -->
                    <div class="table-container">
                        <table class="questions-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nội dung câu hỏi</th>
                                    <th>Chủ đề</th>
                                    <th>Loại</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty filteredQuestions}">
                                        <c:forEach var="question" items="${filteredQuestions}">
                                            <tr>
                                                <td>${question.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${question.content}">
                                                        ${fn:substring(question.content, 0, 50)}...
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.topicId != null}">
                                                            <c:forEach var="topic" items="${topics}">
                                                                <c:if test="${topic.topicId == question.topicId}">
                                                                    ${topic.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>Không có</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.type == 'mcq_single'}">Trắc nghiệm</c:when>
                                                        <c:when test="${question.type == 'text'}">Tự luận</c:when>
                                                        <c:otherwise>${question.type}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${question.status}">
                                                        <c:choose>
                                                            <c:when test="${question.status == 'draft'}">Nháp</c:when>
                                                            <c:when test="${question.status == 'submitted'}">Đã gửi</c:when>
                                                            <c:when test="${question.status == 'approved'}">Đã duyệt</c:when>
                                                            <c:when test="${question.status == 'rejected'}">Từ chối</c:when>
                                                            <c:otherwise>${question.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="#" class="btn btn-view">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>
                                                         <a href="#" class="btn btn-edit" onclick="openEditModal(${question.questionId}, '${fn:escapeXml(question.content)}', '${question.type}', '${question.topicId}', '${question.status}', '${fn:escapeXml(question.explanation)}')">
                                                             <i class="fas fa-edit"></i> Sửa
                                                         </a>
                                                        <a href="#" class="btn btn-delete">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="question" items="${allQuestions}">
                                            <tr>
                                                <td>${question.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${question.content}">
                                                        ${fn:substring(question.content, 0, 50)}...
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.topicId != null}">
                                                            <c:forEach var="topic" items="${topics}">
                                                                <c:if test="${topic.topicId == question.topicId}">
                                                                    ${topic.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>Không có</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.type == 'mcq_single'}">Trắc nghiệm</c:when>
                                                        <c:when test="${question.type == 'text'}">Tự luận</c:when>
                                                        <c:otherwise>${question.type}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${question.status}">
                                                        <c:choose>
                                                            <c:when test="${question.status == 'draft'}">Nháp</c:when>
                                                            <c:when test="${question.status == 'submitted'}">Đã gửi</c:when>
                                                            <c:when test="${question.status == 'approved'}">Đã duyệt</c:when>
                                                            <c:when test="${question.status == 'rejected'}">Từ chối</c:when>
                                                            <c:otherwise>${question.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="#" class="btn btn-view">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>
                                                         <a href="#" class="btn btn-edit" onclick="openEditModal(${question.questionId}, '${fn:escapeXml(question.content)}', '${question.type}', '${question.topicId}', '${question.status}', '${fn:escapeXml(question.explanation)}')">
                                                             <i class="fas fa-edit"></i> Sửa
                                                         </a>
                                                        <a href="#" class="btn btn-delete">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Questions Tab -->
                <div id="questions" class="tab-content">
                    <!-- Questions Header -->
                    <div class="questions-header">
                        <h3 class="questions-title">Câu hỏi của tôi</h3>
                        <div class="questions-actions">
                            <button type="button" class="btn btn-outline" onclick="selectTopic()">
                                <i class="fas fa-tags"></i> Chọn chủ đề
                            </button>
                            <button type="button" class="btn btn-primary" onclick="submitSelected()">
                                <i class="fas fa-paper-plane"></i> Submit
                            </button>
                        </div>
                    </div>
                    
                    <!-- Draft Questions Table -->
                    <div class="table-container">
                        <table class="questions-table">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="selectAll" onchange="toggleAllCheckboxes()">
                                    </th>
                                    <th>ID</th>
                                    <th>Nội dung câu hỏi</th>
                                    <th>Chủ đề</th>
                                    <th>Loại</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty draftQuestions}">
                                        <c:forEach var="question" items="${draftQuestions}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox" class="question-checkbox" value="${question.questionId}" onchange="updateSelectAll()">
                                                </td>
                                                <td>${question.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${question.content}">
                                                        ${fn:substring(question.content, 0, 50)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.topicId != null}">
                                                            <c:forEach var="topic" items="${topics}">
                                                                <c:if test="${topic.topicId == question.topicId}">
                                                                    ${topic.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>Không có</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.type == 'mcq_single'}">Trắc nghiệm</c:when>
                                                        <c:when test="${question.type == 'text'}">Tự luận</c:when>
                                                        <c:otherwise>${question.type}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${question.status}">
                                                        <c:choose>
                                                            <c:when test="${question.status == 'draft'}">Nháp</c:when>
                                                            <c:when test="${question.status == 'submitted'}">Đã gửi</c:when>
                                                            <c:when test="${question.status == 'approved'}">Đã duyệt</c:when>
                                                            <c:when test="${question.status == 'rejected'}">Từ chối</c:when>
                                                            <c:otherwise>${question.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                       
                                                         <a href="#" class="btn btn-edit" onclick="openEditModal(${question.questionId}, '${fn:escapeXml(question.content)}', '${question.type}', '${question.topicId}', '${question.status}', '${fn:escapeXml(question.explanation)}')">
                                                             <i class="fas fa-edit"></i> Sửa
                                                         </a>
                                                        <a href="#" class="btn btn-delete">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="empty-state">
                                                <i class="fas fa-question-circle"></i>
                                                <p>Chưa có câu hỏi nháp nào</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Add Questions Form -->
                    <div class="add-questions-form">
                        <h3>Thêm câu hỏi mới</h3>
                        <form action="addQuestion" method="post" enctype="multipart/form-data" id="bulkQuestionForm">
                            <div id="questionsList" class="questions-content-area">
                                <div class="empty-questions">
                                    <p>Chưa có câu hỏi nào được thêm</p>
                                </div>
                            </div>

                            <div class="actions">
                                <div class="dropdown">
                                    <button type="button" class="btn btn-primary dropdown-toggle" onclick="toggleDropdown()">
                                        + Thêm câu hỏi
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <div class="dropdown-menu" id="questionTypeDropdown">
                                        <div class="dropdown-item" onclick="addQuestion('mcq_single')">
                                            <i class="fas fa-check-circle"></i>
                                            Câu hỏi lựa chọn 1 đáp án
                                        </div>
                                        <div class="dropdown-item" onclick="addTextQuestion()">
                                            <i class="fas fa-file-text"></i>
                                            Câu hỏi dạng text
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-success">Lưu tất cả</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Question Modal -->
        <div id="editQuestionModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Chỉnh sửa câu hỏi</h2>
                    <button class="close-btn" onclick="closeEditModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="editQuestionForm">
                        <input type="hidden" id="editQuestionId" name="questionId">
                        
                        <div class="form-group">
                            <label class="form-label">Nội dung câu hỏi *</label>
                            <textarea id="editQuestionContent" name="content" class="form-textarea" placeholder="Nhập nội dung câu hỏi..." required></textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Chủ đề</label>
                                <select id="editQuestionTopic" name="topicId" class="form-select">
                                    <option value="">Chọn chủ đề</option>
                                    <c:forEach var="topic" items="${topics}">
                                        <option value="${topic.topicId}">${topic.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Loại câu hỏi *</label>
                                <select id="editQuestionType" name="type" class="form-select" required>
                                    <option value="">Chọn loại</option>
                                    <option value="mcq_single">Trắc nghiệm</option>
                                    <option value="text">Tự luận</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- MCQ Options (shown when type is mcq_single) -->
                        <div id="editMcqOptions" class="form-group" style="display: none;">
                            <label class="form-label">Các phương án trả lời</label>
                            <div id="editAnswerOptions">
                                <!-- Options will be dynamically added here -->
                            </div>
                            <button type="button" class="add-option-btn" onclick="addEditOption()">
                                <i class="fas fa-plus"></i> Thêm phương án
                            </button>
                        </div>
                        
                        <!-- Text Answer (shown when type is text) -->
                        <div id="editTextAnswer" class="form-group" style="display: none;">
                            <label class="form-label">Đáp án đúng *</label>
                            <textarea id="editCorrectAnswer" name="correctAnswer" class="form-textarea" placeholder="Nhập đáp án đúng..."></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Giải thích đáp án</label>
                            <textarea id="editQuestionExplanation" name="explanation" class="form-textarea" placeholder="Nhập giải thích cho đáp án..."></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Trạng thái</label>
                            <select id="editQuestionStatus" name="status" class="form-select">
                                <option value="draft">Nháp</option>
                                <option value="submitted">Đã gửi</option>
                                <option value="approved">Đã duyệt</option>
                                <option value="rejected">Từ chối</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Hủy</button>
                    <button type="button" class="btn-save" onclick="saveEditedQuestion()">Lưu thay đổi</button>
                </div>
            </div>
        </div>

        <script>
            let questionCount = 0;

            function showTab(tabName) {
                // Hide all tab contents
                const tabContents = document.querySelectorAll('.tab-content');
                tabContents.forEach(content => {
                    content.classList.remove('active');
                });
                
                // Remove active class from all tab buttons
                const tabButtons = document.querySelectorAll('.tab-button');
                tabButtons.forEach(button => {
                    button.classList.remove('active');
                });
                
                // Show selected tab content
                document.getElementById(tabName).classList.add('active');
                
                // Add active class to clicked button
                event.target.classList.add('active');
            }

            // Dropdown functions
            function toggleDropdown() {
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');

                if (dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                    toggle.classList.remove('active');
                } else {
                    dropdown.classList.add('show');
                    toggle.classList.add('active');
                }
            }

            // Close dropdown when clicking outside
            window.onclick = function (event) {
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');

                if (!event.target.closest('.dropdown')) {
                    dropdown.classList.remove('show');
                    toggle.classList.remove('active');
                }
            };

            function createOptionHTML(questionNumber) {
                let html = "";
                for (let i = 1; i <= 4; i++) {
                    html += '<div class="answer-option">';
                    html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + i + '" ';
                    html += '        id="correct-' + questionNumber + '-' + i + '" class="correct-answer-checkbox">';
                    html += '    <label for="correct-' + questionNumber + '-' + i + '" class="correct-answer-label">';
                    html += '        <i class="fas fa-check"></i>';
                    html += '    </label>';
                    html += '    <input type="text" name="optionContent' + questionNumber + '_' + i + '" ';
                    html += '        class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                    html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                    html += '        <i class="fas fa-trash"></i>';
                    html += '    </button>';
                    html += '</div>';
                }
                return html;
            }

            function addQuestion(type) {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                // Close dropdown
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');
                dropdown.classList.remove('show');
                toggle.classList.remove('active');

                // Bắt đầu ghép chuỗi HTML
                let html = '';
                html += '<div class="question-form" id="question-' + questionCount + '">';
                html += '    <div class="question-header">';
                html += '        <div class="question-number">Câu ' + questionCount + '.</div>';
                html += '        <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                html += '            <i class="fas fa-trash"></i>';
                html += '        </button>';
                html += '    </div>';

                html += '    <div class="question-content">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="' + type + '">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" ';
                html += '                class="question-input" placeholder="Nhập nội dung câu hỏi tại đây..." required></textarea>';
                html += '        </div>';

                // Gọi hàm sinh option (vì createOptionHTML trả về HTML)
                html += '        <div class="answer-options">' + createOptionHTML(questionCount) + '</div>';

                html += '        <button type="button" class="add-option-btn" onclick="addOption(' + questionCount + ')">';
                html += '            <i class="fas fa-plus"></i> Thêm phương án';
                html += '        </button>';

                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
                html += '                class="file-upload-input" accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png,.gif,.mp4,.avi,.mov,.wmv,.mp3,.wav,.m4a,.aac">';
                html += '            <div class="file-info">';
                html += '                Hỗ trợ: PDF, Word, Text, hình ảnh (JPG, PNG, GIF), video (MP4, AVI, MOV, WMV), âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';

                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                // Thêm vào danh sách
                list.insertAdjacentHTML("beforeend", html);
            }

            function deleteQuestion(number) {
                // Xóa toàn bộ phần câu hỏi theo id
                var question = document.getElementById("question-" + number);
                if (question) {
                    question.remove();
                }
            }

            function removeOption(button) {
                // Tìm div cha có class .answer-option và xóa nó
                var optionDiv = button.closest(".answer-option");
                if (optionDiv) {
                    optionDiv.remove();
                }
            }

            function addOption(questionNumber) {
                var optionsDiv = document.querySelector("#question-" + questionNumber + " .answer-options");
                var currentCount = optionsDiv.querySelectorAll(".answer-option").length;
                var newIndex = currentCount + 1;

                var html = '';
                html += '<div class="answer-option">';
                html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + newIndex + '" ';
                html += '        id="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-checkbox">';
                html += '    <label for="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-label">';
                html += '        <i class="fas fa-check"></i>';
                html += '    </label>';
                html += '    <input type="text" name="optionContent' + questionNumber + '_' + newIndex + '" ';
                html += '        class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                html += '        <i class="fas fa-trash"></i>';
                html += '    </button>';
                html += '</div>';

                optionsDiv.insertAdjacentHTML("beforeend", html);
            }

            function addTextQuestion() {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                // Close dropdown
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');
                dropdown.classList.remove('show');
                toggle.classList.remove('active');

                let html = '';
                html += '<div class="text-question-form" id="question-' + questionCount + '">';
                html += '    <div class="text-question-header">';
                html += '        <div class="text-question-number">Câu ' + questionCount + '.</div>';
                html += '        <div class="text-question-type">';
                html += '            <i class="fas fa-file-text"></i>';
                html += '            Câu hỏi dạng text';
                html += '        </div>';
                html += '        <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                html += '            <i class="fas fa-trash"></i>';
                html += '            Xóa';
                html += '        </button>';
                html += '    </div>';
                html += '    <div class="text-question-content">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="text">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" ';
                html += '                class="question-input" placeholder="Nhập nội dung câu hỏi tại đây..." required></textarea>';
                html += '        </div>';
                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
                html += '                class="file-upload-input" accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png,.gif,.mp4,.avi,.mov,.wmv,.mp3,.wav,.m4a,.aac">';
                html += '            <div class="file-info">';
                html += '                Hỗ trợ: PDF, Word, Text, hình ảnh (JPG, PNG, GIF), video (MP4, AVI, MOV, WMV), âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';
                html += '        <div class="answer-group">';
                html += '            <label class="answer-label">Đáp án đúng:</label>';
                html += '            <textarea name="correctAnswer' + questionCount + '" ';
                html += '                class="answer-input" placeholder="Nhập đáp án đúng cho câu hỏi này..." required></textarea>';
                html += '        </div>';
                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                list.insertAdjacentHTML("beforeend", html);
            }

            // Modal functions
            function openEditModal(questionId, content, type, topicId, status, explanation) {
                const modal = document.getElementById('editQuestionModal');
                const form = document.getElementById('editQuestionForm');
                
                // Populate form fields
                document.getElementById('editQuestionId').value = questionId;
                document.getElementById('editQuestionContent').value = content;
                document.getElementById('editQuestionType').value = type;
                document.getElementById('editQuestionTopic').value = topicId || '';
                document.getElementById('editQuestionStatus').value = status;
                document.getElementById('editQuestionExplanation').value = explanation || '';
                
                // Show/hide appropriate sections based on question type
                toggleEditQuestionType(type);
                
                // Show modal
                modal.classList.add('show');
                modal.style.display = 'flex';
            }
            
            function closeEditModal() {
                const modal = document.getElementById('editQuestionModal');
                modal.classList.remove('show');
                modal.style.display = 'none';
            }
            
            function toggleEditQuestionType(type) {
                const mcqOptions = document.getElementById('editMcqOptions');
                const textAnswer = document.getElementById('editTextAnswer');
                
                if (type === 'mcq_single') {
                    mcqOptions.style.display = 'block';
                    textAnswer.style.display = 'none';
                    // Load existing options if any
                    loadEditOptions();
                } else if (type === 'text') {
                    mcqOptions.style.display = 'none';
                    textAnswer.style.display = 'block';
                } else {
                    mcqOptions.style.display = 'none';
                    textAnswer.style.display = 'none';
                }
            }
            
            function loadEditOptions() {
                // This would typically load existing options from the database
                // For now, we'll add some default options
                const optionsContainer = document.getElementById('editAnswerOptions');
                optionsContainer.innerHTML = '';
                
                // Add 4 default options
                for (let i = 1; i <= 4; i++) {
                    addEditOption();
                }
            }
            
            function addEditOption() {
                const optionsContainer = document.getElementById('editAnswerOptions');
                const optionCount = optionsContainer.children.length + 1;
                
                const optionDiv = document.createElement('div');
                optionDiv.className = 'answer-option';
                optionDiv.innerHTML = `
                    <input type="checkbox" name="editCorrect${optionCount}" value="${optionCount}" 
                           id="editCorrect-${optionCount}" class="correct-answer-checkbox">
                    <label for="editCorrect-${optionCount}" class="correct-answer-label">
                        <i class="fas fa-check"></i>
                    </label>
                    <input type="text" name="editOptionContent${optionCount}" 
                           class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                    <button type="button" class="remove-option-btn" onclick="removeEditOption(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                `;
                
                optionsContainer.appendChild(optionDiv);
            }
            
            function removeEditOption(button) {
                const optionDiv = button.closest('.answer-option');
                if (optionDiv) {
                    optionDiv.remove();
                }
            }
            
            function saveEditedQuestion() {
                const form = document.getElementById('editQuestionForm');
                const formData = new FormData(form);
                
                // Validate form
                const content = document.getElementById('editQuestionContent').value.trim();
                const type = document.getElementById('editQuestionType').value;
                
                if (!content) {
                    alert('Vui lòng nhập nội dung câu hỏi!');
                    return;
                }
                
                if (!type) {
                    alert('Vui lòng chọn loại câu hỏi!');
                    return;
                }
                
                // For MCQ questions, validate that at least one option is provided
                if (type === 'mcq_single') {
                    const options = document.querySelectorAll('#editAnswerOptions .answer-input');
                    let hasContent = false;
                    options.forEach(option => {
                        if (option.value.trim()) {
                            hasContent = true;
                        }
                    });
                    
                    if (!hasContent) {
                        alert('Vui lòng nhập ít nhất một phương án trả lời!');
                        return;
                    }
                }
                
                // For text questions, validate correct answer
                if (type === 'text') {
                    const correctAnswer = document.getElementById('editCorrectAnswer').value.trim();
                    if (!correctAnswer) {
                        alert('Vui lòng nhập đáp án đúng!');
                        return;
                    }
                }
                
                // Here you would typically send the data to the server
                // For now, we'll just show a success message
                alert('Câu hỏi đã được cập nhật thành công!');
                closeEditModal();
                
                // Reload the page to show updated data
                // window.location.reload();
            }
            
            // Close modal when clicking outside
            window.onclick = function(event) {
                const modal = document.getElementById('editQuestionModal');
                if (event.target === modal) {
                    closeEditModal();
                }
            };
            
            // Handle question type change in modal
            document.addEventListener('DOMContentLoaded', function() {
                const typeSelect = document.getElementById('editQuestionType');
                if (typeSelect) {
                    typeSelect.addEventListener('change', function() {
                        toggleEditQuestionType(this.value);
                    });
                }
            });

            // Checkbox functionality
            function toggleAllCheckboxes() {
                const selectAll = document.getElementById('selectAll');
                const checkboxes = document.querySelectorAll('.question-checkbox');
                
                checkboxes.forEach(checkbox => {
                    checkbox.checked = selectAll.checked;
                });
            }
            
            function updateSelectAll() {
                const selectAll = document.getElementById('selectAll');
                const checkboxes = document.querySelectorAll('.question-checkbox');
                const checkedBoxes = document.querySelectorAll('.question-checkbox:checked');
                
                if (checkedBoxes.length === 0) {
                    selectAll.checked = false;
                    selectAll.indeterminate = false;
                } else if (checkedBoxes.length === checkboxes.length) {
                    selectAll.checked = true;
                    selectAll.indeterminate = false;
                } else {
                    selectAll.checked = false;
                    selectAll.indeterminate = true;
                }
            }
            
            // Button actions
            function selectTopic() {
                const selectedQuestions = getSelectedQuestions();
                if (selectedQuestions.length === 0) {
                    alert('Vui lòng chọn ít nhất một câu hỏi!');
                    return;
                }
                
                // Create topic selection modal
                const topicModal = document.createElement('div');
                topicModal.className = 'modal';
                topicModal.id = 'topicModal';
                topicModal.innerHTML = `
                    <div class="modal-content">
                        <div class="modal-header">
                            <h2 class="modal-title">Chọn chủ đề cho câu hỏi</h2>
                            <button class="close-btn" onclick="closeTopicModal()">&times;</button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label class="form-label">Chọn chủ đề:</label>
                                <select id="topicSelect" class="form-select">
                                    <option value="">Chọn chủ đề</option>
                                    <c:forEach var="topic" items="${topics}">
                                        <option value="${topic.topicId}">${topic.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <p>Đã chọn ${selectedQuestions.length} câu hỏi</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn-cancel" onclick="closeTopicModal()">Hủy</button>
                            <button type="button" class="btn-save" onclick="assignTopic()">Gán chủ đề</button>
                        </div>
                    </div>
                `;
                
                document.body.appendChild(topicModal);
                topicModal.classList.add('show');
                topicModal.style.display = 'flex';
            }
            
            function closeTopicModal() {
                const modal = document.getElementById('topicModal');
                if (modal) {
                    modal.remove();
                }
            }
            
            function assignTopic() {
                const topicId = document.getElementById('topicSelect').value;
                const selectedQuestions = getSelectedQuestions();
                
                if (!topicId) {
                    alert('Vui lòng chọn chủ đề!');
                    return;
                }
                
                if (selectedQuestions.length === 0) {
                    alert('Không có câu hỏi nào được chọn!');
                    return;
                }
                
                // Here you would typically send the data to the server
                alert(`Đã gán chủ đề cho ${selectedQuestions.length} câu hỏi!`);
                closeTopicModal();
                
                // Uncheck all checkboxes
                document.querySelectorAll('.question-checkbox').forEach(cb => cb.checked = false);
                document.getElementById('selectAll').checked = false;
            }
            
            function submitSelected() {
                const selectedQuestions = getSelectedQuestions();
                if (selectedQuestions.length === 0) {
                    alert('Vui lòng chọn ít nhất một câu hỏi!');
                    return;
                }
                
                if (confirm(`Bạn có chắc chắn muốn submit ${selectedQuestions.length} câu hỏi đã chọn?`)) {
                    // Here you would typically send the data to the server
                    alert(`Đã submit ${selectedQuestions.length} câu hỏi thành công!`);
                    
                    // Uncheck all checkboxes
                    document.querySelectorAll('.question-checkbox').forEach(cb => cb.checked = false);
                    document.getElementById('selectAll').checked = false;
                }
            }
            
            function getSelectedQuestions() {
                const checkboxes = document.querySelectorAll('.question-checkbox:checked');
                return Array.from(checkboxes).map(cb => cb.value);
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function() {
                console.log('Questions management page loaded');
            });
        </script>
    </body>
</html>
