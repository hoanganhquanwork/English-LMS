<%-- 
    Document   : my-learning
    Created on : Oct 26, 2025, 4:16:20 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Learning</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .pill-tabs .nav-link{
                border:1px solid #e4e8f0;
                background:#fff;
                color:#263238;
            }
            .pill-tabs .nav-link.active{
                background:#2f3642 !important;
                color:#fff !important;
                border-color:#2f3642;
            }

        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>

        <div class="container py-4 flex-grow-1">

            <!-- Tabs -->
            <ul class="nav nav-pills mb-3 pill-tabs">
                <li class="nav-item me-2">
                    <a class="nav-link rounded-pill px-3 ${activeTab=='inprogress' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/myLearning?tab=inprogress">In Progress</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link rounded-pill px-3 ${activeTab=='completed' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/myLearning?tab=completed">Completed</a>
                </li>
            </ul>

            <!-- In Progress -->
            <c:if test="${activeTab == 'inprogress'}">
                <c:choose>
                    <c:when test="${empty inProgress}">
                        <div class="alert alert-secondary">Bạn chưa có khóa học nào đang học.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="vstack gap-3">
                            <c:forEach var="c" items="${inProgress}">
                                <div class="card shadow-sm border-1 rounded-4 border-secondary-subtle">
                                    <div class="card-body d-flex justify-content-between align-items-stretch gap-3">
                                        <div class="d-flex gap-3 flex-grow-1">
                                            <img src="${pageContext.request.contextPath}/${c.thumbnailUrl}" alt="${c.courseTitle}" class="rounded" style="width:70px;
                                                 height:70px;
                                                 object-fit:cover;">
                                            <div class="w-100">
                                                <h6 class="mb-2 ">                                                  
                                                    <a href="${pageContext.request.contextPath}/courseInformation?courseId=${c.courseId}" class="fw-bold text-dark text-decoration-none">Khóa học: ${c.courseTitle}</a>
                                                </h6>
                                                <p class="text-muted-sm">Đã hoàn thành: <span>${c.progressPercent}%</span></p>
                                                <div class="d-flex align-items-center gap-2 mb-2">
                                                    <div class="progress w-100">
                                                        <div class="progress-bar-striped bg-success" role="progressbar"
                                                             style="width:${c.progressPercent}%"
                                                             aria-valuenow="${c.progressPercent}" aria-valuemin="0" aria-valuemax="100">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <c:if test="${c.nextItem != null}">
                                            <div class="card card-resume px-3 py-2 d-flex flex-row align-items-center gap-3 rounded-4" style="min-width:360px;">
                                                <div class="flex-grow-1 d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <div class="fw-bold">

                                                            ${c.nextItem.title}
                                                        </div>
                                                        <div class="text-muted-sm">
                                                            <c:choose>
                                                                <c:when test="${c.nextItem.contentType == 'video'}">
                                                                    <i class="bi bi-play-btn"></i> Video
                                                                </c:when>
                                                                <c:when test="${c.nextItem.contentType == 'reading'}">
                                                                    <i class="bi bi-book"></i> Reading
                                                                </c:when>
                                                                <c:when test="${c.nextItem.contentType == 'assignment'}">
                                                                    <i class="bi bi-clipboard-check"></i> Assignment
                                                                </c:when>
                                                                <c:when test="${c.nextItem.contentType == 'quiz'}">
                                                                    <i class="bi bi-patch-question"></i> Quiz
                                                                </c:when>
                                                                <c:when test="${c.nextItem.contentType == 'discussion'}">
                                                                    <i class="bi bi-chat-dots"></i> Discussion
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${c.nextItem.contentType}
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <c:set var="minutes" value="${c.nextItem.durationMin}" />
                                                            <c:if test="${c.nextItem.contentType == 'assignment'}">
                                                                <c:set var="minutes" value="30" />
                                                            </c:if>
                                                            <c:if test="${c.nextItem.contentType == 'reading'}">
                                                                <c:set var="minutes" value="10" />
                                                            </c:if>

                                                            <c:if test="${not empty minutes}">
                                                                (${minutes} phút)
                                                            </c:if>
                                                        </div>
                                                    </div>

                                                    <a class="btn btn-primary"
                                                       href="${pageContext.request.contextPath}/coursePage?courseId=${c.courseId}&itemId=${c.nextItem.moduleItemId}">
                                                        Tiếp tục
                                                    </a>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <!-- Completed -->
                <c:if test="${activeTab == 'completed'}">
                    <c:choose>
                        <c:when test="${empty completed}">
                            <div class="alert alert-secondary">Chưa có khóa học nào hoàn thành.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="vstack gap-3">
                                <c:forEach var="c" items="${completed}">
                                    <div class="card shadow-sm border-1 rounded-4 border-secondary-subtle">
                                        <div class="card-body d-flex justify-content-between align-items-center gap-3 ">
                                            <div class="d-flex gap-3">
                                                <img src="${pageContext.request.contextPath}/${c.thumbnailUrl}" alt="${c.courseTitle}" class="rounded" style="width:90px;
                                                     height:90px;
                                                     object-fit:cover;">
                                                <div class="d-flex flex-column">
                                                    <h5 class="mb-1">
                                                        <a href="${pageContext.request.contextPath}/courseInformation?courseId=${c.courseId}" class="fw-bold text-dark text-decoration-none">Khóa học: ${c.courseTitle}</a>
                                                    </h5>

                                                    <div class="text-muted-sm">Điểm đạt được: <span class="fw-semibold">${c.averageScore}</span>%</div>
                                                    <div class="text-muted-sm">Ngày nhập học: <span class="fw-semibold">${c.enrollDate}</div>
                                                    <div class="text-muted-sm">Ngày hoàn thành: <span class="fw-semibold">${c.completedDate}</div>
                                                </div>
                                            </div>
                                            <div class="d-flex flex-column flex-wrap gap-2">
                                                <a class="btn btn-primary d-inline-flex align-items-center"
                                                   href="${pageContext.request.contextPath}/coursePage?courseId=${c.courseId}">
                                                    <i class="bi bi-arrow-repeat me-2"></i> Ôn tập
                                                </a>
                                                <a class="btn btn-outline-primary d-inline-flex align-items-center"
                                                   href="${pageContext.request.contextPath}/reviewCourse?courseId=${c.courseId}">
                                                    <i class="bi bi-pencil me-2"></i> Đánh giá 
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

            </div>
        </div>

        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>
</html>
