<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Xóa tài khoản | LinguaTrack</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <main class="container">
    <div class="page-title">
      <h2>Xóa tài khoản</h2>
      <p class="lead">Vui lòng nhập mật khẩu để xác nhận xóa. Hành động này <strong>không thể hoàn tác</strong>.</p>
    </div>

    <c:if test="${not empty error}">
      <div class="alert danger">${error}</div>
    </c:if>

    <section class="card panel">
      <form class="form" method="post" action="${pageContext.request.contextPath}/parent/delete">
        <div class="field">
          <label>Mật khẩu</label>
          <input class="input" type="password" name="password" required />
        </div>
        <div class="actions">
          <button class="btn" type="submit">Xác nhận xóa</button>
          <a class="btn secondary" href="${pageContext.request.contextPath}/parent/settings">Hủy</a>
        </div>
      </form>
    </section>
  </main>
</body>
</html>
