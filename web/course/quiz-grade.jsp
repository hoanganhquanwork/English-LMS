<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8">
    <title>Quiz (Graded)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
      .layout{ display:flex; gap:20px }
      .top-note{ font-size:.9rem; color:#6c757d; margin-bottom:12px }

      /* Sidebar trái: viền đủ 4 cạnh, nhạt */
      .sidebar{
        width:320px; background:#fff; padding:16px;
        border:1px solid #adb5bd;
      }
      .sec-title{ font-weight:600; margin-bottom:8px }
      .hard-hr{ border:0; border-top:1px solid #adb5bd; margin:12px 0 }

      /* Đồng hồ xanh lá */
      #timeLeft{ font-weight:700; color:#198754; font-size:1.25rem }

      /* Palette 5 ô/row */
      .palette{ display:grid; grid-template-columns:repeat(5,1fr); gap:6px }
      .square-btn{
        height:42px; padding:0; font-weight:600; border-radius:0;
        border:1px solid #0d6efd; color:#0d6efd; background:#fff;
      }
      .square-btn.answered{ background:#0d6efd; color:#fff }

      /* Nội dung câu hỏi bên phải */
      .question-card{
        background:#fff; border:1px solid #adb5bd; border-radius:0; padding:16px;
      }
      .q-title{ font-weight:700; text-transform:uppercase }
      .q-sub{ color:#6c757d }
      .divider{ border:0; border-top:1px solid #e9ecef; margin:12px 0 }

      .btn-primary,.btn-outline-secondary{ border-radius:0; font-weight:600 }
    </style>
  </head>
  <body>
    <div class="container-fluid py-3">
      <!-- Dải mô tả ngắn + tên quiz -->
      <div class="top-note">
        <span class="me-3">
          Quiz: <strong><c:out value="${empty quiz.title ? 'Không tiêu đề' : quiz.title}"/></strong>
        </span>
        <span class="me-3">
          Yêu cầu đạt:
          <strong>
            <c:choose>
              <c:when test="${not empty quiz.passingScorePct}">${quiz.passingScorePct}%</c:when>
              <c:otherwise>--</c:otherwise>
            </c:choose>
          </strong>
        </span>
        <span class="me-3">
          Số câu:
          <strong>
            <c:choose>
              <c:when test="${not empty quiz.pickCount}">${quiz.pickCount}</c:when>
              <c:otherwise>--</c:otherwise>
            </c:choose>
          </strong>
        </span>
        <span>
          Giới hạn:
          <strong>
            <c:choose>
              <c:when test="${not empty quiz.timeLimitMin}">${quiz.timeLimitMin} phút</c:when>
              <c:otherwise>Không giới hạn</c:otherwise>
            </c:choose>
          </strong>
        </span>
      </div>

      <!-- 1 FORM DUY NHẤT: save/submit phân biệt bằng field "action" -->
      <form id="quizForm" method="post" action="${pageContext.request.contextPath}/doQuiz">
        <input type="hidden" name="attemptId" value="${attempt.attemptId}">
        <input type="hidden" name="courseId"  value="${param.courseId}">
        <input type="hidden" name="itemId"    value="${param.itemId}">
        <input type="hidden" name="action"    id="actionField" value="save"><!-- mặc định là save -->

        <div class="layout">
          <!-- SIDEBAR TRÁI -->
          <aside class="sidebar">
            <div class="sec-title">Thời gian còn lại</div>
            <div id="timeLeft">--:--</div>

            <hr class="hard-hr">

            <div class="sec-title">Câu hỏi</div>
            <div class="palette" id="palette">
              <c:forEach var="qaq" items="${attempt.questions}" varStatus="s">
                <button type="button" class="square-btn" id="pal-${s.index}" disabled>
                  ${s.index + 1}
                </button>
              </c:forEach>
            </div>

            <hr class="hard-hr">

            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-primary"
                      onclick="document.getElementById('actionField').value='submit';"
                      <c:if test="${isSubmitted}">disabled</c:if>>
                <i class="bi bi-check2-circle me-1"></i> Nộp bài
              </button>

              <button type="submit" class="btn btn-outline-secondary"
                      onclick="document.getElementById('actionField').value='save';"
                      <c:if test="${isSubmitted}">disabled</c:if>>
                <i class="bi bi-save me-1"></i> Lưu bài làm
              </button>
            </div>
          </aside>

          <!-- MAIN PHẢI -->
          <main class="flex-grow-1">
            <div class="question-card" id="questionContainer">
              <c:forEach var="qaq" items="${attempt.questions}" varStatus="s">
                <c:set var="q" value="${qaq.question}" />
                <div class="q-block" id="q-${s.index}" style="display:none;">
                  <div class="q-title">
                    CÂU HỎI ${s.index + 1} <span class="q-sub">(<c:out value="${q.type}"/>)</span>
                  </div>

                  <hr class="divider">

                  <div><strong>Nội dung:</strong></div>
                  <div class="mt-1"><c:out value="${q.content}"/></div>

                  <hr class="divider">

                  <c:choose>
                    <c:when test="${q.type == 'mcq_single'}">
                      <c:forEach var="opt" items="${q.options}">
                        <div class="form-check mb-2">
                          <input class="form-check-input"
                                 type="radio"
                                 name="answers[${q.questionId}]"
                                 id="q${q.questionId}_opt${opt.optionId}"
                                 value="${opt.optionId}"
                                 <c:forEach var="a" items="${attempt.answers}">
                                   <c:if test="${a.questionId == q.questionId && a.chosenOptionId == opt.optionId}">
                                     checked
                                   </c:if>
                                 </c:forEach>
                                 <c:if test="${isSubmitted}">disabled</c:if> >
                          <label class="form-check-label" for="q${q.questionId}_opt${opt.optionId}">
                            <c:out value="${opt.content}"/>
                          </label>
                        </div>
                      </c:forEach>
                    </c:when>

                    <c:when test="${q.type == 'text'}">
                      <input type="text" class="form-control"
                             name="answersText[${q.questionId}]"
                             value="<c:forEach var='a' items='${attempt.answers}'><c:if test='${a.questionId == q.questionId}'>${a.answerText}</c:if></c:forEach>"
                             placeholder="Nhập câu trả lời..."
                             <c:if test="${isSubmitted}">readonly</c:if> />
                    </c:when>

                    <c:otherwise>
                      <div class="text-muted">Loại câu hỏi chưa hỗ trợ.</div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </c:forEach>
            </div>

            <div class="d-flex justify-content-between mt-2">
              <button type="button" class="btn btn-outline-primary btn-sm" id="btnPrev2">« Trước</button>
              <button type="button" class="btn btn-outline-primary btn-sm" id="btnNext2">Tiếp »</button>
            </div>
          </main>
        </div>
      </form>
    </div>

    <script>
      // ===== Chuyển câu hỏi =====
      var total = document.getElementsByClassName('q-block').length;
      var idx = 0;

      function showQuestion(i) {
        var blocks = document.getElementsByClassName('q-block');
        var k;
        for (k = 0; k < blocks.length; k++) {
          blocks[k].style.display = (k === i ? 'block' : 'none');
        }
        idx = i;
        updateNav();
        markAnsweredPalette();
      }

      function updateNav() {
        var prev2 = document.getElementById('btnPrev2');
        var next2 = document.getElementById('btnNext2');
        if (prev2) prev2.disabled = (idx === 0);
        if (next2) next2.disabled = (idx === total - 1);
      }

      function prevQ() { if (idx > 0) showQuestion(idx - 1); }
      function nextQ() { if (idx < total - 1) showQuestion(idx + 1); }

      // Tô xanh palette nếu đã trả lời
      function markAnsweredPalette() {
        var k;
        for (k = 0; k < total; k++) {
          var block = document.getElementById('q-' + k);
          var pal = document.getElementById('pal-' + k);
          if (!block || !pal) continue;

          var answered = false;

          // radio
          var radios = block.querySelectorAll('input[type=radio]');
          if (radios && radios.length > 0) {
            var r;
            for (r = 0; r < radios.length; r++) {
              if (radios[r].checked) { answered = true; break; }
            }
          }
          // text
          var txt = block.querySelector('input[type=text]');
          if (!answered && txt && txt.value.trim() !== '') {
            answered = true;
          }

          if (answered) pal.classList.add('answered');
          else pal.classList.remove('answered');
        }
      }

      // Gắn sự kiện basic
      (function(){
        var prev2 = document.getElementById('btnPrev2');
        var next2 = document.getElementById('btnNext2');
        if (prev2) prev2.onclick = function(){ prevQ(); };
        if (next2) next2.onclick = function(){ nextQ(); };

        document.addEventListener('change', function(){ markAnsweredPalette(); });

        if (total > 0) showQuestion(0); // hiển thị câu 1
      })();

      // ===== Đếm ngược + auto-submit khi hết giờ =====
      var remainMs = ${requestScope.remainTime == null ? 0 : requestScope.remainTime};
      var isSubmitted = ${requestScope.isSubmitted == true ? 'true' : 'false'};

      (function(){
        var el = document.getElementById('timeLeft');
        if (!el) return;

        function fmt(ms) {
          var t = Math.max(0, Math.floor(ms/1000));
          var m = Math.floor(t/60);
          var s = t % 60;
          var mm = (m < 10 ? '0'+m : m);
          var ss = (s < 10 ? '0'+s : s);
          return mm + 'm : ' + ss + 's';
        }

        function tick() {
          if (remainMs <= 0) {
            el.textContent = '00m : 00s';
            if (!isSubmitted) {
              // Đặt action=submit và submit form
              var act = document.getElementById('actionField');
              if (act) act.value = 'submit';
              var frm = document.getElementById('quizForm');
              if (frm) frm.submit();
            }
            return;
          }
          el.textContent = fmt(remainMs);
          remainMs -= 1000;
          setTimeout(tick, 1000);
        }

        if (remainMs > 0) tick(); else el.textContent = '--:--';
      })();

      // Phím ← → để chuyển câu
      document.addEventListener('keydown', function(e){
        if (e.keyCode === 37) prevQ();
        else if (e.keyCode === 39) nextQ();
      });
    </script>
  </body>
</html>
