

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course Review</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>

        <div class="container my-4 flex-grow-1">

            <!-- Rating overview-->
            <div class="d-flex align-items-center gap-2 mb-3">
                <h5 class="m-0">
                    <span class="bi bi-star-fill text-warning"></span>    <fmt:formatNumber value="${summary.avgRating}" minFractionDigits="1" maxFractionDigits="1"/> Đánh giá trung bình
                    • <fmt:formatNumber value="${summary.totalRatings}"/> Lượt đánh giá
                </h5>
            </div>

            <div class="row g-4">
                <!--Left-->
                <div class="col-lg-4">
                    <div class="card review-card">
                        <div class="card-body">
                            <h5 class="fw-bold">Tóm tắt đánh giá</h5>
                            <form class="mb-3"
                                  method="get"
                                  action="${pageContext.request.contextPath}/reviewCourse">
                                <input type="hidden" name="courseId" value="${courseId}">
                                <input type="hidden" name="page"     value="1">
                                <input type="hidden" name="size"     value="${pageSize}">  

                                <div class="mb-3">
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:set var="s" value="${6 - i}" />
                                        <button type="submit" name="star" value="${s}"
                                                class="w-100 border-0 text-start p-2 mb-2 rounded
                                                ${selectedStar == s ? 'bg-light border' : 'bg-transparent'}">
                                            <div class="d-flex align-items-center justify-content-between
                                                 ${selectedStar == s ? 'fw-semibold' : ''}">
                                                <span>
                                                    <c:forEach var="j" begin="1" end="5">
                                                        <i class="bi ${j <= s ? 'bi-star-fill text-warning' : 'bi-star text-secondary'}"></i>
                                                    </c:forEach>
                                                </span>
                                                <span class="text-muted small">
                                                    <c:choose>
                                                        <c:when test="${s==5}">${summary.fiveStarCount}</c:when>
                                                        <c:when test="${s==4}">${summary.fourStarCount}</c:when>
                                                        <c:when test="${s==3}">${summary.threeStarCount}</c:when>
                                                        <c:when test="${s==2}">${summary.twoStarCount}</c:when>
                                                        <c:otherwise>${summary.oneStarCount}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </button>
                                    </c:forEach>
                                </div>
                                <!-- Search box -->
                                <div class="d-flex mb-3">
                                    <input class="form-control form-control-sm me-2" type="text" name="keyword"
                                           value="${requestScope.keyword}" placeholder="Nhập từ khóa cần tra cứu">
                                    <button class="btn btn-outline-secondary btn-sm" style="width: 20%" type="submit">Tra cứu</button>
                                </div>
                            </form>

                            <!-- Hiển thị theo enrollmentStatus -->
                            <c:choose>
                                <c:when test="${empty enrollmentStatus}">
                                    <!--Trong guest or chua enroll-->
                                </c:when>

                                <c:when test="${enrollmentStatus == 'active'}">
                                    <button class="btn btn-sm btn-secondary w-100" disabled>
                                        Bạn phải hoàn thành khóa học trước khi review
                                    </button>
                                </c:when>

                                <c:when test="${enrollmentStatus == 'completed'}">
                                    <c:choose>
                                        <c:when test="${existReview}">
                                            <form method="post" action="${pageContext.request.contextPath}/reviewAction"> 
                                                <input type="hidden" name="courseId" value="${courseId}">
                                                <input type="hidden" name="pageSize" value="${requestScope.pageSize}">
                                                <input type="hidden" name="action" value="find">
                                                <button type="submit" class="btn btn-sm btn-outline-primary w-100">
                                                    Đánh giá của tôi
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-sm btn-primary w-100" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#write-review">
                                                Viết đánh giá
                                            </button>

                                            <div class="collapse mt-2" id="write-review">
                                                <form method="post" action="${pageContext.request.contextPath}/reviewAction">
                                                    <input type="hidden" name="courseId" value="${courseId}">
                                                    <input type="hidden" name="action" value="create">
                                                    <div class="mb-2">
                                                        <label class="form-label">Chọn số sao</label>
                                                        <select name="rating" class="form-select form-select-sm" required>
                                                            <option value="5">5 ★</option>
                                                            <option value="4">4 ★</option>
                                                            <option value="3">3 ★</option>
                                                            <option value="2">2 ★</option>
                                                            <option value="1">1 ★</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-2">
                                                        <label class="form-label">Nhận xét</label>
                                                        <textarea name="comment" class="form-control form-control-sm" maxlength="1000" rows="10" required></textarea>
                                                    </div>
                                                    <button class="btn btn-primary btn-sm w-100">Gửi đánh giá</button>
                                                </form>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                            </c:choose>

                        </div>
                    </div>
                    <!--Error-->
                    <div class="text-danger small">${errorReview}</div>

                </div>

                <!-- ===== Right: Danh sách reviews ===== -->
                <div class="col-lg-8">

                    <c:forEach var="rv" items="${reviews}">
                        <!--Hien thi review cua minh-->
                        <c:set var="isMine" value="${studentId != null and rv.studentId == studentId}" />

                        <div class="card review-card mb-3 ${isMine ? 'bg-info-subtle border-info-subtle' : ''}">
                            <div class="card-body">
                                <!-- Header -->
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center">
                                        <img class="rounded-circle me-2 avatar"
                                             src="${pageContext.request.contextPath}/${empty rv.studentAvatar ? 'image/avatar/avatar_0.png' : rv.studentAvatar}"
                                             alt="avatar"
                                             style="width:36px; height:36px; object-fit:cover;">
                                        <div>
                                            <div class="fw-semibold">${rv.studentName}</div>
                                            <div class="text-warning small">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <i class="bi ${i <= rv.rating ? 'bi-star-fill' : 'bi-star'}"></i>
                                                </c:forEach>
                                                <span class="text-muted ms-2">
                                                    <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy"/>
                                                </span>
                                                <c:if test="${not empty rv.editedAt}">
                                                    <span class="badge text-bg-light ms-2">edited</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${isMine}">
                                        <button class="btn btn-sm btn-outline-primary ms-2"
                                                type="button"
                                                data-bs-toggle="collapse"
                                                data-bs-target="#edit-${rv.reviewId}">
                                            Sửa
                                        </button>
                                    </c:if>
                                </div>                              

                                <!-- Nội dung -->
                                <p class="mt-2 mb-0">${rv.comment}</p>

                                <c:if test="${isMine}">

                                    <div id="edit-${rv.reviewId}" class="collapse mt-2">
                                        <h5 class="mt-4">Chỉnh sửa: </h5>
                                        <form method="post" action="${pageContext.request.contextPath}/reviewAction">
                                            <input type="hidden" name="action"   value="update">
                                            <input type="hidden" name="courseId" value="${courseId}">
                                            <input type="hidden" name="studentId" value="${studentId}">

                                            <div class="row g-2 align-items-center">
                                                <div class="col-auto">
                                                    <label class="col-form-label col-form-label-sm">Số sao</label>
                                                </div>
                                                <div class="col-auto">
                                                    <select name="rating" class="form-select form-select-sm" required>
                                                        <c:forEach var="s" begin="1" end="5">
                                                            <option value="${s}" ${s == rv.rating ? 'selected' : ''}>${s} ★</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="mt-2">
                                                <label class="form-label">Nhận xét</label>
                                                <textarea name="comment" class="form-control form-control-sm"
                                                          rows="6" maxlength="1000" required>${rv.comment}</textarea>
                                            </div>

                                            <div class="d-flex gap-2 mt-2">
                                                <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                                                <button type="button" class="btn btn-outline-secondary btn-sm"
                                                        data-bs-toggle="collapse" data-bs-target="#edit-${rv.reviewId}">
                                                    Hủy
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>

                            </div>
                        </div>
                    </c:forEach>

                    <c:set var="currPage" value="${page <= 0 ? 1 : page}" />
                    <c:set var="tp"       value="${totalPages <= 0 ? 1 : totalPages}" />
                    <c:if test="${tp > 1}">
                        <div class="d-flex gap-1">
                            <a class="btn btn-outline-secondary btn-sm ${currPage==1?'disabled':''}"
                               href="${pageContext.request.contextPath}/reviewCourse?courseId=${courseId}&star=${selectedStar}&size=${pageSize}&page=${currPage-1}">«</a>

                            <c:forEach var="i" begin="1" end="${tp}">
                                <a class="btn btn-sm ${i==currPage?'btn-primary':'btn-outline-secondary'}"
                                   href="${pageContext.request.contextPath}/reviewCourse?courseId=${courseId}&star=${selectedStar}&size=${pageSize}&page=${i}">${i}</a>
                            </c:forEach>

                            <a class="btn btn-outline-secondary btn-sm ${currPage==tp?'disabled':''}"
                               href="${pageContext.request.contextPath}/reviewCourse?courseId=${courseId}&star=${selectedStar}&size=${pageSize}&page=${currPage+1}">»</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>
</html>
