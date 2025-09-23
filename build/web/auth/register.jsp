<%-- 
    Document   : register
    Created on : Sep 21, 2025, 11:01:09 PM
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
        <h2>Họ và tên</h2>
        <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">
            <label>Tên đăng nhập: </label>
            <input name="username" id ="username" value="${requestScope.username}" required/>
            <span id="errUsername" style="color: red;"></span>
            <c:if test="${requestScope.error == 'Tên đăng nhập tồn tại'}">
                <span style="color: red;">Tên đăng nhập tồn tại</span>
            </c:if>
            <br>

            <label>Email:</label>
            <input type="email" name="email" id="email" value="${requestScope.email}"required>
            <span id="errEmail" style="color:red;"></span>
            <c:if test="${requestScope.error == 'Email đã được sử dụng!'}">
                <span style="color: red;">Email đã được sử dụng!</span>
            </c:if>
            <br>

            <label>Mật khẩu:</label>
            <input type="password" name="password" id ="password" required>
            <span id="errPassword" style="color:red;"></span>
            <br>

            <label>Nhập lại mật khẩu:</label>
            <input type="password" name="repassword" id ="repassword" required>
            <span id="errRepassword" style="color:red;"></span>
            <br>

            <label>Giới tính:</label>
            <div>
                <label>
                    <input type="radio" name="gender" value="male"
                           ${empty requestScope.gender || requestScope.gender == 'male' ? 'checked' : ''} > Nam
                </label>
                <label>
                    <input type="radio" name="gender" value="female"
                           ${requestScope.gender == 'female' ? 'checked' : ''} > Nữ
                </label>
                <label>
                    <input type="radio" name="gender" value="other"
                           ${requestScope.gender == 'other' ? 'checked' : ''} > Khác
                </label>
            </div>
            <br>

            <label>Vai trò:</label>
            <div>
                <label>
                    <input type="radio" name="role" value="Student"
                           ${empty requestScope.role || requestScope.role == 'Student' ? 'checked' : ''} required> Học sinh
                </label>
                <label>
                    <input type="radio" name="role" value="Parent"
                           ${requestScope.role == 'Parent' ? 'checked' : ''} required> Phụ huynh
                </label>
            </div>
            <br>

            <button type="submit">Đăng ký</button>
        </form>
        <p>Đã có tài khoản <a href="login">Đăng nhập</a></p>

    </body>
    <script>
        function validateForm() {
            document.getElementById("errUsername").innerText = "";
            document.getElementById("errEmail").innerText = "";
            document.getElementById("errPassword").innerText = "";
            document.getElementById("errRepassword").innerText = "";

            let username = document.getElementById("username").value.trim();
            let email = document.getElementById("email").value.trim();
            let password = document.getElementById("password").value;
            let repassword = document.getElementById("repassword").value;

            let valid = true;
            if (username.length < 5 || username.length > 20) {
                document.getElementById("errUsername").innerText = "Tên đăng nhập phải từ 5 đến 20 kí tự!"
                valid = false;
            }

            let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                document.getElementById("errEmail").innerText = "Email không hợp lệ!";
                valid = false;
            }

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
