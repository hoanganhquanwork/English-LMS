<%-- 
    Document   : footer
    Created on : Sep 27, 2025, 4:18:03 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Footer Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <header class="py-2">
            <div class="container d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center flex-shrink-0">
                    <a href="home"><img src="" 
                             alt="hi" height="28" class="me-3"></a>
                    <a href="#" class="nav-link me-3">Khóa học của tôi</a>
                </div>

                <form action="courseSearching" method="get" class="search-wrapper w-100">
                    <div class="input-group search-bar">
                        <input type="text" name="keyWord" value="${requestScope.keyWord}"class="form-control" placeholder="Tìm kiếm khóa học yêu thích">

                        <button type="submit" class="btn btn-search">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>


                <div class="d-flex align-items-center flex-shrink-0">
                    <a href="#" class="text-dark fs-5 me-3"><i class="bi bi-heart"></i></a>
                    <a href="#" class="text-dark fs-5 me-3"><i class="bi bi-cart3"></i></a>
                    <div class="profile-circle"></div>
                </div>
            </div>
        </header>
    </body>
</html>
