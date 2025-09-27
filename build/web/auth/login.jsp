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
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Đăng nhập</h2>
        <h3>
            <p>
                ${requestScope.errorLogin}
            </p>
            <p>
                ${requestScope.inactive}
            </p>
            <c:if test="${param.errorEmail == true}" >
                <p>
                    Email này đã được sử dụng
                </p>
            </c:if>
            <c:if test="${param.errorGoogle == true}" >
                <p>
                    Đăng nhập thất bại
                </p>
            </c:if>

        </h3>
        <form action="login" method="post">
            <label>Tên đăng nhập:</label>
            <input type="text" name="username" value="${requestScope.username}">
            <br>
            <label>Mật khẩu</label>
            <input type="password" name="password">
            <br>
            <input type="checkbox" name="remember-me">
            <label>Ghi nhớ đăng nhập</label>
            <a href="forgotpassword" >Quên mật khẩu</a>
            <br>
            <button type="submit">Đăng nhập</button>
        </form>
        <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/EnglishLMS/loginGoogle&response_type=code&client_id=580057518228-m468d3eaav982ok87db2lg5k0vp9b352.apps.googleusercontent.com&approval_prompt=force">
            <span>Đăng nhập với Google</span>
        </a>
        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register"> Đăng ký ngay</a></p>
    </body>
</html>
