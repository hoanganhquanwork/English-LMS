<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chấm Assignment</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/teacher-common.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px 0;
                margin-bottom: 30px;
                border-radius: 0 0 20px 20px;
            }

            .page-title {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .page-subtitle {
                font-size: 16px;
                opacity: 0.9;
            }

            .assignments-container {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .assignments-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
            }

            .assignments-title {
                font-size: 20px;
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }

            .assignments-table {
                width: 100%;
                border-collapse: collapse;
            }

            .assignments-table th {
                background: #f8f9fa;
                color: #495057;
                font-weight: 600;
                padding: 15px 20px;
                text-align: left;
                border-bottom: 2px solid #e9ecef;
                font-size: 14px;
            }

            .assignments-table td {
                padding: 20px;
                border-bottom: 1px solid #e9ecef;
                vertical-align: middle;
            }

            .assignments-table tr:hover {
                background: #f8f9fa;
            }

            .assignment-info {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .assignment-title {
                font-weight: 600;
                color: #2c3e50;
                font-size: 16px;
                margin-bottom: 4px;
            }

            .assignment-course {
                color: #6c757d;
                font-size: 14px;
            }

            .assignment-meta {
                display: flex;
                flex-direction: column;
                gap: 4px;
                font-size: 14px;
                color: #6c757d;
            }

            .submission-count {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: #e3f2fd;
                color: #1976d2;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .submission-count i {
                font-size: 10px;
            }

            .grade-btn {
                background: #28a745;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .grade-btn:hover {
                background: #218838;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
            }

            .grade-btn:disabled {
                background: #6c757d;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
            }

            .status-pending {
                background: #fff3cd;
                color: #856404;
            }

            .status-graded {
                background: #d4edda;
                color: #155724;
            }

            .status-partial {
                background: #d1ecf1;
                color: #0c5460;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 48px;
                color: #dee2e6;
                margin-bottom: 16px;
            }

            .empty-state h3 {
                font-size: 18px;
                margin-bottom: 8px;
                color: #495057;
            }

            .empty-state p {
                font-size: 14px;
                margin: 0;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #007bff;
                text-decoration: none;
                font-size: 14px;
                margin-bottom: 20px;
                transition: color 0.3s;
            }

            .back-link:hover {
                color: #0056b3;
                text-decoration: underline;
            }

            .filter-section {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
            }

            .filter-row {
                display: flex;
                gap: 20px;
                align-items: center;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .filter-group label {
                font-size: 14px;
                font-weight: 500;
                color: #495057;
            }

            .filter-group select,
            .filter-group input {
                padding: 8px 12px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                font-size: 14px;
                background: white;
            }

            .filter-group select:focus,
            .filter-group input:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            }

            .search-box {
                position: relative;
                flex: 1;
                min-width: 200px;
            }

            .search-box input {
                padding-left: 40px;
            }

            .search-box i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }

            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                    align-items: stretch;
                }

                .search-box {
                    min-width: auto;
                }

                .assignments-table {
                    font-size: 14px;
                }

                .assignments-table th,
                .assignments-table td {
                    padding: 12px 8px;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-header">
            <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
                <h1 class="page-title">
                    <i class="fas fa-graduation-cap"></i>
                    Chấm Assignment
                </h1>
                <p class="page-subtitle">Quản lý và chấm điểm các bài tập của học viên</p>
            </div>
        </div>

        <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
            <a href="manage" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Quay lại Dashboard
            </a>

            <div class="assignments-container">
                <!-- Filter Section -->


                <!-- Assignments Table -->
                <div class="assignments-header">
                    <h2 class="assignments-title">
                        <i class="fas fa-list"></i>
                        Danh sách Assignment
                    </h2>
                </div>


                <c:choose>
                    <c:when test="${not empty works}">
                        <table class="assignments-table">
                            <thead>
                                <tr>
                                    <th>Assignment</th>
                                    <th>Khóa học</th>

                                    <th>Trạng thái</th>
                                    <th>Điểm</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>

                                <c:forEach var="w" items="${works}">
                                    <tr>
                                        <td>
                                            <div class="assignment-info">
                                                <div class="assignment-title">${w.assignment.title}</div>
                                                <div class="assignment-course">Module: ${w.assignment.assignmentId.module.title}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="assignment-meta">
                                                <span>${w.assignment.assignmentId.module.title}</span>
                                            </div>
                                        </td>

                                        <td>
                                            <span class="status-badge
                                                  ${w.status == 'passed' ? 'status-graded' 
                                                    : (w.status == 'submitted' ? 'status-pending' 
                                                    : (w.status == 'returned' ? 'status-partial' : ''))}">
                                                      ${w.status}
                                                  </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${w.score != null}">${w.score}</c:when>
                                                    <c:otherwise>Chưa chấm</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="gradeAssignment?assignmentId=${w.assignment.assignmentId.moduleItemId}&studentId=${w.student.userId}"
                                                   class="grade-btn">
                                                    <i class="fas fa-edit"></i> Chấm bài
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-clipboard-list"></i>
                                <h3>Chưa có assignment nào</h3>
                                <p>Hiện tại chưa có assignment nào để chấm điểm.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <script>
                // Search functionality
                document.getElementById('searchInput').addEventListener('input', function () {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll('.assignments-table tbody tr');

                    rows.forEach(row => {
                        const title = row.querySelector('.assignment-title').textContent.toLowerCase();
                        const course = row.querySelector('.assignment-course').textContent.toLowerCase();
                        const courseTitle = row.querySelector('.assignment-meta span').textContent.toLowerCase();

                        if (title.includes(searchTerm) || course.includes(searchTerm) || courseTitle.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });

                // Filter functionality
                document.getElementById('courseFilter').addEventListener('change', function () {
                    const selectedCourse = this.value;
                    const rows = document.querySelectorAll('.assignments-table tbody tr');

                    rows.forEach(row => {
                        if (selectedCourse === '' || row.dataset.courseId === selectedCourse) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });

                document.getElementById('statusFilter').addEventListener('change', function () {
                    const selectedStatus = this.value;
                    const rows = document.querySelectorAll('.assignments-table tbody tr');

                    rows.forEach(row => {
                        const statusBadge = row.querySelector('.status-badge');
                        if (selectedStatus === '') {
                            row.style.display = '';
                        } else if (statusBadge.classList.contains('status-' + selectedStatus)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            </script>
        </body>
    </html>

