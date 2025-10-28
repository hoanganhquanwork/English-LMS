<%-- 
    Document   : course-detail
    Created on : Oct 7, 2025, 9:59:51 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            #curriculum .accordion-button:not(.collapsed){
                background-color:#f1f3f5;
                color:#212529;
            }
            #curriculum .accordion-button:focus{
                box-shadow:0 0 0 .2rem rgba(0,0,0,.05);
                border-color:rgba(0,0,0,.15);
            }
            .link-purple{
                color:#9c88d1 !important;
                text-decoration:underline;
            }
            .link-purple:hover,
            .link-purple:focus,
            .link-purple:visited{
                color:#bda6e6 !important;
            }
        </style>

    </style>
</head>
<body>
    <header>
        <jsp:include page="../header.jsp"/>
    </header>

    <!--Course information top-->
    <div class="bg-dark text-light p-4 mb-4">
        <div class="container">
            <div class="row g-4 align-items-start justify-content-center">              
                <!-- ========= Left  ========= -->
                <div class="col-lg-5 pt-3">
                    <div class="card border-0 bg-white shadow-soft thumb-card rounded-4 border border-1 overflow-hidden">
                        <div class="ratio ratio-16x9">
                            <img class="w-100 h-100 rounded-3 object-fit-cover"
                                 src="${pageContext.request.contextPath}/${course.thumbnail}"
                                 alt="Course thumbnail">
                        </div>
                    </div>
                </div>                             
                <!-- ========= Right ========= -->
                <div class="col-lg-5 pt-3">
                    <div class="card border-0 bg-transparent text-light p-4">
                        <h1 class="display-6 fw-semibold mb-3">${course.title}</h1>

                        <div class="d-flex align-items-center mb-3">
                            <img class="instructor-avatar me-2"
                                 src="${pageContext.request.contextPath}/${course.instructor.avatarUrl == null ? 'image/avatar/avatar_0.png': course.instructor.avatarUrl}"
                                 alt="Instructor"
                                 style="width:36px; height:36px; object-fit:cover;">

                            <div>
                                <span class="small text-light">Giảng viên:</span>
                                <a class="small text-decoration-underline link-purple" href="">
                                    ${course.instructor.fullName}
                                </a>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-2 mb-3">
                            <span class="fw-semibold text-warning">
                                ${course.rating}
                            </span>
                            <span class="rating-stars text-warning">
                                <c:set var="fullStars" value="${(course.rating != null) ? (course.rating - (course.rating % 1)) : 0}" />
                                <c:set var="hasHalf" value="${(course.rating != null) ? (course.rating - fullStars) >= 0.5 : false}" />
                                <c:forEach begin="1" end="${fullStars}"><i class="bi bi-star-fill"></i></c:forEach>
                                <c:if test="${hasHalf}"><i class="bi bi-star-half"></i></c:if>
                                <c:forEach begin="1" end="${5 - fullStars - (hasHalf ? 1 : 0)}"><i class="bi bi-star"></i></c:forEach>
                                </span>
                                <a class="small link-purple"  href="${pageContext.request.contextPath}/reviewCourse?courseId=${course.courseId}">
                                (<fmt:formatNumber value="${course.ratingsCount}" /> lượt đánh giá)
                            </a>
                            <span class="text-light small ms-2">
                                <fmt:formatNumber value="${course.studentCount}" /> học sinh
                            </span>
                        </div>


                        <div class="meta-wrap mb-4">
                            <span class="badge rounded-pill bg-light text-dark border">
                                <i class="bi bi-collection me-1"></i>${course.categoryName}
                            </span>
                            <span class="badge rounded-pill bg-light text-dark border">
                                <i class="bi bi-bar-chart-line me-1"></i>${course.level}
                            </span>
                            <span class="badge rounded-pill bg-light text-dark border">
                                <i class="bi bi-translate me-1"></i>${course.language}
                            </span>
                        </div>

                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="price-tag fw-semibold fs-4">
                                <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true" maxFractionDigits="0" />đ
                            </div>
                        </div>
                        <c:if test="${not empty sessionScope.student}">
                            <div class="d-flex gap-2">
                                <c:choose>
                                    <c:when test="${courseRequestStatus == 'enrolled'}">
                                        <form method="get" action="${pageContext.request.contextPath}/coursePage?courseId=${course.courseId}">
                                            <input type="hidden" name="courseId" value="${course.courseId}">
                                            <button type="submit" class="btn btn-success w-100 fw-semibold">
                                                <i class="bi bi-play-circle me-1"></i> Vào khóa học
                                            </button>
                                        </form>
                                    </c:when>

                                    <c:when test="${courseRequestStatus == 'requestExists'}">
                                        <button type="button"
                                                class="btn btn-outline-light w-100 fw-semibold opacity-100"
                                                disabled "
                                                title="Bạn đã tạo yêu cầu cho khóa học này rồi">
                                            <i class="bi bi-card-checklist me-1"></i> Yêu cầu đã được lưu trữ
                                        </button>

                                    </c:when>

                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/createCourseRequest">
                                            <input type="hidden" name="courseId" value="${course.courseId}">
                                            <input type="hidden" name="source" value="courseInfo">
                                            <button type="submit" class="btn btn-primary w-100 fw-semibold"
                                                    style="background-color:#6f42c1; border-color:#6f42c1; color:#fff;">
                                                <i class="bi bi-plus-circle me-1"></i> Thêm vào danh sách tạm lưu
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


