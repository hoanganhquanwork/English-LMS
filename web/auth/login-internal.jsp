<%-- 
    Document   : login-internal
    Created on : Sep 27, 2025, 12:05:13 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng nhập</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
        <style>
            body {
                background-color: #f5f7fb;
                display: flex;
                flex-direction: column;
            }
            main {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 50px;
            }
            .login-container {
                width: 380px;
            }
            .card {
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .oauth-btn img {
                width: 18px;
                height: 18px;
                margin-right: 8px;
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <main class="flex-grow-1">
            <div class="login-container">

                <c:if test="${not empty requestScope.errorLogin}">
                    <div class="alert alert-danger py-2">${requestScope.errorLogin}</div>
                </c:if>
                <c:if test="${not empty requestScope.inactive}">
                    <div class="alert alert-danger py-2">${requestScope.inactive}</div>
                </c:if>
                <c:if test="${param.errorEmail == true}">
                    <div class="alert alert-danger py-2">Email này đã được sử dụng</div>
                </c:if>
                <c:if test="${param.errorRole == true}">
                    <div class="alert alert-danger py-2">Bạn không có quyền truy cập</div>
                </c:if>
                <c:if test="${param.errorGoogle == true}">
                    <div class="alert alert-danger py-2">Đăng nhập Google thất bại</div>
                </c:if>
                <c:if test="${param.success == true}">
                    <div class="alert alert-success py-2">Đăng ký thành công. Vui lòng đăng nhập lại.</div>
                </c:if>
                <c:if test="${param.resetSuccess == true}">
                    <div class="alert alert-success py-2">Đổi mật khẩu thành công. Vui lòng đăng nhập lại.</div>
                </c:if>

                <div class="card p-4">
                    <h4 class="text-center mb-3">Đăng nhập (nội bộ)</h4>

                    <form action="${pageContext.request.contextPath}/loginInternal" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username" 
                                   value="${requestScope.username}" placeholder="Nhập tên đăng nhập" required>
                        </div>

                        <div class="mb-2">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Nhập mật khẩu" required>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <a class="text-decoration-none" href="${pageContext.request.contextPath}/forgot-password">
                                Quên mật khẩu?
                            </a>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
                    </form>
                </div>
            </div>
        </main>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>

</html>