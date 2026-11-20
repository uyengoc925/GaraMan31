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
    <style>
        *{
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
        }
        body{
            background-color: #ffffff;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 80px;
        }
        .container h1{
            color: #163b69;
            front-size: 28px;
            margin-bottom: 12px;
        }
        .container p{
            color: #444444;
            font-size: 16px;
            margin-bottom: 30px;
        }
        .menu{
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .btn-link{
            display: inline-block;
            background-color: #082356;
            color: #ffffff;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            padding: 10px 28px;
            border: 1px solid #000000;
            transition: background-color 0.2s;
        }
        .btn-link:hover{
            background-color: #0e3682;
        }

    </style>
</head>
<body>
<div class="container">
    <h1>Trang chủ GaraMan</h1>
    <p>Chào mừng bạn đến với hệ thống quản lý GaraMan!</p>

    <div class="menu">
        <a class = "btn-link" href="<%=request.getContextPath()%>/Login/login.jsp">Trang Quản lý</a>
        <a class = "btn-link" href="<%=request.getContextPath()%>/Customer/ViewPublicHome2.jsp">Trang Khách hàng</a>
    </div></div>
</body>

