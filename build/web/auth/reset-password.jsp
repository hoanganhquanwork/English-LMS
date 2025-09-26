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
        <title>Đổi mật khẩu</title>
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

    <body>
        <div class="container">
            <div class="card p-4">
                <h2 class="text-center mb-3">Đặt lại mật khẩu</h2>

                <form action="${pageContext.request.contextPath}/reset-password" 
                      method="post" 
                      onsubmit="return validatePassword()">

                    <input type="hidden" name="token" value="${requestScope.token}">

                    <div class="mb-3">
                        <label for="password" class="form-label">Nhập mật khẩu mới</label>
                        <input type="password" 
                               id="password" 
                               name="password" 
                               class="form-control" 
                               placeholder="Nhập mật khẩu mới"
                               required>
                        <div id="errPassword" class="text-danger small mt-1"></div>
                    </div>

                    <!-- re-password -->
                    <div class="mb-3">
                        <label for="repassword" class="form-label">Xác nhận mật khẩu mới</label>
                        <input type="password" 
                               id="repassword" 
                               class="form-control" 
                               placeholder="Nhập lại mật khẩu"
                               required>
                        <div id="errRepassword" class="text-danger small mt-1"></div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Cập nhật mật khẩu</button>
                </form>
            </div>
        </div>
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
