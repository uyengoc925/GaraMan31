<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - GaraMan</title>
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
            align-items:center;
            min-height: 100vh;
        }
        .container{
            width: 420px;
            border: 2px solid #000000;
            padding: 35px 30px 45px 30px;
            text-align: center;
            background-color: #ffffff;
        }
        .container h1{
            color:#163b69;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .btn-booking{
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
        .btn-booking:hover {
            background-color: #0e3682;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Trang chủ</h1>
    <a href="ViewBookAppointment2.jsp" class="btn-booking">Đặt lịch hẹn</a>
</div>
</body>
</html>
