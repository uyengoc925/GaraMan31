<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xem Báo Cáo - GaraMan</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 80px; background-color: #f8f9fa; }
        h1 { color: #002B66; font-size: 32px; margin-bottom: 40px; }
        .btn-group { display: flex; flex-direction: column; align-items: center; gap: 15px; }
        .btn-primary {
            background-color: #002B66; color: white; border: none; padding: 12px 30px;
            font-size: 16px; font-weight: bold; width: 200px; text-decoration: none; border-radius: 4px;
        }
        .btn-secondary {
            background-color: #5B9BD5; color: white; border: none; padding: 12px 30px;
            font-size: 16px; font-weight: bold; width: 200px; text-decoration: none; border-radius: 4px;
        }
    </style>
</head>
<body>
<h1>XEM BÁO CÁO</h1>
<div class="btn-group">
    <a href="ViewSupplierStatistics.jsp" class="btn-primary">Nhà cung cấp</a>
    <a href="ViewHome.jsp" class="btn-secondary">Quay lại</a>
</div>
</body>
</html>