<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    request.setAttribute("currentPage", "progress");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết tiến độ khóa học | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />
    </head>

    <body>
        <%@ include file="parent_header.jsp" %>

        <main class="container">

            <!-- Course Header -->
            <div class="page-title">
                <h2>Khóa học: ${coursePage.course.title}</h2>
                <p>
                    Ngôn ngữ: <b>${coursePage.course.language}</b> • 
                    Cấp độ: <b>${coursePage.course.level}</b>
                </p>
            </div>

            <!-- Course Summary -->
            <div class="progress-overview">
                <div class="overview-card">
                    <div class="card-icon">🎯</div>
                    <div class="card-content">
                        <h3>${fn:substringBefore(coursePage.progressPct, ".")}%</h3>
                        <p>Tiến độ khóa học</p>
                        <div class="progress-bar" style="background: ghostwhite;">
                            <div class="progress-fill" data-width="${coursePage.progressPct}"></div>
                        </div>
                    </div>
                </div>
                <div class="overview-card">
                    <div class="card-icon">📚</div>
                    <div class="card-content">
                        <h3>${coursePage.completedItems} / ${coursePage.totalItems}</h3>
                        <p>Bài học hoàn thành</p>
                    </div>
                </div>
                 <div class="overview-card">
                     <div class="card-icon">✅</div>
                     <div class="card-content">
                         <h3>${coursePage.completedRequired} / ${coursePage.totalRequired}</h3>
                         <p>Bài học bắt buộc</p>
                     </div>
                 </div>
                 <div class="overview-card">
                     <div class="card-icon">📊</div>
                     <div class="card-content">
                         <h3>
                             <c:choose>
                                 <c:when test="${coursePage.avgScorePct != null}">
                                     ${fn:substringBefore(coursePage.avgScorePct, ".")}/100
                                 </c:when>
                                 <c:otherwise>
                                     Chưa có điểm
                                 </c:otherwise>
                             </c:choose>
                         </h3>
                         <p>Điểm trung bình</p>
                     </div>
                 </div>

            </div>

            <!-- Module Breakdown -->
            <section class="modules">
                <h3>Danh sách module & bài học</h3>

                <c:forEach var="m" items="${coursePage.modules}">
                    <div class="module-section">
                        <div class="module-header">
                            <span>Module ${m.orderIndex}: ${m.title}</span>
                        </div>
                        <ul class="lesson-list">
                            <c:forEach var="i" items="${m.items}">
                                <li class="lesson-item ${i.status == 'completed' ? 'completed' : ''}">
                                    <div class="lesson-info">
                                        <span class="lesson-icon">
                                        </span>
                                        <span class="lesson-title">${i.title}</span>
                                        <span class="lesson-badge ${i.itemType}">${i.itemType}</span>
                                        <c:if test="${!i.required}">
                                            <span class="badge bg-secondary ms-2">Tùy chọn</span>
                                        </c:if>
                                    </div>
                                    <div class="lesson-status">
                                        <c:choose>
                                            <c:when test="${i.status == 'completed'}">
                                                <i class="bi bi-check-circle-fill text-success"></i>
                                                <span>Đã hoàn thành</span>

                                                <c:if test="${i.scorePct != null}">
                                                    <span class="lesson-score">Điểm: ${i.scorePct}/100</span>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-circle text-muted"></i>
                                                <span>Chưa hoàn thành</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:forEach>
            </section>
        </main>

        <jsp:include page="/footer.jsp" />
        
       
    </body>
</html>
