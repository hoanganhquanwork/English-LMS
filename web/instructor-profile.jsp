<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${instructor.user.fullName}</title>
        <style>
            .instructor-profile {
                max-width: 1000px;
                margin: 40px auto;
                padding: 20px;
                font-family: Arial, sans-serif;
            }

            .header {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .avatar {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
            }

            .course-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .course-card {
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 10px;
                overflow: hidden;
                transition: 0.2s;
            }
            .course-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .course-card img {
                width: 100%;
                height: 140px;
                object-fit: cover;
            }
            .course-card h3 {
                margin: 10px;
            }
        </style>
    </head>
    <body>
        <div class="instructor-profile">

            <div class="header">
                <img src="${instructor.user.profilePicture}" class="avatar" alt="Ảnh đại diện">
                <div class="info">
                    <h1>${instructor.user.fullName}</h1>
                    <p><b>Email:</b> ${instructor.user.email}</p>
                    <p><b>Chuyên môn:</b> ${instructor.expertise}</p>
                    <p><b>Bằng cấp:</b> ${instructor.qualifications}</p>
                </div>
            </div>

            <div class="bio">
                <h2>Giới thiệu</h2>
                <p>${instructor.bio}</p>
            </div>

            <hr>

            <div class="courses">
                <h2>Khóa học của giảng viên</h2>
                <div class="course-grid">
                    <c:forEach var="c" items="${courses}">
                        <div class="course-card">
                            <img src="${pageContext.request.contextPath}/${c.thumbnail}" alt="${c.title}">
                            <h3>${c.title}</h3>
                            <p>${c.language} • ${c.level}</p>
                            <p>
                                <c:choose>
                                    <c:when test="${not empty c.price}">$${c.price}</c:when>
                                    <c:otherwise>Miễn phí</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </body>
</html>