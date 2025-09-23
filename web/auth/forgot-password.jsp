<%-- 
    Document   : forgot_password
    Created on : Sep 21, 2025, 11:01:41 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Quên mật khẩu</h2>
        <h3>${requestScope.message}</h3>
        <h3>${requestScope.invalidToken}</h3>
        <form action="${pageContext.request.contextPath}/forgot-password" method="post" onsubmit="return validateEmail()">
            <label>Nhập địa chỉ email của bạn</label>
            <span id="errEmail" style="color: red;"></span>
            <br>
            <input type="email" name="email" id="email">
            <br>
            <button type="submit">Đổi mật khẩu</button>
        </form>
        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
    </body>
    <script>
        function validateEmail() {
            document.getElementById("errEmail").innerText = "";

            let valid = true;
            let email = document.getElementById("email").value.trim();
            let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                document.getElementById("errEmail").innerText = "Email không đúng định dạng!";
                valid = false;
            }
            return valid;
        }
    </script>
</html>
