<%-- 
    Document   : search-course
    Created on : Sep 27, 2025, 6:35:58 PM
    Author     : Admin
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tìm kiếm khóa học</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search-courses.css">

    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <div class="container py-4 flex-grow-1">
            <form id="filterForm" method="get" action="${pageContext.request.contextPath}/courseSearching">
                <input type="hidden" name="keyWord" value="${requestScope.keyWord}">

                <div class="row g-4">

                    <div class="col-lg-3">
                        <div class="filter-box">
                            <h5 class="mb-3">Bộ lọc</h5>

                            <h6>Thể loại</h6>
                            <c:forEach var="cat" items="${listCategories}">
                                <div class="form-check">
                                    <input class="form-check-input"
                                           type="checkbox"
                                           name="categoryIDs"                              
                                           value="${cat.categoryId}"                     
                                           onchange="resetPageAndSubmit(this.form)"
                                           ${selectedCategorySet != null && selectedCategorySet.contains(cat.categoryId) ? 'checked="checked"' : ''}>
                                    <label class="form-check-label">${cat.name}</label>
                                </div>
                            </c:forEach>


                            <h6>Ngôn ngữ</h6>
                            <c:forEach var="lang" items="${languages}">
                                <div class="form-check">
                                    <input class="form-check-input"
                                           type="checkbox"
                                           name="language"
                                           value="${lang}"
                                           onchange="resetPageAndSubmit(this.form)"
                                           ${selectedLanguageSet != null && selectedLanguageSet.contains(lang) ? 'checked="checked"' : ''}>
                                    <label class="form-check-label">${lang}</label>
                                </div>
                            </c:forEach>

                            <h6>Trình độ</h6>
                            <c:forEach var="lvl" items="${levels}">
                                <div class="form-check">
                                    <input class="form-check-input"
                                           type="checkbox"
                                           name="level"
                                           value="${lvl}"
                                           onchange="resetPageAndSubmit(this.form)" 
                                           ${selectedLevelSet != null && selectedLevelSet.contains(lvl) ? 'checked="checked"' : ''}>
                                    <label class="form-check-label" >${lvl}</label>
                                </div>
                            </c:forEach>

                        </div>
                    </div>

                    <!-- RIGHT: RESULTS -->
                    <div class="col-lg-9">
                        <!-- Top bar: query + Sort select -->
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">
                                Kết quả <c:if test="${not empty param.keyWord}">cho "<span class="text-primary">${param.keyWord}</span>"</c:if>
                                </h5>
                                <select name="sortBy" class="form-select form-select-sm w-auto" onchange="resetPageAndSubmit(this.form)">
                                    <option value="popular"   <c:if test="${param.sortBy=='popular' || empty param.sortBy}">selected</c:if>>Phổ biến nhất</option>
                                <option value="newest"    <c:if test="${param.sortBy=='newest' }">selected</c:if>>Mới nhất</option>
                                <option value="price"     <c:if test="${param.sortBy=='price'}">selected</c:if>>Giá thấp -> cao</option>
                                </select>
                            </div>

                            <div class="row g-3">
                            <c:forEach var="c" items="${courses}">
                                <div class="col-12 col-md-6 col-lg-4 ">
                                    <div class="course-card p-0 h-100 d-flex flex-column border border-1 rounded-4 overflow-hidden">
                                        <!-- Thumbnail -->
                                            <img class="course-thumb w-100 h-100 object-fit-cover" src="${pageContext.request.contextPath}/${c.thumbnail}" alt="${c.title}">
                                        <!-- Body -->
                                        <div class="p-3 d-flex flex-column flex-grow-1">
                                            <h6 class="course-title fw-semibold">
                                                <a class="text-decoration-none text-dark" href="${pageContext.request.contextPath}/courseInformation?courseId=${c.courseId}">${c.title}</a> 
                                            </h6>
                                            <p class="text-secondary mb-2 desc-3"
                                               style="display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;">
                                                <c:out value="${c.description}"/>
                                            </p>
                                            <div class="d-flex justify-content-between align-items-center mt-3">
                                                <div>
                                                    <span class="price-now">
                                                        <fmt:formatNumber value="${c.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫
                                                    </span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/courseInformation?courseId=${c.courseId}">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            >
                                                        <i class="bi bi-box-arrow-up-right"></i> Xem chi tiết khóa học
                                                    </button>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty courses}">
                                <div class="text-center text-muted py-5"><p>Không tìm thấy khóa học nào.</p></div>
                            </c:if>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-center gap-1 mt-4">
                                <c:if test="${page > 1}">
                                    <button type="submit" name="page" value="${page-1}" class="btn btn-outline-secondary btn-sm">«</button>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <button type="submit" name="page" value="${i}"
                                            class="btn btn-sm ${i==page?'btn-primary':'btn-outline-secondary'}">${i}</button>
                                </c:forEach>
                                <c:if test="${page < totalPages}">
                                    <button type="submit" name="page" value="${page+1}" class="btn btn-outline-secondary btn-sm">»</button>
                                </c:if>
                            </div>
                        </c:if>

                    </div>
                </div>
                <input type="hidden" name="page" id="pageHidden" value="${page != null ? page : 1}">

            </form>
        </div>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>
    <script>
        function resetPageAndSubmit(f) {
            var p = document.getElementById('pageHidden');
            if (p)
                p.value = 1;
            f.submit();
        }
    </script>

</html>

