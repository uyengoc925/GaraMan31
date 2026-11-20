<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 13/11/2026
  Time: 10:36 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Trang chủ - GaraMan</title>
</head>
<body>
    <div>
        <h1>Trang chủ GaraMan</h1>
        <p>Chào mừng bạn đến với hệ thống quản lý GaraMan!</p>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/Login/login.jsp">Trang Quản lý</a>
    </div>
    <div style="margin-top: 10px;">
        <a href="<%=request.getContextPath()%>/Customer/ViewPublicHome2.jsp">Trang Khách hàng</a>
    </div>
</body>
</html>
