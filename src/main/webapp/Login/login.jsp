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
</head>
<body>
    <h2> Đăng nhập</h2>
    <% if(request.getParameter("err") != null &&
        request.getParameter("err").equalsIgnoreCase("timeout")) {
    %> <h4> Hết phiên làm việc. Vui lòng đăng nhập lại!</h4>
    <% } else if(request.getParameter("err") !=null && request.getParameter("err").equalsIgnoreCase("fail")){ %>
    <h4 style="color: red;"> Sai tên đăng nhập/ mật khẩu!</h4> <%}
    %>%>

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
    </form>

</body>
</html>
