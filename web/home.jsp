<%-- 
    Document   : home
    Created on : Sep 21, 2025, 10:57:57 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang chủ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css"/>

        <style>
            :root{
                --hero-img: url('../image/home/welcome.jpg');
            }
        </style>
    </head>
    <body>
        <header>
            <jsp:include page="header.jsp"/>
        </header>
        <section class="py-5">
            <div class="container">
                <div class="hero-simple">
                    <div class="hero-box">
                        <h1>Học theo cách của bạn</h1>
                        <p>  Cùng bắt đầu hành trình học tập đầy hứng khởi để khám phá tiềm năng và đạt được mục tiêu của bạn.</p>
                    </div>
                </div>
            </div>
        </section>

        <!--Popular-->
        <section class="py-5">
            <div class="container">
                <h2 class="section-title h1 mb-1">Khóa học phổ biến</h2>
                <p class="text-secondary mb-4">Cùng khám phá những khóa học tiếng Anh được yêu thích nhất, những khóa học được lựa chọn để việc học tiếng Anh dễ hơn và vui hơn mỗi ngày</p>

                <div class="row g-4">
                    <c:forEach var="c" items="${requestScope.popularCourses}" >
                        <div class="col-12 col-md-6 col-lg-3">
                            <a href="${pageContext.request.contextPath}/course?id=${c.courseId}"
                               class="card card-course h-100 text-decoration-none text-dark">
                                <img src="${pageContext.request.contextPath}/${c.thumbnail}" class="card-img-top" alt="${c.title}">
                                <div class="card-body">
                                    <h5 class="card-title fw-semibold mb-2 line-2" title="${c.title}">${c.title}</h5>
                                    <p class="text-secondary mb-2 desc-3"
                                       style="display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;">
                                        <c:out value="${c.description}"/>
                                    </p>

                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>

                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/courseSearching?sortBy=popular"
                       class="btn btn-outline-primary btn-viewall">
                        Xem tất cả <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </section>

        <!--New-->
        <section class="py-5 bg-light">
            <div class="container">
                <h2 class="section-title h1 mb-1">Khóa học mới</h2>
                <p class="text-secondary mb-4">  Khám phá những khóa học tiếng Anh vừa ra mắt, giúp bạn nâng cao kỹ năng và bắt kịp xu hướng học tập mới.</p>

                <div class="row g-4">
                    <c:forEach var="c" items="${requestScope.newCourses}">
                        <div class="col-12 col-md-6 col-lg-3">
                            <a href="${pageContext.request.contextPath}/course?id=${c.courseId}"
                               class="card card-course h-100 text-decoration-none text-dark">
                                <img src="${pageContext.request.contextPath}/${c.thumbnail}" class="card-img-top" alt="${c.title}">
                                <div class="card-body">
                                    <h5 class="card-title fw-semibold mb-2 line-2" title="${c.title}">${c.title}</h5>
                                    <p class="text-secondary mb-2 desc-3"
                                       style="display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;">
                                        <c:out value="${c.description}"/>
                                    </p>
                                    <span class="badge rounded-pill text-bg-primary mb-2">Mới</span>

                                    <div class="small text-secondary">
                                        Cập nhật:  <c:out value="${c.publishAtStr}"/>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>

                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/courseSearching?sortBy=newest"
                       class="btn btn-outline-primary btn-viewall">
                        Xem tất cả <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </section>

        <!-- ===== EXPECT: 6 tiêu chí ===== -->
        <section class="py-5">
            <div class="container">
                <h2 class="section-title h1 text-center mb-4">Bạn sẽ nhận được gì từ khóa học</h2>
                <div class="row g-4 expect">
                    <div class="col-12 col-md-6">
                        <div class="d-flex gap-3"><i class="bi bi-emoji-smile"></i>
                            <div><h5>Học theo nhịp độ của bạn</h5>
                                <p class="text-secondary mb-0">  Thoải mái sắp xếp thời gian học theo cách của riêng mình. Mỗi bài học đều được thiết kế để giúp bạn duy trì hứng thú, học tập hiệu quả mà không cảm thấy áp lực.</p></div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="d-flex gap-3"><i class="bi bi-mortarboard"></i>
                            <div><h5>Giảng viên giàu kinh nghiệm</h5>
                                <p class="text-secondary mb-0">  Các bài học được biên soạn và giảng dạy bởi những thầy cô tận tâm, giàu kinh nghiệm trong lĩnh vực, giúp bạn học hiệu quả hơn mỗi ngày.</p></div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="d-flex gap-3"><i class="bi bi-people"></i>
                            <div><h5>Cộng đồng hỗ trợ</h5>
                                <p class="text-secondary mb-0">  Cùng học và chia sẻ hành trình chinh phục tiếng Anh. Bạn có thể đặt câu hỏi, trao đổi kinh nghiệm và nhận được sự hỗ trợ từ bạn bè cũng như thầy cô.</p></div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="d-flex gap-3">
                            <i class="bi bi-lightbulb"></i>
                            <div>
                                <h5>Phát triển kỹ năng toàn diện</h5>
                                <p class="text-secondary mb-0">Chương trình học được thiết kế cân bằng giữa nghe, nói, đọc, viết, giúp bạn nắm vững nền tảng tiếng Anh và ứng dụng linh hoạt trong học tập cũng như đời sống.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="d-flex gap-3"><i class="bi bi-laptop"></i>
                            <div><h5>Bài học thực hành</h5>
                                <p class="text-secondary mb-0"> Những bài tập nhỏ và hoạt động thú vị sẽ giúp bạn áp dụng kiến thức ngay trong thực tế, từ đó sử dụng tiếng Anh tự tin và tự nhiên hơn mỗi ngày.</p></div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="d-flex gap-3">
                            <i class="bi bi-stars"></i>
                            <div>
                                <h5>Khám phá tiềm năng bản thân</h5>
                                <p class="text-secondary mb-0">
                                    Cùng học tập và trải nghiệm trong môi trường thân thiện để nhận ra điểm mạnh, phát huy khả năng của chính mình và trở nên tự tin hơn trong học tập cũng như cuộc sống.
                                </p>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!--        Categories-->
        <section class="py-5 bg-light">
            <div class="container">
                <h2 class="section-title h1 mb-4">Khám phá theo chủ đề</h2>
                <div class="row g-3">
                    <c:forEach items="${requestScope.listCategory}" var="cat">
                        <div class="col-12 col-md-6 col-lg-4">
                            <a class="category-tile text-dark"
                               href="${pageContext.request.contextPath}/courseSearching?categoryIDs=${cat.categoryId}">
                                <img src="${pageContext.request.contextPath}/${cat.picture}" class="category-thumb">
                                <div>
                                    <div class="fw-semibold">${cat.name}</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        <header>
            <jsp:include page="footer.jsp"/>
        </header>
    </body>
</html>
