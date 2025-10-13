<%-- 
    Document   : quiz-page
    Created on : Oct 13, 2025, 1:11:16 AM
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${quiz.title}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .question-card{
                border:0;
                background:#f8fbff;
                border-radius:12px
            }
            .btn-outline-primary:hover {
                color: #0d6efd;
                background-color: #e9ecef;
                border-color: #adb5bd;
            }


        </style>
    </head>
    <body class="bg-white">

        <!-- Header: nút quay lại main-layout -->
        <header class="border-bottom bg-white">
            <div class="container py-3 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <a class="btn btn-outline-primary"
                       href="${pageContext.request.contextPath}/coursePage?courseId=${courseId}&itemId=${itemId}">
                        <i class="bi bi-arrow-left"></i>
                    </a>
                    <h5 class="mb-0">${quiz.title}</h5>
                </div>
                <div class="text-muted small">Lần làm quiz thứ #${attempt.attemptNo}</div>
            </div>
        </header>

        <main class="container my-4">

            <!-- banner after submit -->
            <c:if test="${attempt.status == 'submitted'}">
                <c:set var="pass" value="${quiz.passingScorePct != null && attempt.scorePct >= quiz.passingScorePct}" />
                <div class="alert ${pass ? 'alert-success' : 'alert-danger'} d-flex justify-content-between">
                    <div>
                        <strong>Điểm của bạn: ${attempt.scorePct}%</strong>
                        <c:if test="${quiz.passingScorePct != null}">
                            <span class="ms-2">Để pass quizz bạn cần đạt được tối thiểu ${quiz.passingScorePct}%.</span>
                        </c:if>
                    </div>
                    <c:choose>
                        <c:when test="${pass}">
                            <a class="btn btn-primary"
                               href="${pageContext.request.contextPath}/coursePage?courseId=${courseId}&itemId=${itemId+1}">
                                Bài học tiếp theo →
                            </a>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/startQuiz" method="get" class="d-inline">
                                <input type="hidden" name="courseId" value="${courseId}">
                                <input type="hidden" name="itemId" value="${itemId}">
                                <button class="btn btn-outline-primary">
                                    <i class="bi bi-arrow-clockwise me-1"></i> Làm lại
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- status = draft -->
            <c:if test="${attempt.status == 'draft'}">
                <form method="post" action="${pageContext.request.contextPath}/doQuiz">
                    <input type="hidden" name="courseId"  value="${courseId}">
                    <input type="hidden" name="itemId"    value="${itemId}">
                    <input type="hidden" name="attemptId" value="${attempt.attemptId}">

                    <c:forEach var="aq" items="${attempt.questions}" varStatus="st">
                        <div class="card question-card shadow-sm mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div class="fw-semibold">${st.count}. ${aq.question.content}</div>
                                    <span class="badge text-bg-light">${100/quiz.pickCount} point</span>
                                </div>

                                <!-- MCQ single -->
                                <c:if test="${aq.question.type == 'mcq_single'}">
                                    <!-- find option in draft -->
                                    <c:set var="chosen" value="${null}" />
                                    <c:forEach var="ans" items="${attempt.answers}">
                                        <c:if test="${ans.questionId == aq.question.questionId}">
                                            <c:set var="chosen" value="${ans.chosenOptionId}" />
                                        </c:if>
                                    </c:forEach>

                                    <div class="mt-3">
                                        <c:forEach var="opt" items="${aq.question.options}" varStatus="optSt">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="radio"
                                                       id="q${aq.question.questionId}o${opt.optionId}"
                                                       name="answers[${aq.question.questionId}]"
                                                       value="${opt.optionId}"
                                                       <c:if test="${chosen == opt.optionId}">checked</c:if>
                                                       <c:if test="${empty chosen && optSt.first}">required</c:if> />
                                                <label class="form-check-label" for="q${aq.question.questionId}o${opt.optionId}">
                                                    ${opt.content}
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <!-- Text -->
                                <c:if test="${aq.question.type == 'text'}">
                                    <c:set var="draftText" value=""/>
                                    <c:forEach var="ans" items="${attempt.answers}">
                                        <c:if test="${ans.questionId == aq.question.questionId && not empty ans.answerText}">
                                            <c:set var="draftText" value="${ans.answerText}" />
                                        </c:if>
                                    </c:forEach>

                                    <input type="text"
                                           class="form-control mt-3"
                                           name="answersText[${aq.question.questionId}]"
                                           value="${draftText}"
                                           placeholder="Nhập câu trả lời..." />
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="d-flex justify-content-start gap-2 border-top pt-3">
                        <button type="submit" name="action" value="submit" class="btn btn-primary">Submit</button>
                        <button type="submit" name="action" value="save"   class="btn btn-outline-primary">Save draft</button>
                    </div>
                </form>
            </c:if>

            <!-- SAU KHI SUBMIT: review từng câu (đánh dấu đúng/sai + explanation) -->
            <c:if test="${attempt.status == 'submitted'}">
                <c:forEach var="aq" items="${attempt.questions}" varStatus="st">
                    <c:set var="chosen" value="${null}" />
                    <c:forEach var="ans" items="${attempt.answers}">
                        <c:if test="${ans.questionId == aq.question.questionId}">
                            <c:set var="chosen" value="${ans.optionId}" />
                        </c:if>
                    </c:forEach>

                    <div class="mt-4">
                        <div class="fw-semibold">${st.count}. ${aq.question.content}</div>
                        <!--<div class="small text-muted">${100/quiz.pickCount} point</div>-->

                        <c:if test="${aq.question.type == 'mcq_single'}">
                            <div class="mt-2">
                                <c:forEach var="opt" items="${aq.question.options}">
                                    <c:set var="isChosen" value="${chosen == opt.optionId}" />
                                    <div class="d-flex align-items-center mb-1">
                                        <i class="bi ${isChosen
                                                       ? (opt.isCorrect ? 'bi-check-circle-fill text-success'
                                                       : 'bi-x-circle-fill text-danger')
                                                       : 'bi-circle text-muted'} me-2"></i>
                                        <span class="${isChosen
                                                       ? (opt.isCorrect ? 'text-success fw-semibold'
                                                       : 'text-danger fw-semibold')
                                                       : ''}">${opt.content}</span>
                                    </div>
                                </c:forEach>

                            </div>
                        </c:if>

                        <c:if test="${aq.question.type == 'text'}">
                            <c:set var="userAnswer" value="${null}" />
                            <c:forEach var="ans" items="${attempt.answers}">
                                <c:if test="${ans.questionId == aq.question.questionId}">
                                    <c:set var="userAnswer" value="${ans}" />
                                </c:if>
                            </c:forEach>

                            <c:set var="isCorrect" value="${userAnswer != null and userAnswer.isCorrect}" />
                            <c:set var="textVal"   value="${userAnswer != null ? userAnswer.answerText : ''}" />

                            <div class="mt-2">
                                <span class="${isCorrect ? 'text-success fw-semibold' : 'text-danger fw-semibold'}">
                                    <span class="fw-semibold">Your answer:</span>
                                    <c:out value="${empty textVal ? '(no answer)' : textVal}"/>
                                </span>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:if>

        </main>
    </body>
</html>

