<%-- 
    Document   : login
    Created on : Sep 21, 2025, 11:01:17 PM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <body>
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <main>
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
                <c:if test="${param.errorGoogle == true}">
                    <div class="alert alert-danger py-2">Đăng nhập Google thất bại</div>
                </c:if>
                <c:if test="${param.errorRole == true}">
                    <div class="alert alert-danger py-2">Bạn không có quyền truy cập</div>
                </c:if>
                <c:if test="${param.success == true}">
                    <div class="alert alert-success py-2">Đăng ký thành công. Vui lòng đăng nhập lại.</div>
                </c:if>
                <c:if test="${param.resetSuccess == true}">
                    <div class="alert alert-success py-2">Đổi mật khẩu thành công. Vui lòng đăng nhập lại.</div>
                </c:if>
                <c:if test="${param.deactiveSuccess == true}">
                    <div class="alert alert-success py-2">Tài khoản bị vô hiệu hóa thành công</div>
                </c:if>
                <div class="card p-4">
                    <h4 class="text-center mb-3">Đăng nhập</h4>

                    <form action="${pageContext.request.contextPath}/login" method="post">
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
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="rememberMe" name="remember-me">
                                <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                            </div>
                            <a class="text-decoration-none" href="${pageContext.request.contextPath}/forgot-password">
                                Quên mật khẩu?
                            </a>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
                    </form>

                    <div class="text-center text-muted my-3">— hoặc —</div>

                    <a class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center oauth-btn"
                       href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/EnglishLMS/loginGoogle&response_type=code&client_id=580057518228-m468d3eaav982ok87db2lg5k0vp9b352.apps.googleusercontent.com&approval_prompt=force">
                        <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google"/>
                        Đăng nhập bằng Google
                    </a>

                    <p class="text-center mt-3 mb-0">
                        Chưa có tài khoản?
                        <a href="${pageContext.request.contextPath}/register" class="text-decoration-none">Đăng ký ngay</a>
                    </p>
                </div>
            </div>
        </main>
            <footer>
                <jsp:include page="../footer.jsp"/>
            </footer>
    </body>
</html>
