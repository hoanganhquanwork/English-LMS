<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Cài đặt tài khoản | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent-profile-styles.css" />
</head>
<body>
  <!-- Header -->
    <jsp:include page="/header.jsp" />


  <!-- Main -->
  <main class="container">
    <div class="page-title">
      <h2>Cài đặt tài khoản</h2>
      <p class="lead">Cập nhật thông tin cá nhân và quản lý tài khoản.</p>
    </div>

    <!-- Form cập nhật thông tin -->
    <section class="card panel">
      <h3>Thông tin cá nhân</h3>
      <form class="form" method="post" action="${pageContext.request.contextPath}/parent/updateProfile">
        <div class="field">
          <label>Họ và tên</label>
          <input class="input" type="text" name="full_name" value="${user.fullName}" required />
        </div>
        <div class="field">
          <label>Email</label>
          <input class="input" type="email" name="email" value="${user.email}" required />
        </div>
        <div class="field">
          <label>Ảnh đại diện (URL)</label>
          <input class="input" type="url" name="profile_picture" value="${user.profilePicture}" />
        </div>
        <div class="field">
          <label>Điện thoại</label>
          <input class="input" type="text" name="phone" value="${user.phone}" />
        </div>
        <div class="field">
          <label>Giới tính</label>
          <select class="input" name="gender">
            <option value="">-- Chọn --</option>
            <option value="male"   ${user.gender == 'male'   ? 'selected' : ''}>Nam</option>
            <option value="female" ${user.gender == 'female' ? 'selected' : ''}>Nữ</option>
            <option value="other"  ${user.gender == 'other'  ? 'selected' : ''}>Khác</option>
          </select>
        </div>
        <div class="field">
          <label>Ngày sinh</label>
          <input class="input" type="date" name="date_of_birth" value="${user.dateOfBirth}" />
        </div>
        <div class="field">
          <label>Địa chỉ</label>
          <input class="input" type="text" name="address" value="${parent.address}" />
        </div>
        <div class="field">
          <label>Nghề nghiệp</label>
          <input class="input" type="text" name="occupation" value="${parent.occupation}" />
        </div>

        <div class="actions">
          <button class="btn-save" type="submit">Lưu thay đổi</button>
        </div>
      </form>
    </section>

    <!-- Xóa tài khoản -->
    <section class="card panel" style="margin-top:20px;">
      <h3>Quản lý tài khoản</h3>
      <p class="muted">Bạn có thể xóa tài khoản. Hành động này không thể hoàn tác.</p>
      <a class="btn-save"
         style="background: linear-gradient(135deg, var(--danger), #f87171);
                box-shadow: 0 8px 24px rgba(239,68,68,.25);"
         href="${pageContext.request.contextPath}/parent/deactiveAccount"
         onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này? Hành động này không thể hoàn tác!');">
         Xóa tài khoản
      </a>
    </section>
  </main>

  <!-- Footer -->
      <jsp:include page="/footer.jsp" />

</body>
</html>
