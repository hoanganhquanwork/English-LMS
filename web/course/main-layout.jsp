<%-- 
    Document   : main-layout
    Created on : Oct 8, 2025, 12:00:26 AM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                max-width: 1120px;
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
                max-width: 1300px;
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
                position: fixed;
                bottom: 20px;
                right: 20px;
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
                                                <span class="ms-1 fw-bold text-dark">Module ${m.orderIndex}:</span>
                                                <span class="ms-1 fw-bold text-dark">${m.title}</span>
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
                <a href="${pageContext.request.contextPath}/coursePage?itemId=${activeItemId+1}&courseId=${cp.course.courseId}" 
                   class="btn btn-outline-primary go-to-next-item text-decoration-none">
                    Đi tới mục tiếp theo
                </a>

                <!--For lesson-->

                <c:if test="${requestScope.selectedItemType == 'lesson'}" >

                    <c:if test="${requestScope.selectedContentType == 'reading'}" >
                        <div class="reading-container">
                            <h1>${requestScope.lesson.title}</h1>
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

                    <c:if test="${requestScope.selectedContentType == 'video'}" >
                        <div class="ratio ratio-21x9 video-frame shadow-sm">
                            <iframe 
                                src="https://www.youtube.com/embed/${requestScope.lesson.videoUrl}"
                                title="${requestScope.lesson.title}"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                allowfullscreen
                                frameborder="0">
                            </iframe>
                        </div>
                        <h4 class="fw-bold mb-3">${cp.course.title}</h4>
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
                                <input type="hidden" name="status" value="${status}">
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

            </main>

            <!--<hr class="custom-hr">-->
        </div>

    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- TinyMCE CDN -->
    <script src="https://cdn.tiny.cloud/1/esuprsg124x1emavjxk5j55wk30o7g9i1obl1k8j5gt99d0y/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    <script>
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
    </script>
</html>
