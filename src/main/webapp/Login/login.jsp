<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 13/11/2026
  Time: 10:39 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống GaraMan</title>
    <style>
        *{
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
        }
        body{
            height: 100%;
            background-color: #ffffff;
            display: flex;
            justify-content: center;
            align-items:flex-start;
            min-height: 100vh;
        }
        .container{
            width: 420px;
            border: 2px solid #000000;
            padding: 35px 30px 45px 30px;
            text-align: center;
            background-color: #ffffff;
            margin-top: 100px;

        }
        .container h2{
            color:#163b69;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .container h4{
            color:#ef9a9a;
            font-size: 16px;
            margin-bottom: 30px;
        }
        table{
            width: 100%;
        }
        td{
            padding: 10px;
        }
        input[type="text"], input[type="password"]{
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"]{
            background-color: #082356;
            color: #ffffff;
            border: none;
            padding: 10px 28px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 4px;
        }
        input[type="submit"]:hover{
            background-color: #0e3682;
        }
    </style>
</head>
<body>
<div class="container">
    <h2> Đăng nhập</h2>
    <% if(request.getParameter("err") != null &&
            request.getParameter("err").equalsIgnoreCase("timeout")) {
    %> <h4> Hết phiên làm việc. Vui lòng đăng nhập lại!</h4>
    <% } else if(request.getParameter("err") !=null && request.getParameter("err").equalsIgnoreCase("fail")){ %>
    <h4 style="color: red;"> Sai tên đăng nhập/ mật khẩu!</h4>
    <% } %>

    <form name="dangnhap" action="doLogin.jsp" method="post">
        <table>
            <tr>
                <td>Tên đăng nhập:</td>
                <td><input type="text" name="username" id="username" ></td>
            </tr>
            <tr>
                <td>Mật khẩu:</td>
                <td><input type="password" name="password" id="password" ></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="Đăng nhập">
                </td>
            </tr>
        </table>
    </form>
</div>

</body>
</html>
