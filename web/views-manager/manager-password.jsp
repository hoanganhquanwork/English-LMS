<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đổi mật khẩu - Manager</title>

        <link rel="stylesheet" href="<c:url value='/css/manager-style.css' />">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
              crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
              rel="stylesheet"
              crossorigin="anonymous">
    </head>

    <body class="dashboard">

        <main class="main-content">
            <div class="container py-4">
                <div class="row justify-content-center">
                    <div class="col-lg-7">
                        <div class="card shadow-sm border-0">
                            <div class="card-body">
                                <h4 class="card-title mb-4 text-primary fw-semibold">
                                    Thay đổi mật khẩu quản lý
                                </h4>
                                <c:if test="${not empty successMessage}">
                                    <div class="alert alert-success d-flex justify-content-between align-items-center" role="alert">
                                        <span><i class="fa fa-check-circle me-2"></i>${successMessage}</span>
                                        <a href="manager-profile" class="btn btn-sm btn-outline-success">← Quay lại hồ sơ</a>
                                    </div>
                                </c:if>

                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger" role="alert">
                                        <i class="fa fa-triangle-exclamation me-2"></i>${errorMessage}
                                    </div>
                                </c:if>
                                <div class="text-danger small mt-1">${requestScope.errorOAuth}</div>

                                <form action="changeManagerPassword"
                                      method="post" onsubmit="return validatePassword()">

                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                        <div class="text-danger small mt-1">${requestScope.errorPassword}</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                        <div id="errPassword" class="text-danger small mt-1"></div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                        <div id="errRepassword" class="text-danger small mt-1"></div>
                                    </div>

                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary px-4">
                                            Đổi mật khẩu
                                        </button>

                                        <a href="manager-profile" 
                                           class="btn btn-secondary px-4" 
                                           style="margin-left: 10px;">
                                            Quay lại
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function validatePassword() {
                document.getElementById("errPassword").innerText = "";
                document.getElementById("errRepassword").innerText = "";

                let newPassword = document.getElementById("newPassword").value;
                let confirmPassword = document.getElementById("confirmPassword").value;
                let valid = true;
                let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

                if (!passPattern.test(newPassword)) {
                    document.getElementById("errPassword").innerText =
                            "Mật khẩu tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
                    valid = false;
                }
                if (newPassword !== confirmPassword) {
                    document.getElementById("errRepassword").innerText = "Mật khẩu nhập lại không khớp!";
                    valid = false;
                }
                return valid;
            }
        </script>
    </body>
</html>