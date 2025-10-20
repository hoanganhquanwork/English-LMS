<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Admin - Hồ sơ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
</head>
<body>
    <div class ="main-content">
        <%@ include file="admin_sidebar.jsp" %>
        <div class="container py-4">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title mb-4">Thay đổi mật khẩu</h5>
                            <div class="text-danger small mt-1">${requestScope.errorOAuth}</div>
                            <form action="${pageContext.request.contextPath}/admin/changePassword" method="post" onsubmit="return validatePassword()">
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
            </div>
        </div>
    </div>
    <footer>
        <jsp:include page="../footer.jsp"/>
    </footer>

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
    </script>
</html>
