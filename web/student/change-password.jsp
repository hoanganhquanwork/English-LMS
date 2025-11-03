<%-- 
    Document   : change-password
    Created on : Sep 27, 2025, 1:17:04 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">

    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <div class="container py-4 flex-grow-1">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title mb-4">Thay đổi mật khẩu</h5>
                            <div class="text-danger small mt-1">${requestScope.errorOAuth}</div>
                            <form action="${pageContext.request.contextPath}/changeUserPassword" method="post" onsubmit="return validatePassword()">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Mật khẩu hiện tại" required>
                                    <div class="text-danger small mt-1">${requestScope.errorPassword}</div>

                                </div>

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Mật khẩu mới" required>
                                    <div id="errPassword" class="text-danger small mt-1"></div>
                                </div>

                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
                                    <div id="errRepassword" class="text-danger small mt-1"></div>
                                </div>

                                <button type="submit" class="btn btn-primary px-4">Đổi mật khẩu</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Vô hiệu hóa tài khoản</h5>
                            <p class="mb-3">
                                Vô hiệu hóa tài khoản là hành động vĩnh viễn và không thể hoàn tác.
                                Nếu bạn chắc chắn muốn vô hiệu hóa tài khoản, hãy chọn nút bên dưới.
                            </p>
                            <form action="${pageContext.request.contextPath}/deactiveStudentAccount" method="post" onsubmit="return validateDeactivate()">
                                <div class="mb-3">
                                    <input type="password"
                                           class="form-control"
                                           name="password"
                                           id="deactivatePassword"
                                           placeholder="Nhập mật khẩu"
                                           required>
                                    <div id="errPasswordDeactivate" class="text-danger small mt-1"></div>
                                    <div class="text-danger small mt-1">${requestScope.errorDeactiveMessage}</div>
                                </div>
                                <button type="submit" class="btn btn-danger w-100">
                                    Vô hiệu hóa tài khoản
                                </button>
                            </form>

                        </div>
                    </div>
                </div>

            </div>
        </div>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>

    <script>
        function validatePassword() {
            document.getElementById("errPassword").innerText = "";
            document.getElementById("errRepassword").innerText = "";

            let newPassword = document.getElementById("newPassword").value;
            let confirmPassword = document.getElementById("confirmPassword").value;

            let valid = true;

            let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!passPattern.test(newPassword)) {
                document.getElementById("errPassword").innerText = "Mật khẩu tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
                valid = false;

            }
            if (newPassword != confirmPassword) {
                document.getElementById("errRepassword").innerText = "Mật khẩu nhập lại không khớp!";
                valid = false;
            }

            return valid;
        }

        function validateDeactivate() {
            const pass = document.getElementById("deactivatePassword").value.trim();
            document.getElementById("errPasswordDeactivate").innerText = "";
            let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!passPattern.test(pass)) {
                document.getElementById("errPasswordDeactivate").innerText = "Mật khẩu tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
                return false;
            }
            return true;
        }
    </script>
</html>