<div class="container">
    <!--Khám phá-->
    <div class="card border-0 bg-white shadow-soft mt-4 p-4">
        <h3 class="fw-bold mb-3">Khám phá </h3>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark  rounded-3 fw-bold px-3 py-2"
               href="${pageContext.request.contextPath}/courseSearching?categoryIDs=${course.categoryId}">${course.categoryName}
            </a>
            <a class="btn btn-outline-dark  rounded-3 fw-bold px-3 py-2"
               href="${pageContext.request.contextPath}/courseSearching?level=${course.level}">${course.level}
            </a>
            <a class="btn btn-outline-dark  rounded-3 fw-bold px-3 py-2"
               href="${pageContext.request.contextPath}/courseSearching?language=${course.language}">${course.language}
            </a>
        </div>
    </div>
    <!--Description-->
    <div class="card border-0 bg-white shadow-soft mt-4 p-4">
        <h3 class="fw-bold mb-3">
            Khóa học này có ${course.moduleCount} module 
        </h3>

        <div class="text-secondary mb-3" style="line-height:1.7">
            ${requestScope.course.description}
        </div>

        <!--Curriculum-->
        <div class="card border-0 bg-white shadow-soft mt-4">
            <div class="">
                <h4 class="fw-bold mb-4">Khung khóa học</h3>

                    <div class="accordion" id="curriculum">
                        <c:forEach var="m" items="${course.moduleDetails}">
                            <div class="accordion-item mb-2 rounded-3 overflow-hidden">

                                <!-- Header module (toggle chính nó) -->
                                <h2 class="accordion-header" id="mod-h-${m.id}">
                                    <button class="accordion-button collapsed py-3" type="button"
                                            data-bs-toggle="collapse"
                                            data-bs-target="#mod-b-${m.id}"
                                            aria-expanded="false"
                                            aria-controls="mod-b-${m.id}">
                                        <div class="w-100 d-flex align-items-center justify-content-between">
                                            <div>
                                                <div class="fw-semibold">Module ${m.orderNo}: ${m.title}</div>
                                            </div>
                                        </div>
                                    </button>
                                </h2>

                                <div id="mod-b-${m.id}" class="accordion-collapse collapse" aria-labelledby="mod-h-${m.id}">
                                    <div class="accordion-body">

                                        <!-- Badges tổng quan -->
                                        <div class="d-flex flex-column gap-2 mb-3">

                                            <!-- Tiêu đề -->
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="fw-semibold text-decoration-underline text-dark">Học liệu bao gồm:</span>
                                            </div>

                                            <!-- Các mục học liệu -->
                                            <div class="d-flex flex-wrap gap-4">
                                                <c:if test="${m.videoCount > 0}">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-play-btn"></i>
                                                        <span class="small">${m.videoCount} videos</span>
                                                    </div>
                                                </c:if>

                                                <c:if test="${m.readingCount > 0}">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-book"></i>
                                                        <span class="small">${m.readingCount} readings</span>
                                                    </div>
                                                </c:if>

                                                <c:if test="${m.assignmentCount > 0}">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-clipboard-check"></i>
                                                        <span class="small">${m.assignmentCount} assignments</span>
                                                    </div>
                                                </c:if>

                                                <c:if test="${m.quizCount > 0}">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-patch-question"></i>
                                                        <span class="small">${m.quizCount} quizzes</span>
                                                    </div>
                                                </c:if>

                                                <c:if test="${m.discussionCount > 0}">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-chat-dots"></i>
                                                        <span class="small">${m.discussionCount} discussions</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Nút hiển thị nội dung chi tiết -->
                                        <button class="btn btn-link p-0 d-inline-flex align-items-center small"
                                                type="button"
                                                data-bs-toggle="collapse"
                                                data-bs-target="#mod-cnt-${m.id}"
                                                aria-expanded="false"
                                                aria-controls="mod-cnt-${m.id}">
                                            <i class="bi bi-caret-right me-1"></i> Hiện thị thông tin module
                                        </button>

                                        <!-- Nội dung chi tiết (chỉ tên, theo 5 nhóm) -->
                                        <div class="collapse mt-3" id="mod-cnt-${m.id}">
                                            <!-- Videos -->
                                            <c:if test="${m.videoCount > 0}">
                                                <div class="mb-3">
                                                    <div class="fw-semibold mb-1"><i class="bi bi-play-btn me-1"></i>Videos</div>
                                                    <ul class="list-unstyled">
                                                        <c:forEach var="it" items="${m.videos}">
                                                            <li class="py-1 small">${it.title}</li>
                                                            </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>

                                            <!-- Readings -->
                                            <c:if test="${m.readingCount > 0}">
                                                <div class="mb-3">
                                                    <div class="fw-semibold mb-1"><i class="bi bi-book me-1"></i>Readings</div>
                                                    <ul class="list-unstyled">
                                                        <c:forEach var="it" items="${m.readings}">
                                                            <li class="py-1 small">${it.title}</li>
                                                            </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>

                                            <!-- Assignments -->
                                            <c:if test="${m.assignmentCount > 0}">
                                                <div class="mb-3">
                                                    <div class="fw-semibold mb-1"><i class="bi bi-clipboard-check me-1"></i>Assignments</div>
                                                    <ul class="list-unstyled">
                                                        <c:forEach var="it" items="${m.assignments}">
                                                            <li class="py-1 small">${it.title}</li>
                                                            </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>

                                            <!-- Quizzes -->
                                            <c:if test="${m.quizCount > 0}">
                                                <div class="mb-3">
                                                    <div class="fw-semibold mb-1"><i class="bi bi-patch-question me-1"></i>Quizzes</div>
                                                    <ul class="list-unstyled">
                                                        <c:forEach var="it" items="${m.quizzes}">
                                                            <li class="py-1 small">${it.title}</li>
                                                            </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>

                                            <!-- Discussions -->
                                            <c:if test="${m.discussionCount > 0}">
                                                <div class="mb-1">
                                                    <div class="fw-semibold mb-1"><i class="bi bi-chat-dots me-1"></i>Discussions</div>
                                                    <ul class="list-unstyled">
                                                        <c:forEach var="it" items="${m.discussions}">
                                                            <li class="py-1 small">${it.title}</li>
                                                            </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
            </div>
        </div>




    </div>

    <div class="card border-0 bg-white shadow-soft mt-4 p-4"> 
        <h3 class="fw-bold mb-3">
            <i class="bi bi-star-fill text-warning me-2"></i>
            <fmt:formatNumber value="${course.rating}" minFractionDigits="1" maxFractionDigits="1"/> course rating
            • <fmt:formatNumber value="${course.ratingsCount}"/> ratings
        </h3>
        <hr class="text-secondary opacity-25"/>

        <c:choose>
            <c:when test="${not empty topFourReviews}">
                <div class="row row-cols-1 row-cols-md-2 g-4">
                    <c:forEach var="rv" items="${topFourReviews}">
                        <div class="col">
                            <div class="p-3 border rounded-3 h-100">
                                <div class="d-flex align-items-start gap-3">
                                    <!-- Avatar / Initials -->
                                    <img src="${pageContext.request.contextPath}/${rv.studentAvatar == null ? 'image/avatar/avatar_0.png' : rv.studentAvatar}"
                                         alt="${rv.studentName}"
                                         class="rounded-circle flex-shrink-0"
                                         style="width:44px;height:44px;object-fit:cover;">

                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <div class="fw-semibold">${rv.studentName}</div>
                                            <small class="text-secondary">
                                                <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </div>

                                        <!-- Stars -->
                                        <div class="text-warning small mb-2">
                                            <c:forEach begin="1" end="${rv.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                            <c:forEach begin="1" end="${5 - rv.rating}"><i class="bi bi-star"></i></c:forEach>
                                            </div>

                                            <!-- Comment -->
                                            <div class="text-body">${rv.comment}</div>


                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-secondary">Khóa học này chưa có đánh giá.</div>
            </c:otherwise>
        </c:choose>
        <div class="text-start mt-4">
            <a class="btn btn-outline-primary px-4 "
               href="${pageContext.request.contextPath}/reviewCourse?courseId=${course.courseId}">
                Xem tất cả đánh giá
            </a>
        </div>


    </div>
    <!--Similar-->
    <c:if test="${not empty sessionScope.student}">
        <div class="card border-0 bg-white shadow-soft mt-4 p-4">
            <h3 class="fw-bold mb-3">
                Khóa học tương tự
            </h3>

            <c:choose>
                <c:when test="${not empty randomSameCategory}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                        <c:forEach var="c2" items="${randomSameCategory}">
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden ">
                                    <div class="ratio ratio-16x9">
                                        <img src="${pageContext.request.contextPath}/${c2.thumbnail}"
                                             alt="${c2.title}" class="w-100 h-100 object-fit-cover">
                                    </div>
                                    <div class="card-body">
                                        <h6 class="card-title mb-1 text-truncate" title="${c2.title}">
                                            ${c2.title}
                                        </h6>
                                        <div class="text-secondary small mb-2 text-truncate" title="${c2.instructor.fullName}">
                                            ${c2.instructor.fullName}
                                        </div>

                                        <!-- rating + count -->
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="fw-semibold small text-warning">
                                                <c:choose>
                                                    <c:when test="${c2.rating != null}">
                                                        <fmt:formatNumber value="${c2.rating}" minFractionDigits="1" maxFractionDigits="1"/>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="text-warning small">
                                                <c:forEach begin="1" end="${(c2.rating != null) ? (c2.rating - (c2.rating % 1)) : 0}">
                                                    <i class="bi bi-star-fill"></i>
                                                </c:forEach>
                                                <c:forEach begin="1" end="${5 - ((c2.rating != null) ? (c2.rating - (c2.rating % 1)) : 0)}">
                                                    <i class="bi bi-star"></i>
                                                </c:forEach>
                                            </span>
                                            <span class="small text-secondary">(<fmt:formatNumber value="${c2.ratingsCount}"/>)</span>
                                        </div>

                                        <!-- extra info -->
                                        <div class="small text-secondary">
                                            <span class="me-2"><i class="bi bi-collection me-1"></i>${c2.level}</span>
                                            <span><i class="bi bi-translate me-1"></i>${c2.language}</span>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-white border-0">
                                        <div class="fw-semibold">
                                            <fmt:formatNumber value="${c2.price}" type="number" groupingUsed="true" maxFractionDigits="0" />đ
                                        </div>
                                        <a class="stretched-link" href="${pageContext.request.contextPath}/courseInformation?courseId=${c2.courseId}"></a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-secondary">Chưa có khóa học tương tự.</div>
                </c:otherwise>
            </c:choose>
            <div class="text-start mt-4">
                <a class="btn btn-outline-primary px-4"
                   href="${pageContext.request.contextPath}/courseSearching?categoryIDs=${course.categoryId}">
                    Xem thêm khóa học tương tự
                </a>
            </div>

        </div>
    </c:if>
</div>
<footer>
    <jsp:include page="../footer.jsp"/>
</footer>
</body>

</html>
