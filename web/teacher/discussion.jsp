<%-- 
    Document   : discussion
    Created on : Oct 10, 2025, 9:26:03 AM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
       <h2>${discussion.title}</h2>
    <div class="mb-4 border p-3 bg-light">
        <!-- hiển thị nội dung mô tả (TinyMCE có thể chứa HTML) -->
        <div>${discussion.description}</div>
    </div>
    </body>
</html>
