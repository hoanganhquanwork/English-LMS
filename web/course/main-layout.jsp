<%-- 
    Document   : main-layout
    Created on : Oct 8, 2025, 12:00:26 AM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course Viewer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css"/>
        <style>
            body {
                /*background-color: #f8f9fa;*/
            }
            .layout {
                display:flex;
                min-height:100vh;
            }
            .sidebar {
                width:300px;
            }
            .item-active {
                background:#f0f6ff;
                border-left:4px solid #0d6efd;
            }
            /*video*/
            .video-page-wrapper {
                max-width: 1300px;
                margin: 0 auto;

            }
            .video-title {
                font-weight: 700;
                margin: 18px 0;
            }
            .video-frame {
                border-radius: 12px;
                overflow: hidden;
                background: #f5f7fb;
                width: 100%;
                max-width: 1500px;
                height: auto;
                margin: 0 auto;
                display: block;
            }

            /*reading*/
            .reading-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 40px 20px;
                line-height: 1.8;
                color: #2d2f31;
            }

            .reading-container h1 {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 1.2rem;
                color: #000;
                text-align: center;
            }

            .reading-container p {
                font-size: 1.05rem;
                margin-bottom: 1rem;
            }

            .reading-actions {
                margin-top: 2rem;
                display: flex;
                justify-content: start;
            }

            .btn-complete {
                background-color: #0d6efd;
                color: #fff;
                font-weight: 500;
                padding: 10px 24px;
                border-radius: 6px;
                border: none;
            }

            .btn-complete:hover {
                background-color: #0b5ed7;
            }

            .feedback-links {
                margin-top: 2.5rem;
                text-align: center;
                font-size: 0.9rem;
                color: #555;
            }
            .feedback-links a {
                text-decoration: none;
                margin: 0 10px;
                color: #0d6efd;
            }

            .feedback-links a:hover {
                text-decoration: underline;
            }
            .link-custom{
                text-decoration: none;
                color: white
            }
            .go-to-next-item {
                bottom: 20px;
                padding: 10px 20px;
                font-size: 1rem;
                text-decoration: none;
            }
            .custom-hr {
                border: 0;
                border-top: 3px dashed #007bff !important;
                margin-top: 20px !important;
                margin-bottom: 20px !important ;
            }
            .custom-container{
                padding-left: 300px;
                padding-right: 300px;
            }
            .rely-frame{
                background: #f8f9fa;
                border-radius: 8px;
                padding: 30px 50px;
            }

            /* Tùy chỉnh các bình luận */
            .comment {
                border: 1px solid #ddd;
                background-color: #fff;
                border-radius: 8px;
                padding: 15px;
            }

            /* Tùy chỉnh nút Reply */
            .reply-btn {
                font-size: 0.9rem;
                color: #007bff;
                border: none;
                background: none;
                cursor: pointer;
            }

            .comment .text-muted {
                font-size: 0.9rem;
            }

            .comment .btn-link {
                font-size: 0.9rem;
                text-decoration: none;
            }

            .comment .btn-link:hover {
                text-decoration: underline;
            }

            /* Ẩn ô trả lời */
            .reply-form {
                display: none;
                margin-top: 10px;
            }

            /* Đảm bảo ô nhập dữ liệu chiếm hết chiều rộng */
            textarea.form-control {
                resize: none;
            }

            /* Tùy chỉnh form trả lời */
            .reply-form h5 {
                font-weight: bold;
            }

            /* Khung thông báo đã nộp phản hồi */
            .card-body {
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 8px;
                border: 1px solid #ddd;
            }

            .card-title {
                font-weight: bold;
                font-size: 1.25rem;
            }

            .card-text {
                font-size: 1rem;
            }

            .card-body .btn-outline-primary {
                font-weight: 600;
            }

            .my-response:hover {
                background-color: #f8f9fa;
                color: #007bff;
            }

            .dic-btn{
                width:48px;
                height:48px;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                border-radius:50%;
                border:0;
                cursor:pointer;
                color:#fff;
                background:#0d6efd;
                box-shadow:0 10px 24px rgba(13,110,253,.35);
            }

            .dic-fab{
                position: fixed;
                right: 16px;
                bottom: 16px;
                z-index: 2000;
            }

            .offcanvas-backdrop.show {
                opacity:.35;
                backdrop-filter: blur(2px);
            }



        </style>
    </head>
    <body>
        <c:set var="cp" value="${requestScope.coursePage}" />
        <c:set var="activeItemId" value="${requestScope.activeItemId}" />
        <!-- Header -->
        <header class="py-2">
            <div class="d-flex align-items-center justify-content-between px-5">      
                <div class="d-flex align-items-center flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/image/logo/logo.png" 
                                                                           alt="hi" height="50" class="me-3"></a>
                </div>

                <c:if test="${sessionScope.user != null}">     
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" 
                           id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture == null ? 'image/avatar/avatar_0.png' :sessionScope.user.profilePicture}" 
                                 alt="User Avatar" 
                                 class="rounded-circle me-2" 
                                 style="width:36px; height:36px; object-fit:cover;">
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                            <c:if test="${sessionScope.user.role == 'Student'}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/updateStudentProfile">Thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/changeStudentPassword">Cài đặt mật khẩu</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/studentVocab">Từ điển của tôi</a></li>
                                </c:if>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                        </ul>

                    </div>
                </c:if>
            </div>
        </header>

        <div class="layout">
            <!-- Sidebar -->
            <aside class="sidebar bg-white border-end">
                <div class="p-3">


                    <h4 class="fw-bold mb-3">${cp.course.title}</h4>

                    <div id="course-outline">
                        <c:choose>
                            <c:when test="${not empty cp.modules}">
                                <c:forEach var="m" items="${cp.modules}" varStatus="st">
                                    <!--mo module dau hoạc module chua activeItem-->
                                    <c:set var="expand" value="${st.first}"/>
                                    <c:forEach var="item" items="${m.items}">
                                        <c:if test="${item.moduleItemId == activeItemId}">
                                            <c:set var="expand" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                    <div class="border-bottom mb-2 pb-2">
                                        <!-- Module header -->
                                        <button type="button"
                                                class="btn w-100 d-flex justify-content-between align-items-center text-start ${expand ? "" : "collapsed"}"
                                                data-bs-toggle="collapse"
                                                data-bs-target="#module-${m.moduleId}"
                                                aria-controls="module-${m.moduleId}"
                                                aria-expanded="${expand}">
                                            <span>
                                                <span class="ms-1 fw-semibold text-bolddark">Module ${m.orderIndex}:</span>
                                                <span class="ms-1 fw-semibold text-dark">${m.title}</span>
                                            </span>
                                            <i class="bi bi-chevron-down"></i>
                                        </button>

                                        <!-- Module items -->
                                        <div id="module-${m.moduleId}"
                                             class="collapse ${expand ? 'show' : ''}" data-bs-parent="#course-outline">
                                            <ul class="list-unstyled ps-3 mt-2 mb-0">
                                                <c:forEach var="it" items="${m.items}">
                                                    <c:set var="isActive" value="${it.moduleItemId == activeItemId}"/>
                                                    <li class="d-flex align-items-start mb-2 p-2 rounded ${isActive ? 'item-active' : ''}">
                                                        <!-- trạng thái hoàn thành -->
                                                        <i class="bi ${it.status == 'completed' ? 'bi-check-circle-fill text-success' : 'bi-circle text-muted'} me-2 mt-1"></i>

                                                        <!-- điều hướng theo itemId -->
                                                        <a class="flex-grow-1 text-decoration-none ${isActive  ? 'text-dark' : 'text-body'}"
                                                           href="${pageContext.request.contextPath}/coursePage?itemId=${it.moduleItemId}&courseId=${cp.course.courseId}">
                                                            <div class="fw-semibold small">${it.title}</div>
                                                            <c:if test="${it.itemType == 'lesson'}">
                                                                <small class="text-muted text-capitalize">${it.contentType}</small>
                                                            </c:if>
                                                            <c:if test="${it.itemType != 'lesson'}">
                                                                <small class="text-muted text-capitalize">${it.itemType}</small>
                                                            </c:if>
                                                            <c:if test="${not empty it.durationMin}"> • ${it.durationMin} min</c:if>
                                                            </a>
                                                        </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted small">Hiện tại khóa học không có module</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </aside>

            <!--Content--> 
            <main class="flex-fill p-4">


                <!--For lesson-->

                <c:if test="${requestScope.selectedItemType == 'lesson'}" >

                    <!--For reading-->
                    <c:if test="${requestScope.selectedContentType == 'reading'}" >
                        <div class="reading-container">
                            <h1>Lesson ${requestScope.orderIndex}: ${requestScope.lesson.title}</h1>
                        </div>
                        <div class="custom-container">
                            <div>
                                ${requestScope.lesson.textContent}
                            </div>
                            <div class="reading-actions mt-4">
                                <form method="post" action="${pageContext.request.contextPath}/moduleItemProgress">
                                    <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                    <input type="hidden" name="itemId" value="${activeItemId}">
                                    <input type="hidden" name="contentType" value="${requestScope.selectedContentType}">
                                    <c:if test="${requestScope.status != 'completed'}">
                                        <button type="submit" class="btn-complete">Đánh dấu là đã đọc</button>
                                    </c:if>
                                    <c:if test="${requestScope.status == 'completed'}">
                                        <button type="submit" class="btn-complete">
                                            <a class="link-custom" 
                                               href="${pageContext.request.contextPath}/coursePage?itemId=${activeItemId+1}&courseId=${cp.course.courseId}">
                                                Đi tới mục tiếp theo
                                            </a>
                                        </button>
                                        <i class="bi bi-check-circle-fill text-success ms-2"></i>
                                        <span class="text-success ms-2">Đã hoàn thành</span>
                                    </c:if>

                                </form>
                            </div>
                        </div>
                    </c:if>

                    <!--For video-->
                    <c:if test="${requestScope.selectedContentType == 'video'}" >
                        <div class="ratio ratio-21x9 video-frame shadow-sm">
                            <c:set var="portSuffix" value="" />
                            <c:if test="${pageContext.request.serverPort != 80 && pageContext.request.serverPort != 443}">
                                <c:set var="portSuffix" value=":${pageContext.request.serverPort}" />
                            </c:if>
                            <c:set var="origin" value="${pageContext.request.scheme}://${pageContext.request.serverName}${portSuffix}" />
                            <iframe 
                                id="yt-player"
                                src="https://www.youtube.com/embed/${requestScope.lesson.videoUrl}?enablejsapi=1&rel=0&modestbranding=1&playsinline=1&origin=${origin}"
                                title="${requestScope.lesson.title}"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                allowfullscreen
                                frameborder="0">
                            </iframe>
                        </div>
                        <h4 class="fw-bold mb-3 mt-3 ms-2">Lesson ${requestScope.orderIndex}: ${cp.course.title}</h4>

                        <div class="pb-5">
                            <h5 class="fw-bold mb-3 mt-5">Kiểm tra nhanh</h5>
                            <c:set var="isVideoCompleted" value="${requestScope.videoStatus == 'completed'}"/>
                            <c:choose>
                                <c:when test="${!isVideoCompleted}">
                                    <div id="lockedNotice"
                                         class="card bg-light border-0 rounded-3 shadow-sm mb-4 ${isVideoCompleted ? 'd-none' : ''}">
                                        <div class="card-body text-center py-5">
                                            <div class="display-6 mb-3"><i class="bi bi-lock"></i></div>
                                            <h5 class="fw-semibold mb-2">Bạn vẫn còn bài học cần phải hoàn thành</h5>
                                            <p class="text-muted mb-0">Phần này sẽ mở ra khi bạn hoàn thành video ở bên trên</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div>
                                        <form action="${pageContext.request.contextPath}/checkVideoQuiz" method="post">
                                            <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                            <input type="hidden" name="itemId"   value="${activeItemId}">
                                            <c:forEach var="q" items="${listLessonQuestion}" varStatus="st">
                                                <div class="card border-0 bg-light rounded-3 shadow-sm mb-4">
                                                    <div class="card-body">
                                                        <div class="fw-semibold mb-3">Câu ${st.count}: ${q.content}</div>

                                                        <!-- MCQ single choice -->
                                                        <c:if test="${q.type == 'mcq_single'}">
                                                            <c:set var="userChoice" value="${requestScope.userAnswers[q.questionId]}" />
                                                            <c:set var="isCorrect" value="${quizResult[q.questionId]}" />
                                                            <c:forEach var="opt" items="${q.options}" varStatus="optSt">
                                                                <div class="form-check mb-2">
                                                                    <input class="form-check-input"
                                                                           type="radio"
                                                                           name="answers[${q.questionId}]"
                                                                           id="q${q.questionId}o${opt.optionId}"
                                                                           value="${opt.optionId}" 
                                                                           <c:if test="${optSt.first}">required</c:if>
                                                                           <c:if test="${userChoice == opt.optionId}">checked</c:if>
                                                                           <c:if test="${autoPassed}">disabled</c:if> />

                                                                           <label class="form-check-label
                                                                           ${autoPassed && opt.isCorrect ? ' text-success fw-bold' : ''}
                                                                           ${!autoPassed && showResult && userChoice == opt.optionId && isCorrect ? ' text-success fw-bold' : ''}
                                                                           ${!autoPassed && showResult && userChoice == opt.optionId && !isCorrect ? ' text-danger fw-bold' : ''}"                                                                           for="q${q.questionId}o${opt.optionId}">
                                                                        ${opt.content}
                                                                    </label>
                                                                </div>
                                                            </c:forEach>
                                                        </c:if>
                                                        <!-- Text answer -->
                                                        <c:if test="${q.type == 'text'}">
                                                            <c:choose>
                                                                <c:when test="${autoPassed}">
                                                                    <c:set var="displayValue" value="" />
                                                                    <c:forEach var="key" items="${q.answers}">
                                                                        <c:set var="displayValue" value="${displayValue}" />
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:set var="displayValue" value="${userTextAnswers[q.questionId]}" />
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <input type="text"
                                                                   name="answersText[${q.questionId}]"
                                                                   value="${displayValue}"
                                                                   class="form-control
                                                                   <c:if test='${showResult && isCorrect}'>is-valid</c:if>
                                                                   <c:if test='${showResult && !isCorrect}'>is-invalid</c:if>"
                                                                       placeholder="Nhập câu trả lời của bạn..."
                                                                   <c:if test='${autoPassed}'>readonly</c:if>
                                                                       required/>
                                                        </c:if>



                                                        <!-- Hiện kết quả sau khi chấm -->
                                                        <c:if test="${showResult}">
                                                            <div class="mt-3 small
                                                                 <c:choose>
                                                                     <c:when test='${autoPassed}'>text-success</c:when>
                                                                     <c:otherwise>${quizResult[q.questionId] == true ? "text-success" : "text-danger"}</c:otherwise>
                                                                 </c:choose>">
                                                                <c:choose>
                                                                    <c:when test='${autoPassed}'>Đã hoàn thành </c:when>
                                                                    <c:otherwise>
                                                                        ${quizResult[q.questionId] ? 'Đúng rồi!' : 'Chưa đúng.'}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <c:if test="${not empty q.explanation}">
                                                                    — Giải thích: ${q.explanation}
                                                                </c:if>
                                                            </div>
                                                        </c:if>

                                                    </div>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${!autoPassed}">
                                                <button type="submit" class="btn btn-primary">Gửi câu trả lời</button>
                                            </c:if>
                                            <c:if test="${autoPassed}">
                                                <button type="submit" class="btn-complete">
                                                    <a class="link-custom" 
                                                       href="${pageContext.request.contextPath}/coursePage?itemId=${activeItemId+1}&courseId=${cp.course.courseId}">
                                                        Đi tới mục tiếp theo
                                                    </a>
                                                </button>
                                                <i class="bi bi-check-circle-fill text-success ms-2"></i>
                                                <span class="text-success ms-2">Đã hoàn thành</span>
                                            </c:if>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                </c:if>

                <!--For discussion-->

                <c:if test="${requestScope.selectedItemType == 'discussion'}" >

                    <div class="custom-container">
                        <h1 class="text-center mb-5">${requestScope.discussion.title}</h1>
                        <div >
                            ${requestScope.discussion.description}
                        </div>
                        <h6 class="text-muted mb-5">Không bắt buộc tham gia</h6>
                        <c:if test="${!firstPostStatus}">
                            <form action="${pageContext.request.contextPath}/discussionPost" method="get">
                                <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                <input type="hidden" name="itemId" value="${activeItemId}">
                                <input type="hidden" name="status" value="${requestScope.status}">
                                <div class="mb-4 rely-frame" >
                                    <label for="userReply" class="form-label fw-bold">Phản hồi của bạn</label>
                                    <textarea id="userReply" name="userReply" class="form-control" rows="6" placeholder="Nhập ý kiến của bạn tại đây..."></textarea>
                                    <div class="text-end">
                                        <button type="submit" class="btn btn-outline-primary mt-4">
                                            Phản hồi
                                        </button>
                                        <div class="text-danger small mt-1">${requestScope.errorMessage}</div>
                                    </div>
                                </div>
                            </form>
                        </c:if>

                        <c:if test="${firstPostStatus}">
                            <div class="card mb-4">
                                <div class="card-body text-center">

                                    <p class="card-text text-muted">Phản hồi của bạn đã được ghi nhận. Tham gia và thảo luận với những học viên khác dưới đây!</p>
                                    <a href="${pageContext.request.contextPath}/myResponseDiscussion?itemId=${activeItemId}&courseId=${cp.course.courseId}&pageSize=${requestScope.pageSize}"
                                       class="btn btn-outline-primary bg-white my-response px-4 py-3">
                                        Xem phản hồi của tôi
                                    </a>
                                </div>
                            </div>
                            <div class="comment-section">
                                <c:forEach var="post" items="${requestScope.listPost}">
                                    <div class="comment mb-3 p-3 border rounded bg-white" style="width: 90%; margin: 0 auto">

                                        <div class="d-flex align-items-center mb-2">
                                            <img src="${pageContext.request.contextPath}/${post.avatar == null ? 'image/avatar/avatar_0.png' : post.avatar}" 
                                                 class="me-2" alt="avatar" style="width:40px; height:40px; object-fit:cover;">
                                            <div>
                                                <h6 class="mb-1">${post.fullName != null ? post.fullName : post.authorName}
                                                    <span class="badge bg-primary text-white ms-2">${post.role}</span>
                                                </h6>
                                                <p class="text-muted small mb-0">
                                                    <span>Ngày đăng: ${post.editedAt != null ? post.editedAt : post.createdAt}</span>
                                                    <c:if test="${post.editedAt != null}">
                                                        &bull;
                                                        <span>Edited</span>
                                                    </c:if>
                                                </p>
                                            </div>
                                            <!--Danh dau post cua minh-->
                                            <c:if test="${post.authorName == sessionScope.user.username}">
                                                <span class="ms-auto" style="font-size: 30px;">
                                                    <i class="bi bi-star-fill" style="color: gold;"></i>
                                                </span>
                                            </c:if>
                                        </div>
                                        <c:if test="${post.authorName == sessionScope.user.username}">
                                            <div id="postContent${post.postId}">
                                                <p>${post.content}</p>
                                            </div>
                                            <div>             
                                                <div class="d-flex align-items-center">
                                                    <button type="button" class="btn btn-link edit-btn" onclick="editPostContent('${post.postId}')">Edit</button>
                                                    <a href="#" class="btn btn-link reply-btn" onclick="replyForm('replyForm${post.postId}', event)">Reply</a>
                                                </div>
                                                <!--form edit-->
                                                <div>
                                                    <form action="${pageContext.request.contextPath}/discussionPost" method="post">
                                                        <div id="editForm${post.postId}" style="display:none;">
                                                            <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                            <input type="hidden" name="itemId" value="${activeItemId}">
                                                            <input type="hidden" name="postId" value="${post.postId}">
                                                            <input type="hidden" name="pageNumber" value="${requestScope.page}">

                                                            <label for="userReply${post.postId}" class="fw-bold mb-3">Chỉnh sửa nội dung</label>
                                                            <textarea id="userReply${post.postId}" name="userReply" class="form-control" rows="6"></textarea>
                                                            <div class="text-end">
                                                                <button type="submit" class="btn btn-outline-primary mt-4">Cập nhật</button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!--form reply-->
                                                <div id="replyForm${post.postId}" class="mt-3" style="display:none;">
                                                    <form method="get" action="${pageContext.request.contextPath}/discussionComment">
                                                        <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                        <input type="hidden" name="itemId" value="${activeItemId}">
                                                        <input type="hidden" name="postId" value="${post.postId}">
                                                        <input type="hidden" name="pageNumber" value="${requestScope.page}">
                                                        <div class="form-group">
                                                            <label for="userReply${post.postId}" class="fw-bold mb-3">Phản hồi của bạn</label>
                                                            <textarea id="userReply${post.postId}" name="userReply" class="form-control" 
                                                                      rows="6" placeholder="Nhập phản hồi của bạn tại đây...">
                                                            </textarea>
                                                        </div>
                                                        <div class="text-end">
                                                            <button type="submit" class="btn btn-outline-primary mt-2">Gửi</button>
                                                        </div>
                                                    </form>
                                                </div>

                                            </div>

                                        </c:if>
                                        <c:if test="${post.authorName != sessionScope.user.username}">
                                            <p>${post.content}</p>
                                            <a href="#" class="btn btn-link reply-btn" onclick="replyForm('replyForm${post.postId}', event)">Reply</a>
                                            <div id="replyForm${post.postId}" class="mt-3" style="display:none;">
                                                <form method="get" action="${pageContext.request.contextPath}/discussionComment">
                                                    <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                    <input type="hidden" name="itemId" value="${activeItemId}">
                                                    <input type="hidden" name="postId" value="${post.postId}">
                                                    <input type="hidden" name="pageNumber" value="${requestScope.page}">
                                                    <div class="form-group">
                                                        <label for="userReply${post.postId}" class="fw-bold mb-3">Phản hồi của bạn</label>
                                                        <textarea id="userReply${post.postId}" name="userReply" class="form-control" 
                                                                  rows="6" placeholder="Nhập phản hồi của bạn tại đây...">
                                                        </textarea>
                                                    </div>
                                                    <div class="text-end">
                                                        <button type="submit" class="btn btn-outline-primary mt-2">Gửi</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>

                                        <c:forEach var="com" items="${post.comments}">
                                            <div class="comment reply mt-3">
                                                <div class="d-flex align-items-center mb-2">
                                                    <img src="${pageContext.request.contextPath}/${com.avatar == null ? 'image/avatar/avatar_0.png' : com.avatar}" 
                                                         class="me-2" alt="avatar" style="width:40px; height:40px; object-fit:cover;">
                                                    <div>
                                                        <h6 class="mb-1">${com.fullName != null ? com.fullName : com.authorName}
                                                            <span class="badge bg-primary text-white ms-2">${com.role}</span>
                                                        </h6>
                                                        <p class="text-muted small mb-0">
                                                            <span>Ngày đăng: ${com.editedAt != null ? com.editedAt : com.createdAt}</span>
                                                            <c:if test="${com.editedAt != null}">
                                                                &bull;
                                                                <span>Edited</span>
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </div>
                                                <c:if test="${com.authorName != sessionScope.user.username}">
                                                    <p>${com.content}</p>
                                                </c:if>
                                                <c:if test="${com.authorName == sessionScope.user.username}">
                                                    <div id="commentContent${com.commentId}">
                                                        <p>${com.content}</p>
                                                    </div>
                                                    <button type="button" class="btn btn-link edit-btn" onclick="editCommentContent('${com.commentId}')">Edit</button>

                                                    <form action="${pageContext.request.contextPath}/discussionComment" method="post">
                                                        <div id="editCommentForm${com.commentId}" style="display:none;">
                                                            <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                            <input type="hidden" name="itemId" value="${activeItemId}">
                                                            <input type="hidden" name="commentId" value="${com.commentId}">
                                                            <input type="hidden" name="pageNumber" value="${requestScope.page}">

                                                            <label for="commentReply${com.commentId}" class="fw-bold mb-3">Chỉnh sửa nội dung</label>
                                                            <textarea id="commentReply${com.commentId}" name="userReply" class="form-control" rows="6"></textarea>
                                                            <div class="text-end">
                                                                <button type="submit" class="btn btn-outline-primary mt-4">Cập nhật</button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="text-end">
                                <c:if test="${requestScope.totalPages > 1}">
                                    <div class="pagination-container">

                                        <c:if test="${requestScope.page > 1}">
                                            <a href="${pageContext.request.contextPath}/coursePage?itemId=${discussion.discussionId}&courseId=${cp.course.courseId}&pageNumber=${requestScope.page - 1}" 
                                               class="btn btn-outline-secondary btn-sm">«</a>
                                        </c:if>


                                        <c:forEach begin="1" end="${requestScope.totalPages}" var="i">
                                            <a href="${pageContext.request.contextPath}/coursePage?itemId=${discussion.discussionId}&courseId=${cp.course.courseId}&pageNumber=${i}" 
                                               class="btn btn-sm ${i == requestScope.page ? 'btn-primary' : 'btn-outline-secondary'}">${i}</a>
                                        </c:forEach>


                                        <c:if test="${requestScope.page < requestScope.totalPages}">
                                            <a href="${pageContext.request.contextPath}/coursePage?itemId=${discussion.discussionId}&courseId=${cp.course.courseId}&pageNumber=${requestScope.page + 1}" 
                                               class="btn btn-outline-secondary btn-sm">»</a>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

                    </div>
                </c:if>

                <!--For quiz-->

                <c:if test="${requestScope.selectedItemType == 'quiz'}">
                    <c:set var="quiz"             value="${requestScope.quiz}" />
                    <c:set var="isGraded"         value="${requestScope.isGraded}" />
                    <c:set var="quizView"         value="${requestScope.quizView}" />
                    <c:set var="attempt"          value="${requestScope.attempt}" />
                    <c:set var="bestScore"        value="${requestScope.bestScore}" />
                    <c:set var="latestSubmittedId" value="${requestScope.latestSubmittedId}" />
                    <c:set var="hasPassed"        value="${requestScope.hasPassed}" />
                    <c:set var="isLocked"         value="${requestScope.isLocked}" />
                    <c:set var="cooldownActive"   value="${requestScope.cooldownActive}" />
                    <c:set var="retryAtDisplay"   value="${requestScope.retryAtDisplay}" />
                    <p style="red">${requestScope.errorMessage}</p>
                    <div class="custom-container">
                        <!-- Tiêu đề -->
                        <h1 class="fw-bold mb-4">
                            <c:choose>
                                <c:when test="${not empty quiz and not empty quiz.title}">
                                    Quiz: ${quiz.title}
                                </c:when>
                                <c:otherwise>Quiz</c:otherwise>
                            </c:choose>
                        </h1>

                        <!-- Thông tin tổng quan -->
                        <div class="p-4 rounded-4" style="background:#eef4ff;">
                            <div class="row align-items-center">
                                <div class="col-md-9">
                                    <div class="fw-bold mb-2">Thông tin mô tả</div>
                                    <p>
                                        Yêu cầu đạt:
                                        <c:choose>
                                            <c:when test="${isGraded and not empty quiz.passingScorePct}">
                                                <strong>${quiz.passingScorePct}%</strong>
                                            </c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p>
                                        Số câu hỏi: 
                                        <c:choose>
                                            <c:when test="${not empty quiz.pickCount}"><strong>${quiz.pickCount}</strong></c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p>
                                        Trạng thái hiện tại:
                                        <c:choose>
                                            <c:when test="${empty attempt}">Chưa làm</c:when>
                                            <c:when test="${attempt.status == 'submitted'}">Đã nộp</c:when>
                                            <c:otherwise>Bản nháp</c:otherwise>
                                        </c:choose>
                                    </p>

                                </div>

                                <div class="col-md-3 text-md-end mt-3 mt-md-0">
                                    <c:choose>

                                        <c:when test="${quizView == 'intro'}">
                                            <form action="${pageContext.request.contextPath}/startQuiz" method="get" class="d-inline">
                                                <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                <input type="hidden" name="itemId"   value="${activeItemId}">
                                                <button class="btn btn-primary px-4" ${isLocked ? 'disabled' : ''}>
                                                    Bắt đầu
                                                </button>
                                            </form>
                                        </c:when>

                                        <c:when test="${quizView == 'doing'}">
                                            <a href="${pageContext.request.contextPath}/doQuiz?attemptId=${attempt.attemptId}&courseId=${cp.course.courseId}&itemId=${activeItemId}"
                                               class="btn btn-primary px-4 ${isLocked ? 'disabled' : ''}">
                                                Tiếp tục
                                            </a>
                                        </c:when>

                                        <c:otherwise>
                                            <div class="d-flex flex-wrap gap-2 justify-content-md-end">
                                                <c:if test="${not isGraded and not empty latestSubmittedId}">
                                                    <a class="btn btn-outline-primary"
                                                       href="${pageContext.request.contextPath}/doQuiz?attemptId=${requestScope.latestSubmittedId}&courseId=${cp.course.courseId}&itemId=${activeItemId}">
                                                        Xem kết quả gần nhất
                                                    </a>
                                                </c:if>

                                                <c:choose>
                                                    <c:when test="${isGraded}">
                                                        <form action="${pageContext.request.contextPath}/startQuiz" method="get" class="d-inline">
                                                            <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                            <input type="hidden" name="itemId"   value="${activeItemId}">
                                                            <button class="btn btn-primary px-4" 
                                                                    ${ (hasPassed or isLocked) ? 'disabled' : '' }>
                                                                <i class="bi bi-arrow-clockwise me-1"></i> Làm lại
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/startQuiz" method="get" class="d-inline">
                                                            <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                                            <input type="hidden" name="itemId"   value="${activeItemId}">
                                                            <button class="btn btn-primary px-4">
                                                                <i class="bi bi-arrow-clockwise me-1"></i> Làm lại
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:otherwise>

                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <c:if test="${isGraded}">
                            <div class="mt-3">
                                <div class="p-4 rounded-4
                                     ${not empty bestScore and not empty quiz.passingScorePct and bestScore >= quiz.passingScorePct 
                                       ? 'bg-success-subtle' : 'bg-danger-subtle'}">
                                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                                        <div>
                                            <div class="fw-bold mb-1">Kết quả của bạn</div>
                                            <div class="small text-muted">
                                                Điểm cao nhất:
                                                <span class="fw-semibold
                                                      ${not empty bestScore and not empty quiz.passingScorePct and bestScore >= quiz.passingScorePct 
                                                        ? 'text-success' : 'text-danger'}">
                                                      <c:choose>
                                                          <c:when test="${not empty bestScore}">${bestScore}%</c:when>
                                                          <c:otherwise>--</c:otherwise>
                                                      </c:choose>
                                                </span>
                                            </div>
                                        </div>

                                        <c:if test="${isGraded}">
                                            <c:if test="${hasPassed}">
                                                <div class="text-end">
                                                    <div class="alert alert-success my-2">
                                                        <i class="bi bi-check-circle me-2"></i>
                                                        Bạn đã đạt yêu cầu
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${!hasPassed and cooldownActive}">
                                                <div class="alert alert-warning my-2">
                                                    <i class="bi bi-hourglass-split me-2"></i>
                                                    Bạn chưa đạt. Lần làm tiếp theo lúc: <strong>${retryAtDisplay}</strong>
                                                </div>
                                            </c:if>
                                        </c:if>

                                        <div class="text-md-end">
                                            <c:if test="${not isGraded}">
                                                <c:choose>
                                                    <c:when test="${not empty latestSubmittedId }">
                                                        <a class="btn btn-outline-primary"
                                                           href="${pageContext.request.contextPath}/doQuiz?attemptId=${latestSubmittedId}&courseId=${cp.course.courseId}&itemId=${activeItemId}">
                                                            Xem bài đã nộp
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-outline-secondary" disabled>Chưa có bài nộp</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${!isGraded}">
                            <div class="alert alert-info mt-3">
                                Chế độ ôn tập: không giới hạn thời gian, có thể làm lại nhiều lần. 
                            </div>
                        </c:if>
                    </div>

                </c:if>

                <!--For assignment-->
                <c:if test="${requestScope.selectedItemType == 'assignment'}">
                    <c:set var="assignment" value="${requestScope.assginment}" />
                    <c:set var="awWork" value="${requestScope.awWork}" />
                    <c:set var="awStatus" value="${requestScope.awStatus}" />
                    <c:set var="isCooldown" value="${requestScope.isCooldown}" />
                    <c:set var="nextRetryAt" value="${requestScope.nextRetryAt}" />
                    <c:set var="canEdit" value="${requestScope.canEdit}" />
                    <c:set var="canSubmit" value="${requestScope.canSubmit}" />
                    <c:set var="showResult" value="${requestScope.showResult}" />

                    <div class="custom-container">

                        <!-- Title -->
                        <h1 class="fw-bold mb-3">Assignment: ${assignment.title}</h1>


                        <!-- Tabs -->
                        <ul class="nav nav-tabs mt-3" id="assignmentTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="instr-tab" data-bs-toggle="tab" 
                                        data-bs-target="#instr-pane" type="button" role="tab"
                                        aria-controls="instr-pane" aria-selected="true">
                                    Hướng dẫn
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="my-tab" data-bs-toggle="tab" 
                                        data-bs-target="#my-pane" type="button" role="tab"
                                        aria-controls="my-pane" aria-selected="false">
                                    Bài làm
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="assignmentTabContent">

                            <!-- TAB: Instruction -->
                            <div class="tab-pane fade show active p-3" id="instr-pane" role="tabpanel" aria-labelledby="instr-tab">
                                <div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            ${assignment.instructions}
                                        </div>

                                        <c:if test="${not empty assignment.passingScorePct}">
                                            <div class="small text-bold mb-2">
                                                Yêu cầu đạt: <strong>${assignment.passingScorePct}%</strong>
                                            </div>
                                        </c:if>

                                        <div class="small text-bold mb-2">
                                            Kiểu nộp bài: <strong class="text-uppercase">${assignment.submissionType}</strong>

                                        </div>

                                        <c:if test="${assignment.aiGradeAllowed}">
                                            <div class="small text-bold">
                                                Cho phép chấm tự động
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- TAB: My submission -->
                            <div class="tab-pane fade p-3" id="my-pane" role="tabpanel" aria-labelledby="my-tab">
                                <div>
                                    <div class="card-body">
                                        <h5 class="fw-bold mb-3">Mô tả bài làm</h5>

                                        <div class="assignment-content">
                                            ${assignment.content}
                                        </div>

                                        <!-- Tài liệu đính kèm (nếu có) -->
                                        <c:if test="${not empty assignment.attachmentUrl}">
                                            <hr/>
                                            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                                <div>
                                                    <i class="bi bi-paperclip me-2"></i>Tài liệu đính kèm
                                                </div>
                                                <a class="btn btn-outline-primary btn-sm"
                                                   href="${pageContext.request.contextPath}/${assignment.attachmentUrl}"
                                                   download target="_blank">
                                                    <i class="bi bi-download me-1"></i> Tải xuống
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>


                                <!--Nộp bài-->
                                <div class="mt-3">
                                    <div class="card-body">
                                        <h5 class="fw-bold mb-3">Bài làm của bạn</h5>

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/assignmentDo"
                                              enctype="multipart/form-data">
                                            <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
                                            <input type="hidden" name="courseId" value="${cp.course.courseId}">
                                            <input type="hidden" name="submissionType" value="${assignment.submissionType}">

                                            <!--Type : text-->
                                            <c:if test="${assignment.submissionType == 'text'}">
                                                <c:choose>
                                                    <c:when test="${canEdit}">
                                                        <textarea id="textAnswer"
                                                                  name="textAnswer"
                                                                  class="form-control"
                                                                  rows="20" 
                                                                  >${awWork != null ? awWork.textAnswer : ''}</textarea>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="form-control" style="min-height:240px; overflow:auto;">
                                                            ${awWork != null ? awWork.textAnswer : ''}
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>

                                            <!-- TYPE = FILE (.docx hoặc .mp3) -->

                                            <c:if test="${assignment.submissionType == 'file'}">
                                                <c:set var="fname" value="${(not empty awWork && not empty awWork.fileUrl)
                                                                            ? fn:substringAfter(awWork.fileUrl, 'uploads/assignmentWork/')
                                                                            : ''}" />
                                                <div class="mb-3">
                                                    <label class="form-label">Tệp bài làm</label>
                                                    <input class="form-control"
                                                           type="file"
                                                           name="answerFile"
                                                           accept=".docx,audio/mpeg"                                                          
                                                           ${!canEdit ? 'disabled' : ''}>
                                                    <div class="form-text">
                                                        <span id="fileName">
                                                            <c:choose>
                                                                <c:when test="${not empty fname}">Tệp đã tải lên: ${fname}</c:when>
                                                                <c:otherwise>Chưa chọn tệp</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <c:if test="${not empty awWork && not empty awWork.fileUrl}">
                                                        <div class="mt-2">
                                                            Tệp hiện tại:
                                                            <a href="${pageContext.request.contextPath}/${awWork.fileUrl}"
                                                               target="_blank" class="link-primary">Xem / tải xuống</a>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:if>

                                            <!-- Nút -->
                                            <c:choose>
                                                <c:when test="${awStatus == 'draft' || awStatus == 'returned'}">
                                                    <div class="d-flex gap-2 mt-3 justify-content-between">

                                                        <div>
                                                            <button type="submit" name="submitType" value="submit"
                                                                    class="btn ${isCooldown ? 'btn-secondary' : 'btn-primary'}"
                                                                    ${(!canSubmit || isCooldown) ? 'disabled' : ''}>
                                                                Nộp cho giáo viên
                                                            </button>

                                                            <c:if test="${assignment.aiGradeAllowed}">
                                                                <button type="submit"
                                                                        name="submitType" value="aiGrade"
                                                                        class ="btn btn-warning"
                                                                        ${(!canSubmit || isCooldown) ? 'disabled' : ''}
                                                                        >
                                                                    <i class="bi bi-stars me-1"></i> Chấm tự động
                                                                </button>
                                                            </c:if>
                                                        </div>

                                                        <button type="submit" name="submitType" value="draft"
                                                                class="btn ${canEdit ? 'btn-outline-secondary' : 'btn-outline-secondary disabled'}"
                                                                ${!canEdit ? 'disabled' : ''}>
                                                            Lưu bài
                                                        </button>
                                                    </div>
                                                </c:when>

                                                <c:when test="${awStatus == 'submitted'}">
                                                    <div class="d-flex mt-3">
                                                        <button type="button" class="btn btn-secondary" disabled>
                                                            <i class="bi bi-hourglass-split me-1"></i> Bài của bạn đang được chấm...
                                                        </button>
                                                    </div>
                                                </c:when>

                                                <c:when test="${awStatus == 'passed'}">
                                                </c:when>


                                                <c:otherwise>
                                                    <div class="d-flex gap-2 mt-3 justify-content-between">

                                                        <div>
                                                            <button type="submit" name="submitType" value="submit"
                                                                    class="btn btn-primary" ${!canSubmit ? 'disabled' : ''}>
                                                                Nộp cho giáo viên
                                                            </button>

                                                            <c:if test="${assignment.aiGradeAllowed}">
                                                                <button type="submit"
                                                                        name="submitType" value="aiGrade"
                                                                        class ="btn btn-warning"
                                                                        ${(!canSubmit || isCooldown) ? 'disabled' : ''}
                                                                        >
                                                                    <i class="bi bi-stars me-1"></i> Chấm tự động
                                                                </button>
                                                            </c:if>
                                                        </div>

                                                        <button type="submit" name="submitType" value="draft"
                                                                class="btn btn-outline-secondary" ${!canEdit ? 'disabled' : ''} formnovalidate>
                                                            Lưu bài
                                                        </button>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <!--c:otherwise none or null chưa có draft-->

                                            <div class="text-danger small mt-1">${requestScope.errorMessage}</div>

                                            <div class="form-text mt-2 ">
                                                Trạng thái: <strong>
                                                    <c:choose>
                                                        <c:when test="${awStatus == 'none'}">Chưa có bài làm</c:when>
                                                        <c:when test="${awStatus == 'draft'}">Đã lưu nháp</c:when>
                                                        <c:when test="${awStatus == 'submitted'}">Đang chấm</c:when>
                                                        <c:when test="${awStatus == 'returned'}">Trả về - cần chỉnh sửa</c:when>
                                                        <c:when test="${awStatus == 'passed'}">Đã đạt yêu cầu</c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                                <c:if test="${isCooldown}">
                                                    <div class="alert alert-warning my-2">
                                                        <i class="bi bi-hourglass-split me-2"></i>
                                                        Bài làm chưa đạt. Vui lòng chỉnh sửa và đợi đến <strong> ${nextRetryAt} </strong>để nộp lại.
                                                    </div>
                                                </c:if> 
                                            </div>
                                        </form>
                                    </div>
                                    <!--end card-->
                                </div>

                                <!--kết quả pass or return-->
                                <div class="mt-3">
                                    <c:if test="${showResult}">
                                        <div class="card mb-4 rounded-4 shadow-sm ${awStatus == 'passed' ? 'border-success' : 'border-danger'}" style="border-width: 3px">
                                            <div class="card-body rounded-4">
                                                <h6 class="fw-bold mb-2">Kết quả đánh giá</h6>
                                                <div class="mb-1">
                                                    Điểm: <strong>
                                                        <c:choose>
                                                            <c:when test="${not empty awWork.score}">${awWork.score}%</c:when>
                                                            <c:otherwise>--</c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </div>
                                                <div class="mb-0">
                                                    Phản hồi:
                                                    <div class="border rounded p-2 bg-light mt-1">
                                                        <c:out value="${empty awWork.feedbackText ? 'Chưa có phản hồi' : awWork.feedbackText}"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <hr>
                <div>
                    <div class="text-end">
                        <!--Nút mở panel (góc phải-dưới)--> 
                        <button
                            class="btn btn-primary rounded-circle d-inline-flex align-items-center justify-content-center
                            position-fixed bottom-0 end-0 m-3 shadow"
                            style="width:48px;height:48px;z-index:1080"
                            data-bs-toggle="offcanvas" data-bs-target="#dictPanel" aria-controls="dictPanel" title="Dictionary">
                            <i class="bi bi-search text-white"></i>
                        </button>

                        <!--Panel bên phải--> 
                        <div class="offcanvas offcanvas-end" tabindex="-1" id="dictPanel"
                             aria-labelledby="dictPanelLabel" style="--bs-offcanvas-width:420px">
                            <div class="offcanvas-header">
                                <h5 class="offcanvas-title" id="dictPanelLabel">Từ điển Tiếng Anh</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                            </div>

                            <div class="offcanvas-body">
                                <form id="search-box" class="input-group mb-3">
                                    <input id="search-input" class="form-control" placeholder="Nhập từ vựng cần tra">
                                    <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                                </form>

                                <p class="errTxt text-danger fw-semibold d-none"></p>

                                <div class="word-details card shadow-sm d-none">
                                    <div class="card-body text-start">
                                        <div class="d-flex gap-2 justify-content-between flex-wrap">
                                            <div>
                                                <h2 id="word-txt" class="h2 mb-0"></h2>
                                                <p class="mb-0 text-secondary">
                                                    <span id="type-txt"></span>
                                                    <span id="phonetic-txt" class="ms-1"></span>
                                                </p>
                                            </div>
                                            <button id="sound-btn" type="button"
                                                    class="btn btn-outline-success btn-sm rounded-circle d-inline-flex align-items-center justify-content-center"
                                                    style="width:38px;height:38px" title="Play">
                                                <i class="bi bi-volume-up"></i>
                                            </button>
                                        </div>

                                        <p id="definition-txt"class="mt-3 mb-2">definition</p>

                                        <div id="example-elem"  class="mt-2 ps-3 border-start border-3 border-primary d-none">
                                            <h6 class="mb-1">Examples</h6><p class="text-secondary mb-0"></p>
                                        </div>
                                        <div id="synonyms-elem" class="mt-2 ps-3 border-start border-3 border-primary d-none">
                                            <h6 class="mb-1">Synonyms</h6><p class="text-secondary mb-0"></p>
                                        </div>
                                        <div id="antonyms-elem" class="mt-2 ps-3 border-start border-3 border-primary d-none">
                                            <h6 class="mb-1">Antonyms</h6><p class="text-secondary mb-0"></p>
                                        </div>

                                        <form id="save-word-form" method="post" action="${pageContext.request.contextPath}/studentVocab" class="mt-4">
                                            <input type="hidden" name="word" id="input-word">
                                            <input type="hidden" name="phonetic" id="input-phonetic">
                                            <input type="hidden" name="audioUrl" id="input-audio-url">
                                            <input type="hidden" name="partOfSpeech" id="input-part-of-speech">
                                            <input type="hidden" name="definition" id="input-definition">
                                            <input type="hidden" name="example" id="input-example">
                                            <input type="hidden" name="synonyms" id="input-synonyms">
                                            <input type="hidden" name="antonyms" id="input-antonyms">
                                            <button type="submit" class="btn btn-success">
                                                <i class="bi bi-bookmark-check"></i> Lưu từ vựng
                                            </button>
                                        </form>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>


        </div>

    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- TinyMCE CDN -->
    <script src="https://cdn.tiny.cloud/1/esuprsg124x1emavjxk5j55wk30o7g9i1obl1k8j5gt99d0y/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    <!--Youtube API-->
    <script src="https://www.youtube.com/iframe_api"></script>

    <script src="${pageContext.request.contextPath}/js/dictionary.js"></script>

    <script>
