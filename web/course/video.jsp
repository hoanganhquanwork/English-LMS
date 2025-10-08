<%-- 
    Document   : video
    Created on : Oct 8, 2025, 12:11:14 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .video-wrapper {
                max-width: 1120px;
                margin: 0 auto;
            }
            .video-title {
                font-weight: 700;
                margin-bottom: 16px;
            }
            .video-frame {
                border-radius: 12px;
                overflow: hidden;
                background: #f5f7fb;
            }
        </style>

    </head>
    <body>
        <div class="video-wrapper">
            <c:set var="vTitle" value="${lesson.title}" />
            <c:set var="vUrl" value="${lesson.videoUrl}" />
            <!-- Tiêu đề -->
            <h2 class="video-title">${vTitle}</h2>

            <!-- Khung video -->
            <c:choose>
                <c:when test="${not empty vUrl}">
                    <div class="ratio ratio-16x9 video-frame shadow-sm">
                        <iframe
                            src="${vUrl}"
                            title="${vTitle}"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                            allowfullscreen
                            frameborder="0">
                        </iframe>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning mt-3">
                        Không tìm thấy video cho bài học này.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
