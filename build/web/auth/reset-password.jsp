<%-- 
    Document   : reset_password
    Created on : Sep 21, 2025, 11:02:00 PM
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
        <form action="${pageContext.request.contextPath}/reset-password" method="post" onsubmit="return validatePassword()">
            <input type="hidden" name="token" value="${requestScope.token}">
            <label>Nhập mật khẩu mới</label>
            <input type="password" id="password" name="password" required>
            <span id="errPassword" style="color:red;"></span>
            <br>
            <label>Xác nhận mật khẩu mới</label>
            <input type="password" id="repassword" required>
            <span id="errRepassword" style="color:red;"></span>
            <br>
            <button type="submit">Cập nhật mật khẩu</button>

        </form>
    </body>
    <script>
        function validatePassword() {
            document.getElementById("errPassword").innerText = "";
            document.getElementById("errRepassword").innerText = "";

            let password = document.getElementById("password").value;
            let repassword = document.getElementById("repassword").value;

            let valid = true;

            let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!passPattern.test(password)) {
                document.getElementById("errPassword").innerText = "Mật khẩu tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
                valid = false;

            }
            if (password != repassword) {
                document.getElementById("errRepassword").innerText = "Mật khẩu nhập lại không khớp!";
                valid = false;
            }

            return valid;
        }
    </script>
</html>
