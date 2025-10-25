<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Topic & Category Manager - LinguaTrack</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="<c:url value='/css/manager-cate-topic.css' />" />
    </head>

    <body>
        <jsp:include page="../includes-manager/sidebar-manager.jsp" />

        <main>
            <h2>Quản lý Danh mục & Chủ đề</h2>

            <c:if test="${not empty message}">
                <div class="alert success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert error">${error}</div>
            </c:if>

            <div class="tab-buttons">
                <button class="${type eq 'category' ? 'active' : ''}" onclick="switchTab('category')">Category</button>
                <button class="${type eq 'topic' ? 'active' : ''}" onclick="switchTab('topic')">Topic</button>
            </div>

            <c:if test="${type eq 'category'}">
                <div class="actions">
                    <input type="text" id="searchCategory" placeholder="Tìm theo tên Category...">
                    <button type="button" class="btn btn-add" onclick="openModal('category')">
                        <i class="fa fa-plus"></i> Thêm Category
                    </button>
                </div>

                <table>
                    <thead>
                        <tr><th>ID</th><th>Tên</th><th>Mô tả</th><th>Ảnh</th><th>Hành động</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td>${c.categoryId}</td>
                                <td>${c.name}</td>
                                <td>${c.description}</td>
                                <td>
                                    <c:if test="${not empty c.picture}">
                                        <img src="${c.picture}" width="60" height="60" style="object-fit:cover;border-radius:6px;">
                                    </c:if>
                                </td>
                                <td>
                                    <button class="btn btn-edit"
                                            onclick="openForm('category', ${c.categoryId}, '${fn:escapeXml(c.name)}', '${fn:escapeXml(c.description)}', '${c.picture}')">
                                        <i class="fa fa-pen"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${type eq 'topic'}">
                <div class="actions">
                    <input type="text" id="searchTopic" placeholder="Tìm theo tên Topic...">
                    <button type="button" class="btn btn-add" onclick="openModal('topic')">
                        <i class="fa fa-plus"></i> Thêm Topic
                    </button>
                </div>

                <table>
                    <thead>
                        <tr><th>ID</th><th>Tên</th><th>Mô tả</th><th>Hành động</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${topics}">
                            <tr>
                                <td>${t.topicId}</td>
                                <td>${t.name}</td>
                                <td>${t.description}</td>
                                <td>
                                    <button class="btn btn-edit"
                                            onclick="openForm('topic', ${t.topicId}, '${t.name}', '${t.description}', '')">
                                        <i class="fa fa-pen"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <div class="modal" id="modalForm">
                <div class="modal-content">
                    <h3 id="modalTitle"></h3>
                    <form id="modalEditForm" action="cate-topic" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="type" id="inputType" />
                        <input type="hidden" name="action" id="inputAction" value="" />
                        <input type="hidden" name="id" id="inputId" />
                        <input type="hidden" name="pictureOld" id="pictureOld" />

                        <input type="text" name="name" id="inputName" placeholder="Tên..." required />
                        <textarea name="description" id="inputDesc" placeholder="Mô tả..."></textarea>

                        <div id="uploadPic" style="display:none;">
                            <label for="inputFile">Ảnh minh họa (chỉ cho Category):</label>
                            <input type="file" name="pictureFile" id="inputFile" accept="image/*" onchange="previewImage(event)" />
                            <img id="previewImg" style="display:none;width:100%;margin-top:8px;border-radius:8px;" />
                        </div>

                        <div class="modal-buttons">
                            <button type="submit" class="btn btn-add">Lưu</button>
                            <button type="button" class="btn btn-delete" onclick="closeModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <script>
            function openModal(type) {
                document.getElementById("modalTitle").textContent = "Thêm " + type;
                document.getElementById("inputType").value = type;
                document.getElementById("inputAction").value = "add";
                document.getElementById("inputId").value = "";
                document.getElementById("inputName").value = "";
                document.getElementById("inputDesc").value = "";
                document.getElementById("pictureOld").value = "";
                document.getElementById("uploadPic").style.display = type === "category" ? "block" : "none";
                document.getElementById("previewImg").style.display = "none";
                document.getElementById("modalForm").classList.add("active");
            }

            function openForm(type, id, name, desc, pic) {
                document.getElementById("modalTitle").textContent = "Sửa " + type;
                document.getElementById("inputType").value = type;
                document.getElementById("inputId").value = id;
                document.getElementById("inputName").value = name;
                document.getElementById("inputDesc").value = desc;
                document.getElementById("pictureOld").value = pic || "";
                document.getElementById("uploadPic").style.display = type === "category" ? "block" : "none";
                document.getElementById("inputAction").value = "update";
                if (pic) {
                    document.getElementById("previewImg").src = pic;
                    document.getElementById("previewImg").style.display = "block";
                } else {
                    document.getElementById("previewImg").style.display = "none";
                }

                document.getElementById("modalForm").classList.add("active");
            }

            function closeModal() {
                document.getElementById("modalForm").classList.remove("active");
            }

            function previewImage(event) {
                const file = event.target.files[0];
                if (!file)
                    return;
                const reader = new FileReader();
                reader.onload = e => {
                    const img = document.getElementById("previewImg");
                    img.src = e.target.result;
                    img.style.display = "block";
                };
                reader.readAsDataURL(file);
            }

            function switchTab(tab) {
                window.location.href = "cate-topic?type=" + tab;
            }
        </script>
    </body>
</html>