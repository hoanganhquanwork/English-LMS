<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    DecimalFormat df1 = new DecimalFormat("0");
    request.setAttribute("df1", df1);
%>

<%
    request.setAttribute("currentPage", "progress");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Tiến độ học tập | LinguaTrack</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />

    </head>
    <body>
            <jsp:include page="../header.jsp"/>

        <main class="container">
            <div class="page-title">
                <h2>Tiến độ học tập của con</h2>
                <p class="lead">Theo dõi chi tiết quá trình học tập và thành tích của con em.</p>
            </div>

            <div class="child-selector">
                <label class="form-label">Chọn con để xem tiến độ:</label>
                <select id="childSelect" class="form-select w-auto" onchange="location = this.value;">
                    <c:forEach var="ch" items="${children}">
                        <option value="${pageContext.request.contextPath}/parent/progress?studentId=${ch.userId}"
                                <c:if test="${ch.userId == selectedStudentId}">selected</c:if>>
                            ${ch.fullName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="progress-overview">
                <div class="overview-card">
                    <div class="card-icon">📚</div>
                    <div class="card-content">
                        <h3>${overview.activeCourses}</h3>
                        <p>Khóa học đang học</p>
                    </div>
                </div>
                <div class="overview-card">
                    <div class="card-icon">🎯</div>
                    <div class="card-content">
                        <h3>${overview.avgProgress}%</h3>
                        <p>Tiến độ trung bình</p>
                    </div>
                </div>
                <div class="overview-card">
                    <div class="card-icon">🏆</div>
                    <div class="card-content">
                        <h3>${overview.completedCourses}</h3>
                        <p>Khóa học đã hoàn thành</p>
                    </div>
                </div>

            </div>

            <!-- Danh sách tiến độ khóa học -->
            <section class="progress-section mb-5">
                <h3>Tiến độ từng khóa học</h3>

                <c:choose>
                    <c:when test="${empty courses}">
                        <div class="alert alert-info mt-3">Học sinh chưa tham gia khóa học nào.</div>
                    </c:when>

                    <c:otherwise>
                        <div class="course-progress-list">
                            <c:forEach var="c" items="${courses}">
                                <div class="course-progress-item mb-4">
                                    <div class="course-header">
                                        <div class="course-info">
                                            <h4>${c.courseTitle}</h4>
                                        </div>
                                        <span class="status-badge ${c.progressPctRequired >= 100 ? 'active' : 'pending'}">
                                            ${c.progressPctRequired >= 100 ? 'Hoàn thành' : 'Đang học'}
                                        </span>
                                    </div>

                                    <div class="row align-items-center mt-3" style ="padding-left: 15px;">
                                        <!-- Thanh tiến độ -->
                                        <div class="col-md-6">
                                            <div class="progress-bar" style="background: ghostwhite">
                                                <div class="progress-fill" data-width="${c.progressPctRequired}"></div>
                                            </div>
                                            <div class="progress-text mt-1">
                                                <span>${df1.format(c.progressPctRequired)}% hoàn thành</span>
                                            </div>
                                        </div>

                                        <!-- Số lượng bài -->
                                        <div class="col-md-2 stat-item">
                                            <span class="stat-label">Hoàn thành:</span>
                                            <span class="stat-value">${c.completedItems}/${c.totalItems}</span>
                                        </div>

                                        <div class="col-md-2 stat-item">
                                            <span class="stat-label">Bắt buộc:</span>
                                            <span class="stat-value">${c.requiredCompleted}/${c.requiredItems}</span>
                                        </div>

                                        <div class="col-md-2 stat-item">
                                            <span class="stat-label">📊 Điểm TB:</span>
                                            <span class="stat-value">
                                                <c:choose>
                                                    <c:when test="${c.avgScorePct != null}">
                                                        <c:choose>
                                                            <c:when test="${c.avgScorePct >= 80}">
                                                                <span style="color: #28a745;">${df1.format(c.avgScorePct)}%</span>
                                                            </c:when>
                                                            <c:when test="${c.avgScorePct >= 60}">
                                                                <span style="color: #ffc107;">${df1.format(c.avgScorePct)}%</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #dc3545;">${df1.format(c.avgScorePct)}%</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #6c757d;">Chưa có điểm</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>

                                    <div class="text-end mt-3">
                                        <a href="${pageContext.request.contextPath}/parent/progress_detail?courseId=${c.courseId}&studentId=${selectedStudentId}" 
                                           class="btn btn-sm btn-outline-primary" style="border-radius: 15px;">
                                            <i class="bi bi-eye"></i> Xem chi tiết
                                        </a>
                                            <a href="${pageContext.request.contextPath}/courseInformation?courseId=${c.courseId}" class="btn primary" target="_blank">
                                            📖 Xem thông tin khóa học
                                        </a>
                                    </div>
                                   
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>

        <jsp:include page="/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const progressFills = document.querySelectorAll('.progress-fill');
                progressFills.forEach(function (fill) {
                    const width = fill.getAttribute('data-width');
                    if (width) {
                        fill.style.width = width + '%';
                    }
                });
            });
        </script>
    </body>
</html>
