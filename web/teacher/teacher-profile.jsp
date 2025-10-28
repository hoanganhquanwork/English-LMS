<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Instructor</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
   
    
    <div class="profile-container">
        <!-- Back Navigation -->
        <div class="back-navigation">
            <a href="manage" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Quay lại
            </a>
        </div>

        <div class="profile-main">
            <!-- LEFT: Avatar -->
            <div class="profile-left">
                <form action="updateTeacherPictureProfile" method="post" enctype="multipart/form-data">
                    <div class="profile-card">
                        <c:set var="user" value="${sessionScope.user}" />
                        <c:if test="${user.profilePicture == null}">
                            <img src="${pageContext.request.contextPath}/image/avatar/avatar_0.png" alt="avatar" class="profile-avatar">
                        </c:if>
                        <c:if test="${user.profilePicture != null}">
                            <img src="${pageContext.request.contextPath}/${user.profilePicture}" alt="avatar" class="profile-avatar">
                        </c:if>
                        <div class="profile-upload">
                            <label for="avatar-upload" ><u>Đổi ảnh đại diện</u></label>
                            <input type="file" id="avatar-upload" name="avatar"
                                   accept="image/png, image/jpeg" onchange="this.form.submit()">
                        </div>
                        <div class="profile-upload-desc">JPG hoặc PNG, tối đa 5MB</div>
                    </div>
                </form>
            </div>

            <!-- RIGHT: Info -->
            <form action="updateTeacherProfile" method="post">
                <div class="profile-right">
                    <div class="profile-form-title">THÔNG TIN CÁ NHÂN</div>

                    <div class="profile-form-row">
                        <div class="profile-form-group">
                            <label>Tên đăng nhập</label>
                            <input type="text" name="username" value="${sessionScope.user.username}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Họ và tên</label>
                            <input type="text" name="fullName" value="${sessionScope.user.fullName}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Vai trò</label>
                            <input type="text" name="role" value="${sessionScope.user.role}" readonly>
                        </div>
                    </div>

                    <div class="profile-form-row">
                        <div class="profile-form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="${sessionScope.user.email}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" value="${sessionScope.user.phone}" readonly>
                        </div>
                        <div class="profile-form-group">
                            <label>Ngày sinh</label>
                            <input type="date" name="dob" value="${sessionScope.user.dateOfBirth}" readonly>
                        </div>
                    </div>
                    
                    <div class="profile-form-row">
                        <div class="profile-form-group">
                            <label>Giới tính</label>
                            <select name="gender" disabled>
                                <option value="male"   ${sessionScope.user.gender=='male'?'selected':''}>Nam</option>
                                <option value="female" ${sessionScope.user.gender=='female'?'selected':''}>Nữ</option>
                                <option value="other"  ${sessionScope.user.gender=='other'?'selected':''}>Khác</option>
                            </select>
                        </div>
                    </div>

                    <!-- Additional Instructor Fields -->
                    <div class="profile-form-group">
                        <label>Tiểu sử (Bio)</label>
                        <textarea name="bio" rows="6" readonly>${requestScope.instructorProfile.bio}</textarea>
                    </div>
                    
                    <div class="profile-form-group">
                        <label>Chuyên môn (Expertise)</label>
                        <textarea name="expertise" rows="4" readonly>${requestScope.instructorProfile.expertise}</textarea>
                    </div>
                    
                    <div class="profile-form-group">
                        <label>Bằng cấp (Qualifications)</label>
                        <textarea name="qualifications" rows="4" readonly>${requestScope.instructorProfile.qualifications}</textarea>
                    </div>

                    <div>
                        <button type="button" class="profile-edit-btn" onclick="edit()">Chỉnh sửa</button>
                        <button type="submit" class="profile-save-btn" style="display:none;">Lưu</button>
                    </div>

                    <div class="messages">
                        <p class="success">${requestScope.updateSuccess}</p>
                        <p class="error">${requestScope.updateFail}</p>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
   
        function edit() {
            // Enable specific fields that should be editable
            const editableInputs = document.querySelectorAll('input[name="fullName"], input[name="phone"], input[name="dob"], select[name="gender"]');
            const editableTextareas = document.querySelectorAll('textarea[name="bio"], textarea[name="expertise"], textarea[name="qualifications"]');
            const editBtn = document.querySelector('.profile-edit-btn');
            const saveBtn = document.querySelector('.profile-save-btn');
            
            // Enable input fields
            editableInputs.forEach(input => {
                input.removeAttribute('readonly');
                input.removeAttribute('disabled');
            });
            
            // Enable textarea fields
            editableTextareas.forEach(textarea => {
                textarea.removeAttribute('readonly');
            });
             
             editBtn.style.display = 'none';
             saveBtn.style.display = 'inline-block';
         }
    </script>
</body>
</html>

