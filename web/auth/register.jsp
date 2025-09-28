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
        <title>Đăng ký tài khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css"/>
        <style>
            :root {
                --register-img: url('../image/background/Illustration_1.png');
            }
        </style>
    </head>
    <body>
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <main>
            <div class="wrap">
                <div class="left">
                    <h2>Tạo tài khoản</h2>
                    <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">

                        <label class="form-label">Tên đăng nhập:</label>
                        <input class="form-control" name="username" id="username" value="${requestScope.username}" required/>
                        <span id="errUsername" class="err"></span>
                        <c:if test="${requestScope.error == 'Tên đăng nhập tồn tại'}">
                            <div class="err mt-1">Tên đăng nhập tồn tại</div>
                        </c:if>
                        <br>


                        <label class="form-label">Email:</label>
                        <input class="form-control" type="email" name="email" id="email" value="${requestScope.email}" required>
                        <span id="errEmail" class="err"></span>
                        <c:if test="${requestScope.error == 'Email đã được sử dụng!'}">
                            <div class="err mt-1">Email đã được sử dụng</div>
                        </c:if>
                        <br>


                        <label class="form-label">Mật khẩu:</label>
                        <input class="form-control" type="password" name="password" id="password" required>
                        <span id="errPassword" class="err"></span>
                        <br>


                        <label class="form-label">Nhập lại mật khẩu:</label>
                        <input class="form-control" type="password" name="repassword" id="repassword" required>
                        <span id="errRepassword" class="err"></span>
                        <br>


                        <label class="form-label">Giới tính:</label>
                        <div class="d-flex gap-4">
                            <label class="form-check">
                                <input class="form-check-input" type="radio" name="gender" value="male"
                                       ${empty requestScope.gender || requestScope.gender == 'male' ? 'checked' : ''}> Nam
                            </label>
                            <label class="form-check">
                                <input class="form-check-input" type="radio" name="gender" value="female"
                                       ${requestScope.gender == 'female' ? 'checked' : ''}> Nữ
                            </label>
                            <label class="form-check">
                                <input class="form-check-input" type="radio" name="gender" value="other"
                                       ${requestScope.gender == 'other' ? 'checked' : ''}> Khác
                            </label>
                        </div>
                        <br>


                        <label class="form-label">Vai trò:</label>
                        <div class="d-flex gap-4">
                            <label class="form-check">
                                <input class="form-check-input" type="radio" name="role" value="Student"
                                       ${empty requestScope.role || requestScope.role == 'Student' ? 'checked' : ''} required> Học sinh
                            </label>
                            <label class="form-check">
                                <input class="form-check-input" type="radio" name="role" value="Parent"
                                       ${requestScope.role == 'Parent' ? 'checked' : ''} required> Phụ huynh
                            </label>
                        </div>
                        <br>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100">Đăng ký</button>
                        </div>
                    </form>

                    <p class="mt-3">Đã có tài khoản? <a href="login">Đăng nhập</a></p>
                </div>

                <div class="right">
                    <div class="inset"></div>
                </div>
            </div>
        </main>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
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
                document.getElementById("errUsername").innerText = "Tên đăng nhập phải từ 5 đến 20 kí tự"
                valid = false;
            }

            let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                document.getElementById("errEmail").innerText = "Email không hợp lệ";
                valid = false;
            }

            let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!passPattern.test(password)) {
                document.getElementById("errPassword").innerText = "Mật khẩu tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
                valid = false;

            }
            if (password != repassword) {
                document.getElementById("errRepassword").innerText = "Mật khẩu nhập lại không khớp";
                valid = false;
            }

            return valid;
        }
    </script>
</html>
