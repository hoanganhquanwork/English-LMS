<%-- 
    Document   : forgot_password
    Created on : Sep 21, 2025, 11:01:41 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quên mật khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .card {
                max-width: 400px;
                margin: 60px auto;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <div class="contain flex-grow-1">
            <div class="card p-4">
                <h2 class="text-center mb-3">Quên mật khẩu</h2>

                <c:if test="${not empty requestScope.message}">
                    <div class="alert alert-success text-center">${message}</div>
                </c:if>
                <c:if test="${not empty requestScope.invalidToken}">
                    <div class="alert alert-danger text-center">${invalidToken}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot-password" 
                      method="post" 
                      onsubmit="return validateEmail()">

                    <div class="mb-3">
                        <label for="email" class="form-label">Nhập địa chỉ email của bạn</label>
                        <input type="email" 
                               class="form-control" 
                               id="email" 
                               name="email" 
                               placeholder="abc@gmail.com" 
                               required>
                        <div id="errEmail" class="text-danger small mt-1"></div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Gửi yêu cầu</button>
                </form>

            </div>
        </div>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
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
