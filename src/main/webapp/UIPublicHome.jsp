<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GaraMan - Trang Chủ Công Cộng</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            text-align: center;
            background: #ffffff;
            padding: 50px 80px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 32px;
        }
        .btn-booking {
            display: inline-block;
            padding: 14px 32px;
            background-color: #007bff;
            color: #ffffff;
            font-size: 18px;
            font-weight: 600;
            text-decoration: none;
            border-radius: 8px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .btn-booking:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Trang chủ GaraMan</h1>
    <a href="UIBookAppointment.jsp" class="btn-booking">Đặt lịch hẹn</a>
</div>
</body>
</html>