<%-- 
    Document   : my-vocabulary
    Created on : Oct 25, 2025, 5:18:08 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Vocabulary</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background: #f8f9fa;
            }
            .table-vocab {
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,.05);
            }
            .truncate {
                max-width: 220px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .cell-wrap {
                white-space: normal;
                word-break: break-word;
            }
            
            .prewrap {
                white-space: pre-wrap; 
                word-break: break-word;
            }

            .word-col {
                font-weight: 600;
                color: #0d6efd;
            }
            .badge-pos {
                font-size: 0.75rem;
                text-transform: capitalize;
            }
            .btn-sound {
                border: none;
                background: #e9f3ff;
                color: #0d6efd;
                border-radius: 50%;
                width: 34px;
                height: 34px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all .2s ease;
            }
            .btn-sound:hover {
                background: #d0e4ff;
            }
            .pagination-container a {
                margin-left: 2px;
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header>
            <jsp:include page="../header.jsp"/>
        </header>

        <div class="container flex-grow-1">
            <div class="d-flex justify-content-between align-items-center mb-4 mt-4">
                <h3 class="fw-bold mb-0 ">📘 Từ điển của tôi</h3>
            </div>

            <!-- Search + Sort -->
            <form class="row g-2 mb-4" method="get" action="${pageContext.request.contextPath}/studentVocab">
                <div class="col-md-5">
                    <input type="text" name="keyword" class="form-control"
                           placeholder="🔍 Nhập từ vựng cần tìm" value="${keyword}">
                </div>
                <div class="col-md-5">
                    <select name="sortKey" class="form-select" onchange="this.form.submit()">
                        <option value="created_desc" ${sortKey=="created_desc"?"selected":""}>Mới nhất</option>
                        <option value="created_asc"  ${sortKey=="created_asc" ?"selected":""}>Cũ nhất</option>
                        <option value="word_asc"     ${sortKey=="word_asc"   ?"selected":""}>A → Z</option>
                        <option value="word_desc"    ${sortKey=="word_desc"  ?"selected":""}>Z → A</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Tìm kiếm</button>
                </div>
            </form>

            <!-- Table -->
            <div class="table-responsive table-vocab">
                <table class="table align-middle mb-0 table-bordered">
                    <thead class="table-primary">
                        <tr>
                            <th>Từ vựng</th>
                            <th>Ngữ âm</th>
                            <th>Từ loại</th>
                            <th>Định nghĩa</th>
                            <th>Ví dụ</th>
                            <th>Từ đồng nghĩa</th>
                            <th>Từ trái nghĩa</th>
                            <th class="text-center">Phát âm</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr><td colspan="8" class="text-center text-muted py-4">Không có từ vựng nào được lưu trữ</td></tr>
                        </c:if>

                        <c:forEach var="v" items="${list}">
                            <tr>
                                <td class="word-col">${v.word}</td>
                                <td>${v.phonetic}</td>
                                <td>
                                    <c:if test="${not empty v.partOfSpeech}">
                                        <span class="badge bg-info text-dark badge-pos">${v.partOfSpeech}</span>
                                    </c:if>
                                    <c:if test="${empty v.partOfSpeech}">—</c:if>
                                    </td>
                                    <td class="cell-wrap prewrap" title="${v.definition}">${v.definition}</td>
                                <td class="cell-wrap prewrap" title="${v.example}">${v.example}</td>
                                <td class="truncate" title="${v.synonyms}">${v.synonyms}</td>
                                <td class="truncate" title="${v.antonyms}">${v.antonyms}</td>
                                <td class="text-center">
                                    <c:if test="${not empty v.audioUrl}">
                                        <button type="button" class="btn-sound" onclick="new Audio('${v.audioUrl}').play()" title="Play sound">
                                            <i class="bi bi-volume-up"></i>
                                        </button>
                                    </c:if>
                                    <c:if test="${empty v.audioUrl}">—</c:if>
                                    </td>
                                </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="text-end mt-4">
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <c:if test="${page > 1}">
                            <a href="?keyword=${keyword}&sortKey=${sortKey}&page=${page-1}"
                               class="btn btn-outline-secondary btn-sm">«</a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?keyword=${keyword}&sortKey=${sortKey}&page=${i}"
                               class="btn btn-sm ${i == page ? 'btn-primary' : 'btn-outline-secondary'}">${i}</a>
                        </c:forEach>

                        <c:if test="${page < totalPages}">
                            <a href="?keyword=${keyword}&sortKey=${sortKey}&page=${page+1}"
                               class="btn btn-outline-secondary btn-sm">»</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>

    </body>

</html>
