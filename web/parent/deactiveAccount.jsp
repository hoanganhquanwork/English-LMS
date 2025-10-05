<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Vô hiệu  tài khoản | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent-profile-styles.css" />
    </head>
    <body>
        <main class="container">
            <div class="page-title">
                <h2>Vô hiệu hóa tài khoản</h2>
                <p class="lead">Vui lòng nhập mật khẩu để xác nhận vô hiệu hóa tài khoản. Hành động này <strong>không thể hoàn tác</strong>.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert danger">${error}</div>
            </c:if>

            <section class="card panel">
                <form class="form" method="post" action="${pageContext.request.contextPath}/parent/deactiveAccount">
                    <div class="field">
                        <label>Mật khẩu</label>
                        <input class="input" type="password" name="password" required />
                    </div>
                    <div class="actions">
                        <button class="btn-save" type="submit">Xác nhận vô hiệu hóa tài khoản</button>
                        <a class="btn-save secondary" href="${pageContext.request.contextPath}/parent/updateProfile">Hủy</a>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
