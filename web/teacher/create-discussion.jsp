<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo Thảo Luận Mới</title>
    <link href="../../css/bootstrap.min.css" rel="stylesheet">

    <!-- TinyMCE -->
    <script src="https://cdn.tiny.cloud/1/808iwiomkwovmb2cvokzivnjb0nka12kkujkdkuf8tpcoxtwBài này/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
    <script>
        tinymce.init({
            selector: '#description',
            height: 400,
            menubar: true,
            plugins: 'lists link image media table code preview',
            toolbar: 'undo redo | bold italic underline | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image media | code preview',
            branding: false,
            placeholder: 'Nhập nội dung hướng dẫn cho discussion...',
            content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }'
        });
    </script>
</head>

<body class="p-4">
<div class="container">
    <h2 class="mb-4">Tạo Thảo Luận Mới Trong Module</h2>

    <form action="createDiscussion" method="post">
        <input type="hidden" name="moduleId" value="${moduleId}">

        <div class="mb-3">
            <label for="title" class="form-label fw-bold">Tiêu đề</label>
            <input type="text" name="title" id="title" class="form-control"
                   placeholder="Ví dụ: Self-Reflection: Good and Bad UX" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label fw-bold">Nội dung mô tả</label>
            <textarea name="description" id="description"></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Tạo Thảo Luận</button>
        <a href="moduleDetail?moduleId=${moduleId}" class="btn btn-secondary">Hủy</a>
    </form>

    <c:if test="${not empty error}">
        <div class="alert alert-danger mt-3">${error}</div>
    </c:if>
</div>
</body>
</html>
