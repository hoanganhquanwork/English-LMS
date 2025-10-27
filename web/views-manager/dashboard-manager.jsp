<<<<<<< HEAD
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
=======
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
>>>>>>> main
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
<<<<<<< HEAD
        <title>Manager Dashboard — EnglishLMS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="<c:url value='/css/manager-dashboard.css?v=63' />">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    </head>
    <body>
=======
        <title>Dashboard Manager</title>
           <link rel="stylesheet" href="<c:url value='/css/manager-style.css?v=31' />">
        <link rel="stylesheet" href="<c:url value='css/manager-revenue.css' />">
    </head>
    <body class="dashboard">
>>>>>>> main

        <jsp:include page="includes-manager/sidebar-manager.jsp" />

        <main class="main-content">
<<<<<<< HEAD
            <div class="topbar">
                <h2>Manager Dashboard</h2>
            </div>

            <section class="kpi">
                <div class="card">
                    <div class="icon blue"><i class="fa fa-book"></i></div>
                    <div><div class="meta">Total Courses</div><div class="value">${totalCourses}</div></div>
                </div>
                <div class="card">
                    <div class="icon green"><i class="fa fa-coins"></i></div>
                    <div>
                        <div class="meta">Revenue (30d)</div>
                        <div class="value">
                            <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0" />
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="icon orange"><i class="fa fa-user-tie"></i></div>
                    <div><div class="meta">Active Instructors</div><div class="value">${totalInstructors}</div></div>
                </div>
                <a href="coursemanager?status=submitted&keyword=&sort=newest" style="text-decoration:none; color:inherit;">
                    <div class="card" style="cursor:pointer;">
                        <div class="icon red"><i class="fa fa-hourglass-half"></i></div>
                        <div>
                            <div class="meta">Pending Approvals</div>
                            <div class="value">${pendingCourses}</div>
                        </div>
                    </div>
                </a>
            </section>

            <section class="dashboard-grid">
                <div>
                    <div class="card" style="margin-bottom:16px">
                        <div class="flex-between">
                            <h3>Revenue by Month (${currentYear})</h3>
                            <button class="btn btn-ghost btn-xs"
                                    onclick="window.location.href = '${pageContext.request.contextPath}/revenue-report'">
                                <i class="fa fa-eye"></i> Xem chi tiết
                            </button>
                        </div>
                        <div class="chart-wrap">
                            <canvas id="revChart"></canvas>
                        </div>
                    </div>

                    <div class="card" style="margin-bottom:16px">
                        <div class="flex-between">
                            <h3>Approved / Rejected Courses</h3>
                            <button class="btn btn-ghost btn-xs"
                                    onclick="window.location.href = '${pageContext.request.contextPath}/coursemanager'">
                                <i class="fa fa-eye"></i> Xem chi tiết
                            </button>
                        </div>

                        <div class="table-scroll">
                            <table class="table">
                                <thead><tr><th>Course</th><th>Instructor</th><th>Date</th><th>Status</th><th>Actions</th></tr></thead>
                                <tbody>
                                    <c:forEach var="c" items="${approvedRejected}" varStatus="loop">
                                        <tr>
                                            <td>${c.title}</td>
                                            <td>${c.createdBy.user.fullName}</td>
                                            <td>${createdDateList[loop.index]} ${createdTimeList[loop.index]}</td>
                                            <td><span class="status ${c.status}">${c.status}</span></td>
                                            <td>
                                                <div class="actions">
                                                    <button class="btn-icon view" title="Xem chi tiết"
                                                            onclick="window.location.href = '${pageContext.request.contextPath}/coursedetail?courseId=${c.courseId}'">
                                                        <i class="fa fa-eye"></i>
                                                    </button>

                                                    <c:choose>
                                                        <c:when test="${c.status eq 'submitted'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/dashboard-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="courseId" value="${c.courseId}">
                                                                <button type="submit" class="btn-icon green" title="Duyệt"><i class="fa fa-check"></i></button>
                                                            </form>
                                                            <button type="button" class="btn-icon red" title="Từ chối" onclick="openRejectModal(${c.courseId})">
                                                                <i class="fa fa-xmark"></i>
                                                            </button>
                                                        </c:when>

                                                        <c:when test="${c.status eq 'approved'}">
                                                            <button type="button" class="btn-icon red" title="Từ chối lại" onclick="openRejectModal(${c.courseId})">
                                                                <i class="fa fa-xmark"></i>
                                                            </button>
                                                        </c:when>

                                                        <c:when test="${c.status eq 'rejected'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/dashboard-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="courseId" value="${c.courseId}">
                                                                <button type="submit" class="btn-icon green" title="Duyệt lại"><i class="fa fa-check"></i></button>
                                                            </form>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card">
                        <div class="flex-between">
                            <h3>Published / Unpublished Courses</h3>
                            <button class="btn btn-ghost btn-xs"
                                    onclick="window.location.href = '${pageContext.request.contextPath}/coursepublish'">
                                <i class="fa fa-eye"></i> Xem chi tiết
                            </button>
                        </div>
                        <div class="table-scroll">
                            <table class="table">
                                <thead><tr><th>Course</th><th>Instructor</th><th>Date</th><th>Status</th><th>Actions</th></tr></thead>
                                <tbody>
                                    <c:forEach var="c" items="${publishedUnpublished}" varStatus="loop">
                                        <tr>
                                            <td>${c.title}</td>
                                            <td>${c.createdBy.user.fullName}</td>
                                            <td>${createdDateList[loop.index]} ${createdTimeList[loop.index]}</td>
                                            <td><span class="status ${c.status}">${c.status}</span></td>
                                            <td>
                                                <div class="actions">
                                                    <button class="btn-icon view" title="Xem chi tiết"
                                                            onclick="window.location.href = '${pageContext.request.contextPath}/coursedetail?courseId=${c.courseId}'">
                                                        <i class="fa fa-eye"></i>
                                                    </button>

                                                    <c:choose>
                                                        <c:when test="${c.status eq 'publish'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/dashboard-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="unpublish">
                                                                <input type="hidden" name="courseId" value="${c.courseId}">
                                                                <button type="submit" class="btn-icon download" title="Gỡ đăng"><i class="fas fa-download"></i></button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${c.status eq 'unpublish'}">
                                                            <button type="button" class="btn-icon upload" title="Đặt lịch đăng" onclick="openScheduleModal(${c.courseId})">
                                                                <i class="fas fa-upload"></i>
                                                            </button>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div>
                    <div class="card" style="margin-bottom:16px">
                        <h3>Course Status Overview</h3>
                        <div class="chart-wrap"><canvas id="statusChart"></canvas></div>
                    </div>
                </div>
            </section>

            <div id="rejectModal" class="modal">
                <div class="modal-content">
                    <h3>Nhập lý do từ chối</h3>
                    <form method="post" action="<c:url value='/dashboard-manager'/>">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="courseId" id="rejectCourseId">
                        <textarea name="rejectReason" required placeholder="Nhập lý do..."></textarea>
                        <div class="modal-buttons">
                            <button type="submit" class="btn btn-danger">Gửi</button>
                            <button type="button" class="btn btn-secondary" onclick="closeRejectModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="scheduleModal" class="modal">
                <div class="modal-content">
                    <h3>Chọn ngày xuất bản</h3>
                    <form method="post" action="<c:url value='/dashboard-manager'/>">
                        <input type="hidden" name="action" value="publish">
                        <input type="hidden" name="courseId" id="scheduleCourseId">
                        <div class="form-group">
                            <label for="publishDate">Ngày đăng:</label>
                            <input type="date" name="publishDate" id="publishDate" required>
                        </div>
                        <div class="modal-buttons">
                            <button type="submit" class="btn btn-primary">Lưu lịch</button>
                            <button type="button" class="btn btn-secondary" onclick="closeScheduleModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
        <script>

            const reportType = "month";
            const reports = [
            <c:forEach var="r" items="${monthlyRevenue}" varStatus="s">
            {
            label: "T${r.month}/${r.year}",
                    totalRevenue: ${r.totalRevenue != null ? r.totalRevenue.doubleValue() : 0.0}
            }${!s.last ? ',' : ''}
            </c:forEach>
            ];

            const labels = reports.map(r => r.label);
            const dataRevenue = reports.map(r => r.totalRevenue);

            const baseOptions = {
                responsive: true,
                maintainAspectRatio: false,
                animation: false,
                plugins: {
                    datalabels: {
                        anchor: 'end',
                        align: 'top',
                        color: '#333'
                    },
                    legend: {display: false},
                    title: {
                        display: true,
                        text: 'Doanh thu theo tháng (₫)',
                        font: {size: 18}
                    }
                },
                scales: {
                    x: {
                        grid: {display: false},
                        ticks: {
                            maxRotation: 0,
                            minRotation: 0,
                            autoSkip: false,
                            font: {size: 12}
                        }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: v => v.toLocaleString('vi-VN') + ' ₫'
                        },
                        grid: {color: '#e5e7eb'}
                    }
                }
            };

            const ctxRevenue = document.getElementById('revChart').getContext('2d');
            new Chart(ctxRevenue, {
                type: 'bar',
                data: {
                    labels,
                    datasets: [{
                            label: 'Doanh thu (₫)',
                            data: dataRevenue,
                            backgroundColor: 'rgba(79,70,229,0.6)',
                            borderRadius: 6
                        }]
                },
                options: {
                    ...baseOptions,
                    scales: {
                        ...baseOptions.scales,
                        y: {
                            ...baseOptions.scales.y,
                            suggestedMax: Math.max(...dataRevenue, 0) * 1.2
                        }
                    }
                }
            });



            const statusLabels = [
            <c:forEach var="s" items="${statusLabels}" varStatus="loop">
            "${s}"${!loop.last ? ',' : ''}
            </c:forEach>
            ];

            const statusCounts = [
            <c:forEach var="v" items="${statusValues}" varStatus="loop">
                ${v}${!loop.last ? ',' : ''}
            </c:forEach>
            ];

            new Chart(document.getElementById("statusChart").getContext("2d"), {
                type: "doughnut",
                data: {
                    labels: statusLabels,
                    datasets: [{
                            data: statusCounts,
                            backgroundColor: [
                                '#10b981',
                                '#f59e0b',
                                '#3b82f6',
                                '#6366f1',
                                '#9ca3af',
                                '#ef4444'
                            ]
                        }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                font: {size: 12}
                            }
                        },
                        title: {
                            display: true,
                            text: 'Tổng quan trạng thái khóa học',
                            font: {size: 16}
                        }
                    }
                }
            });


            function openRejectModal(id) {
                document.getElementById('rejectCourseId').value = id;
                document.getElementById('rejectModal').style.display = 'flex';
            }
            function closeRejectModal() {
                document.getElementById('rejectModal').style.display = 'none';
            }
            function openScheduleModal(id) {
                document.getElementById('scheduleCourseId').value = id;
                document.getElementById('scheduleModal').style.display = 'flex';
            }
            function closeScheduleModal() {
                document.getElementById('scheduleModal').style.display = 'none';
            }
        </script>
=======
            <div class="container">
                <h1>Xin chào, ${sessionScope.user.fullName} 👋</h1>
                <p>Đây là dashboard dành cho Manager.</p>

                <ul>
                    <li><a href="manager-profile">Hồ sơ cá nhân</a></li>
                    <li><a href="coursemanager">Quản lý khóa học</a></li>
                </ul>
            </div>
        </main>
>>>>>>> main
    </body>
</html>