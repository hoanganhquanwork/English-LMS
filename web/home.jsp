<%-- 
    Document   : home
    Created on : Sep 21, 2025, 10:57:57 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello ${sessionScope.user.username}</h1>
         <a href="instructorDashboard" title="Admin Dashboard">Click here</a>
    </body>
</html>
