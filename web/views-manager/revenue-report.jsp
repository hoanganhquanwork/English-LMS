<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Báo cáo doanh thu</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="<c:url value='/css/manager-style.css?v=3213' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    </head>

    <body>
        <jsp:include page="includes-manager/sidebar-manager.jsp" />

        <main class="main-content">
            <div class="container">

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fa fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <div class="page-header">
                    <div>
                        <h1>Báo cáo doanh thu</h1>
                        <p>Theo dõi số khóa học bán ra và tổng doanh thu theo tháng hoặc năm</p>
                    </div>
                </div>

                <form method="get" action="revenue-report" class="filter-panel">
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label>Chọn kiểu xem</label>
                            <select name="type" id="timeType">
                                <option value="month" ${reportType eq 'month' ? 'selected' : ''}>Theo tháng</option>
                                <option value="year" ${reportType eq 'year' ? 'selected' : ''}>Theo năm</option>
                            </select>
                        </div>

                        <c:if test="${reportType eq 'month'}">
                            <div class="filter-group">
                                <label>Năm</label>
                                <input type="number" name="year" value="${selectedYear}" min="2000" max="2100" />
                            </div>
                        </c:if>

                        <div class="filter-actions" style="display: flex; align-items: end; gap: 12px;">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-sync"></i> Cập nhật
                            </button>

                            <a href="${pageContext.request.contextPath}/revenue-export?type=${reportType}&year=${selectedYear}"
                               class="btn btn-outline">
                                <i class="fa fa-file-csv"></i> Xuất CSV
                            </a>
                        </div>
                    </div>
                </form>

                <div class="chart-toggle">
                    <button id="btnCourses" class="btn btn-toggle active" onclick="showChart('courses')">
                        <i class="fas fa-book-open"></i> Số khóa học bán ra
                    </button>
                    <button id="btnRevenue" class="btn btn-toggle" onclick="showChart('revenue')">
                        <i class="fas fa-dollar-sign"></i> Doanh thu
                    </button>
                </div>

                <div id="chartCoursesContainer" class="chart-container">
                    <canvas id="chartCourses"></canvas>
                </div>

                <div id="chartRevenueContainer" class="chart-container hidden">
                    <canvas id="chartRevenue"></canvas>
                </div>
            </div>
        </main>

        <script>
            const reportType = "${reportType}";
            const reports = [
            <c:forEach var="r" items="${reports}" varStatus="s">
            {
            label: "${reportType eq 'year' ? r.year : ('T' += r.month += '/' += r.year)}",
                    courseIdSold: ${r.courseIdSold},
                    totalRevenue: ${r.totalRevenue != null ? r.totalRevenue.doubleValue() : 0.0}
            }${!s.last ? ',' : ''}
            </c:forEach>
            ];
            const formattedReports = reports.map(r => {
                let label = "";
                if (reportType === "year") {
                    label = "Năm " + r.label;
                } else {
                    label =  r.label;
                }
                return {...r, label};
            });
            const labels = formattedReports.map(r => r.label);
            const dataCourses = formattedReports.map(r => r.courseIdSold);
            const dataRevenue = formattedReports.map(r => r.totalRevenue);

            const baseOptions = {
                responsive: true,
                maintainAspectRatio: false,
                animation: false,
                plugins: {
                    datalabels: {
                        anchor: 'end',
                        align: 'top',
                        color: '#333',
                        font: {weight: 'bold'},
                        formatter: v => v.toLocaleString('vi-VN')
                    },
                    legend: {display: false},
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: v => v.toLocaleString('vi-VN')
                        },
                        grid: {color: '#e5e7eb'}
                    },
                    x: {
                        grid: {display: false}
                    }
                }
            };

            const ctxCourses = document.getElementById('chartCourses').getContext('2d');
            new Chart(ctxCourses, {
                type: 'bar',
                data: {
                    labels,
                    datasets: [{
                            label: 'Số khóa học bán ra',
                            data: dataCourses,
                            backgroundColor: 'rgba(16,185,129,0.6)',
                            borderRadius: 6
                        }]
                },
                options: {
                    ...baseOptions,
                    scales: {
                        ...baseOptions.scales,
                        y: {
                            ...baseOptions.scales.y,
                            suggestedMax: Math.max(...dataCourses, 0) * 1.2,
                            ticks: {
                                callback: v => Math.round(v).toString() 
                            }
                        }
                    },
                    plugins: {
                        ...baseOptions.plugins,
                        datalabels: {
                            ...baseOptions.plugins.datalabels,
                            formatter: v => Math.round(v).toString() 
                        },
                        title: {
                            display: true,
                            text: reportType === 'year'
                                    ? 'Số khóa học bán ra theo năm'
                                    : 'Số khóa học bán ra theo tháng',
                            font: {size: 18}
                        }
                    }
                }
            });

            const ctxRevenue = document.getElementById('chartRevenue').getContext('2d');
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
                            suggestedMax: Math.max(...dataRevenue, 0) * 1.2, // ✅ scale riêng cho tiền
                            ticks: {
                                callback: v => v.toLocaleString('vi-VN') + ' ₫'
                            }
                        }
                    },
                    plugins: {
                        ...baseOptions.plugins,
                        title: {
                            display: true,
                            text: reportType === 'year'
                                    ? 'Doanh thu theo năm'
                                    : 'Doanh thu theo tháng',
                            font: {size: 18}
                        },
                        datalabels: {
                            ...baseOptions.plugins.datalabels,
                            formatter: v => v.toLocaleString('vi-VN') + ' ₫'
                        }
                    }
                }
            });

            function showChart(type) {
                const c = document.getElementById('chartCoursesContainer');
                const r = document.getElementById('chartRevenueContainer');
                document.getElementById('btnCourses').classList.toggle('active', type === 'courses');
                document.getElementById('btnRevenue').classList.toggle('active', type === 'revenue');
                c.classList.toggle('hidden', type !== 'courses');
                r.classList.toggle('hidden', type !== 'revenue');
            }
        </script>
    </body>
</html>