//                                                                            tinymce.init({
//                                                                                selector: '#textAnswer',
//                                                                                plugins: 'advlist autolink lists link image charmap print preview anchor',
//                                                                                toolbar: 'undo redo | bold italic underline | link image | numlist bullist | alignleft aligncenter alignright',
//                                                                                menubar: false,
//                                                                                statusbar: false,
//                                                                                branding: false,
//                                                                                width: '100%'
//                                                                            });


                                                                            tinymce.init({
                                                                                selector: '#userReply',
                                                                                plugins: 'advlist autolink lists link image charmap print preview anchor',
                                                                                toolbar: 'undo redo | bold italic underline | link image | numlist bullist | alignleft aligncenter alignright',
                                                                                menubar: false,
                                                                                statusbar: false,
                                                                                branding: false,
                                                                                width: '100%'
                                                                            });



                                                                            function replyForm(formId) {
                                                                                event.preventDefault(); // Ngừng hành động mặc định của form (reload trang)
                                                                                var form = document.getElementById(formId);
                                                                                if (form.style.display === "none" || form.style.display === "") {

                                                                                    form.style.display = "block";

                                                                                    var editorId = formId.replace('replyForm', 'userReply');
                                                                                    tinymce.remove('#' + editorId);

                                                                                    tinymce.init({
                                                                                        selector: '#' + editorId,
                                                                                        plugins: 'advlist autolink lists link image charmap print preview anchor',
                                                                                        toolbar: 'undo redo | bold italic underline | link image | numlist bullist | alignleft aligncenter alignright',
                                                                                        menubar: false,
                                                                                        statusbar: false,
                                                                                        branding: false,
                                                                                        width: '100%'
                                                                                    })
                                                                                } else {
                                                                                    form.style.display = "none";
                                                                                }
                                                                            }

                                                                            function editPostContent(postId) {
                                                                                var contentElement = document.getElementById('postContent' + postId); // Lấy nội dung bài đăng
                                                                                var content = contentElement.innerText;

                                                                                var form = document.getElementById('editForm' + postId);
                                                                                if (form.style.display === "none" || form.style.display === "") {
                                                                                    form.style.display = "block";

                                                                                    var editorId = 'userReply' + postId;
                                                                                    tinymce.remove('#' + editorId);
                                                                                    tinymce.init({
                                                                                        selector: '#' + editorId,
                                                                                        plugins: 'advlist autolink lists link image charmap print preview anchor',
                                                                                        toolbar: 'undo redo | bold italic underline | link image | numlist bullist | alignleft aligncenter alignright',
                                                                                        menubar: false,
                                                                                        statusbar: false,
                                                                                        branding: false,
                                                                                        width: '100%',
                                                                                        setup: function (editor) {
                                                                                            editor.on('init', function () {
                                                                                                editor.setContent(content);
                                                                                            });
                                                                                        }
                                                                                    })
                                                                                } else {
                                                                                    form.style.display = "none";
                                                                                }
                                                                            }

                                                                            function editCommentContent(commentId) {
                                                                                var contentElement = document.getElementById('commentContent' + commentId); // Lấy nội dung comment
                                                                                var content = contentElement.innerText;

                                                                                var form = document.getElementById('editCommentForm' + commentId);
                                                                                if (form.style.display === "none" || form.style.display === "") {
                                                                                    form.style.display = "block";

                                                                                    var editorId = 'commentReply' + commentId;
                                                                                    tinymce.remove('#' + editorId);
                                                                                    tinymce.init({
                                                                                        selector: '#' + editorId,
                                                                                        plugins: 'advlist autolink lists link image charmap print preview anchor',
                                                                                        toolbar: 'undo redo | bold italic underline | link image | numlist bullist | alignleft aligncenter alignright',
                                                                                        menubar: false,
                                                                                        statusbar: false,
                                                                                        branding: false,
                                                                                        width: '100%',
                                                                                        setup: function (editor) {
                                                                                            editor.on('init', function () {
                                                                                                editor.setContent(content);
                                                                                            });
                                                                                        }
                                                                                    })
                                                                                } else {
                                                                                    form.style.display = "none";
                                                                                }
                                                                            }

                                                                            function editCommentContent(commentId) {
                                                                                var contentElement = document.getElementById('commentContent' + commentId); // Lấy nội dung comment
                                                                                var content = contentElement.innerText;

                                                                                var form = document.getElementById('editCommentForm' + commentId);
                                                                                if (form.style.display === "none" || form.style.display === "") {
                                                                                    form.style.display = "block";

                                                                                    var editorId = 'commentReply' + commentId;
                                                                                    tinymce.remove('#' + editorId);
                                                                                    tinymce.init({
                                                                                        selector: '#' + editorId,
                                                                                        plugins: 'advlist autolink lists link image charmap print preview anchor',
                                                                                        toolbar: 'undo redo | bold italic underline | link image | numlist bullist | alignleft aligncenter alignright',
                                                                                        menubar: false,
                                                                                        statusbar: false,
                                                                                        branding: false,
                                                                                        width: '100%',
                                                                                        setup: function (editor) {
                                                                                            editor.on('init', function () {
                                                                                                editor.setContent(content);
                                                                                            });
                                                                                        }
                                                                                    })
                                                                                } else {
                                                                                    form.style.display = "none";
                                                                                }
                                                                            }

                                                                            //for video youtube api
                                                                            let ytPlayer;

                                                                            // phải là global để YouTube API gọi được
                                                                            window.onYouTubeIframeAPIReady = function () {
                                                                                ytPlayer = new YT.Player('yt-player', {
                                                                                    events: {
                                                                                        'onStateChange': window.onPlayerStateChange
                                                                                    }
                                                                                });
                                                                            };

                                                                            window.onPlayerStateChange = function (e) {
                                                                                if (e.data === YT.PlayerState.ENDED) {
                                                                                    window.markVideoWatched().finally(() => location.reload());
                                                                                }
                                                                            };

                                                                            // cũng phải global
                                                                            window.markVideoWatched = function () {
                                                                                const form = new FormData();
                                                                                form.append('courseId', '${cp.course.courseId}');
                                                                                form.append('itemId', '${activeItemId}');
                                                                                form.append('contentType', 'markVideoWatched');

                                                                                return fetch('${pageContext.request.contextPath}/moduleItemProgress', {
                                                                                    method: 'POST',
                                                                                    body: form,
                                                                                    credentials: 'include'
                                                                                });
                                                                            };

                                                                            //Save vocab
                                                                            const formEl = document.getElementById("save-word-form");
                                                                            formEl.addEventListener('submit', async (e) => {
                                                                                e.preventDefault();
                                                                                const fd = new FormData(formEl);

                                                                                try {
                                                                                    const res = await fetch(formEl.action, {
                                                                                        method: 'POST',
                                                                                        body: fd,
                                                                                        credentials: 'include'
                                                                                    });

                                                                                    let data = {};
                                                                                    try {
                                                                                        data = await res.json();
                                                                                    } catch (_) {
                                                                                    }

                                                                                    if (!res.ok || data.success === false) {
                                                                                        alert('Từ vựng đã được thêm trước đó');
                                                                                        return;
                                                                                    }
                                                                                    alert('Đã lưu từ vựng!');
                                                                                } catch (err) {
                                                                                    console.error(err);
                                                                                    alert('Có lỗi mạng khi lưu.');
                                                                                }
                                                                            });

    </script>
</html>
