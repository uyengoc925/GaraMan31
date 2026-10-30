<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.SupplierStatisticsDAO, model.SupplierStatistics2, java.util.List, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    // Lấy ngày mặc định (01/08/2026 - 31/08/2026) theo đúng mẫu dữ liệu
    if (startDateStr == null || startDateStr.trim().isEmpty()) startDateStr = "2026-09-30"; // trước ngày hôm nay 1 tháng
    if (endDateStr == null || endDateStr.trim().isEmpty()) endDateStr = "2026-10-30"; // ngày hôm nay

    LocalDate startDate = LocalDate.parse(startDateStr);
    LocalDate endDate = LocalDate.parse(endDateStr);

    SupplierStatisticsDAO dao = new SupplierStatisticsDAO();
    List<SupplierStatistics2> listStats = dao.getSupplierImportStatistics(startDate, endDate);

    int totalCountAll = 0;
    int totalQuantityAll = 0;
    double totalValueAll = 0;

    for (SupplierStatistics2 s : listStats) {
        totalCountAll += s.getTotalImportCount();
        totalQuantityAll += s.getTotalImportQuantity();
        totalValueAll += s.getTotalImportValue();
    }

    request.setAttribute("listStats", listStats);
    request.setAttribute("startDate", startDateStr);
    request.setAttribute("endDate", endDateStr);
    request.setAttribute("totalCountAll", totalCountAll);
    request.setAttribute("totalQuantityAll", totalQuantityAll);
    request.setAttribute("totalValueAll", totalValueAll);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê nhà cung cấp theo lượng hàng nhập</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px 40px; color: #333; }
        h2 { color: #002B66; text-align: center; text-transform: uppercase; margin-bottom: 25px; }
        .filter-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .filter-inputs { font-weight: bold; color: #002B66; }
        .filter-inputs input[type="date"] { padding: 5px; font-size: 14px; margin: 0 10px; }
        .action-btns { display: flex; flex-direction: column; gap: 8px; }
        .btn-action { background-color: #5B9BD5; color: white; border: none; padding: 8px 20px; font-weight: bold; text-decoration: none; border-radius: 3px; text-align: center; }
        .btn-submit { background-color: #2F5597; color: white; border: none; padding: 8px 20px; font-weight: bold; cursor: pointer; border-radius: 3px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background-color: #002B66; color: white; padding: 10px; border: 1px solid #ccc; font-size: 14px; }
        td { padding: 10px; border: 1px solid #ccc; text-align: center; font-size: 14px; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .total-row { font-weight: bold; background-color: #e6f0ff !important; }
        a.link-detail { color: #002B66; text-decoration: underline; font-weight: bold; }
    </style>
</head>
<body>
<h2>THỐNG KÊ NHÀ CUNG CẤP THEO LƯỢNG HÀNG NHẬP</h2>

<form method="GET" action="ViewSupplierStatistics.jsp">
    <div class="filter-box">
        <div class="filter-inputs">
            <span>CHỌN KHOẢNG THỜI GIAN TRA CỨU</span><br><br>
            Từ ngày (*): <input type="date" name="startDate" value="${startDate}" required>
            Đến ngày (*): <input type="date" name="endDate" value="${endDate}" required>
        </div>
        <div class="action-btns">
            <a href="ViewReportMenu.jsp" class="btn-action">Quay lại</a>
            <button type="submit" class="btn-submit" name = "btnViewStatistics">Xem thống kê</button>
        </div>
    </div>
</form>

<table>
    <thead>
    <tr>
        <th>STT</th>
        <th>Mã NCC</th>
        <th>Tên nhà cung cấp</th>
        <th>Số lượt nhập</th>
        <th>Tổng SL phụ tùng</th>
        <th>Tổng tiền nhập (VNĐ)</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="stat" items="${listStats}" varStatus="loop">
        <tr>
            <td>${loop.index + 1}</td>
            <td>NCC<fmt:formatNumber value="${stat.id}" pattern="000"/></td>
            <td style="text-align: left;">${stat.supplierName}</td>
            <td>${stat.totalImportCount}</td>
            <td>${stat.totalImportQuantity}</td>
            <td style="text-align: right;"><fmt:formatNumber value="${stat.totalImportValue}" type="number" groupingUsed="true"/></td>
            <td>
                <a class="link-detail" href="ViewSupplierImportHistory.jsp?idSupplier=${stat.id}&startDate=${startDate}&endDate=${endDate}">Xem chi tiết</a>
<%--                gửi id supplier và startDate, endDate sang xem lịch sử nhập hàng--%>
            </td>
        </tr>
    </c:forEach>
    <tr class="total-row">
        <td colspan="3" style="text-align: right; font-weight: bold;">TỔNG CỘNG</td>
        <td>${totalCountAll}</td>
        <td>${totalQuantityAll}</td>
        <td style="text-align: right;"><fmt:formatNumber value="${totalValueAll}" type="number" groupingUsed="true"/></td>
        <td></td>
    </tr>

    </tbody>
</table>
</body>
</html>