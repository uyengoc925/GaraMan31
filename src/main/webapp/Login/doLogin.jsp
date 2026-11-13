<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 13/11/2026
  Time: 11:25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<% String username = (String) request.getParameter("username");
String password = (String) request.getParameter("password");
Employee2 employee2 = new Employee2();
employee2.setUsername(username);
employee2.setPassword(password);
Employee2DAO dao = new Employee2DAO();
boolean isValid = dao.CheckLogin(employee2);
if (isValid && (employee2.getPosition().equalsIgnoreCase("Manager"))) {
    // Lưu thông tin người dùng vào session
    request.getSession().setAttribute("username", username);
    // Chuyển hướng đến trang chính của ứng dụng
    response.sendRedirect("Manager/ViewHome.jsp");
} else {
    // Nếu đăng nhập thất bại, chuyển hướng trở lại trang đăng nhập với thông báo lỗi
    response.sendRedirect("login.jsp?err=fail");
}
%>

