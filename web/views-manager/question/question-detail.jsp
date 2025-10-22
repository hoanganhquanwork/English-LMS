<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div id="questionDetailModal" class="modal active">
    <div class="modal-content question-detail-modal">

        <button class="close-btn" onclick="closeDetail()">
            <i class="fas fa-times"></i>
        </button>

        <div class="modal-header">
            <h3><i class="fa fa-question-circle"></i> Chi tiết câu hỏi #${q.questionId}</h3>
            <span class="status-badge ${q.status}">${q.status}</span>
        </div>

        <div class="modal-body">
            <div class="q-section">
                <h4 class="q-content">${q.content}</h4>
            </div>

            <c:if test="${not empty q.mediaUrl}">
                <div class="q-media">
                    <c:choose>

                        <c:when test="${fn:contains(q.mediaUrl, 'youtube.com/embed')}">
                            <div class="youtube-container">
                                <iframe class="youtube-embed"
                                        src="${q.mediaUrl}"
                                        frameborder="0"
                                        allowfullscreen
                                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture">
                                </iframe>
                            </div>
                        </c:when>

                        <c:when test="${fn:endsWith(q.mediaUrl, '.jpg') 
                                        or fn:endsWith(q.mediaUrl, '.jpeg') 
                                        or fn:endsWith(q.mediaUrl, '.png') 
                                        or fn:endsWith(q.mediaUrl, '.gif')}">
                                <img src="${q.mediaUrl}" alt="Hình minh họa" class="media-img">
                        </c:when>
                        <c:when test="${fn:endsWith(q.mediaUrl, '.mp4') 
                                        or fn:endsWith(q.mediaUrl, '.webm') 
                                        or fn:endsWith(q.mediaUrl, '.mov')}">
                                <video controls class="media-video">
                                    <source src="${q.mediaUrl}" type="video/mp4">
                                    Trình duyệt của bạn không hỗ trợ video.
                                </video>
                        </c:when>

                        <c:otherwise>
                            <c:set var="parts" value="${fn:split(q.mediaUrl, '/')}"/>
                            <p class="file-link">
                                <i class="fa fa-paperclip"></i>
                                <a href="${q.mediaUrl}" target="_blank">
                                    ${parts[fn:length(parts) - 1]}
                                </a>
                            </p>
                        </c:otherwise>

                    </c:choose>
                </div>
            </c:if>

            <div class="q-meta">
                <strong>Loại câu hỏi:</strong>
                <c:choose>
                    <c:when test="${q.type eq 'mcq_single'}">Trắc nghiệm</c:when>
                    <c:when test="${q.type eq 'text'}">Tự luận</c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </div>
            <c:if test="${q.type eq 'mcq_single' and not empty q.options}">
                <div class="q-options">
                    <h5>Danh sách lựa chọn:</h5>
                    <ul class="option-list">
                        <c:forEach var="opt" items="${q.options}">
                            <li class="${opt.correct ? 'correct' : ''}">
                                <i class="fa ${opt.correct ? 'fa-check-circle text-green' : 'fa-circle'}"></i>
                                ${opt.content}
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <c:if test="${q.type eq 'text' and not empty q.answers}">
                <div class="q-answers">
                    <h5>Đáp án đúng:</h5>
                    <ul class="answer-list">
                        <c:forEach var="a" items="${q.answers}">
                            <li><i class="fa fa-check text-green"></i> ${a.answerText}</li>
                            </c:forEach>
                    </ul>
                </div>
            </c:if>

            <c:if test="${not empty q.explanation}">
                <div class="q-explanation">
                    <strong>Giải thích:</strong>
                    <p>${q.explanation}</p>
                </div>
            </c:if>

            <c:if test="${not empty q.reviewComment}">
                <div class="q-review-comment">
                    <strong>Lý do từ chối:</strong>
                    <p>${q.reviewComment}</p>
                </div>
            </c:if>


            <div class="q-instructor">
                <strong>Người tạo:</strong> ${q.instructorName}
            </div>
        </div>

        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeDetail()">
                <i class="fa fa-arrow-left"></i> Quay lại
            </button>
        </div>
    </div>
</div>