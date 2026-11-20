<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.SupplierStatistics2DAO, model.SupplierStatistics2, java.util.List, java.time.LocalDate, java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    if (startDateStr == null) startDateStr = "";
    if (endDateStr == null) endDateStr = "";




    List<SupplierStatistics2> listStats = new java.util.ArrayList<>();
       int totalCountAll = 0;
    int totalQuantityAll = 0;
    double totalValueAll = 0;
    String errorMessage = null;
    boolean searched = !startDateStr.trim().isEmpty() && !endDateStr.trim().isEmpty();
    if (searched) {
        try {
            LocalDate startDate = LocalDate.parse(startDateStr.trim());
            LocalDate endDate = LocalDate.parse(endDateStr.trim());

            if (endDate.isBefore(startDate)) {
                errorMessage = "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.";
            } else {
                SupplierStatistics2DAO dao = new SupplierStatistics2DAO();
                listStats = dao.getSupplierImportStatistics(startDate, endDate);

                for (SupplierStatistics2 s : listStats) {
                    totalCountAll += s.getTotalImportReceipts();
                    totalQuantityAll += s.getTotalImportQuantity();
                    totalValueAll += s.getTotalImportValue();
                }
            }
        } catch (java.time.format.DateTimeParseException e) {
            errorMessage = "Ngày không hợp lệ.";
            searched = false;
        }
    }

    request.setAttribute("listStats", listStats);
    request.setAttribute("startDate", startDateStr);
    request.setAttribute("endDate", endDateStr);
    request.setAttribute("totalCountAll", totalCountAll);
    request.setAttribute("totalQuantityAll", totalQuantityAll);
    request.setAttribute("totalValueAll", totalValueAll);
    request.setAttribute("errorMessage", errorMessage);
    request.setAttribute("searched", searched);
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
        td.num { text-align: right; padding-right: 20px; }
    </style>
</head>

<body>
<h2>THỐNG KÊ NHÀ CUNG CẤP THEO LƯỢNG HÀNG NHẬP</h2>
<c:if test="${not empty errorMessage}">
    <p style="color: red; font-weight: bold;">${errorMessage}</p>
</c:if>
<form method="GET" action="ViewSupplierStatistics.jsp">
    <div class="filter-box">
        <div class="filter-inputs">
            <span>CHỌN KHOẢNG THỜI GIAN TRA CỨU</span><br><br>
            Từ ngày (*): <input type="date" id="startDate" name="startDate" value="${startDate}" required>
            Đến ngày (*): <input type="date" id="endDate" name="endDate" value="${endDate}" min="${startDate}" required>
        </div>
        <div class="action-btns">
            <a href="ViewReportMenu.jsp" class="btn-action">Quay lại</a>
            <button type="submit" class="btn-submit">Xem thống kê</button>
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
    <c:choose>
        <c:when test="${not searched}">
            <tr><td colspan="7">Vui lòng chọn khoảng thời gian rồi bấm "Xem thống kê".</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="stat" items="${listStats}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>NCC<fmt:formatNumber value="${stat.id}" pattern="000"/></td>
                    <td style="text-align: left;">${stat.supplierName}</td>
                    <td  class="num"> ${stat.totalImportReceipts}</td>
                    <td  class="num">${stat.totalImportQuantity}</td>
                    <td  class="num" ><fmt:formatNumber value="${stat.totalImportValue}" type="number" groupingUsed="true"/></td>true"/></td>
                    <td>
                        <a class="link-detail" href="ViewSupplierImportHistory.jsp?idSupplier=${stat.id}&startDate=${startDate}&endDate=${endDate}">Xem chi tiết</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listStats}">
                <tr><td colspan="7">Không có dữ liệu trong khoảng thời gian này.</td></tr>
            </c:if>

            <tr class="total-row">
                <td colspan="3" style="text-align: left; font-weight: bold;">TỔNG CỘNG</td>
                <td  class="num">${totalCountAll}</td>
                <td  class="num">${totalQuantityAll}</td>
                <td class="num"><fmt:formatNumber value="${stat.totalImportValue}" type="number" groupingUsed="true"/></td>
                <td></td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>
<script>
    var startInput = document.getElementById('startDate');
    var endInput = document.getElementById('endDate');
    startInput.addEventListener('change', function () {
        endInput.min = startInput.value;
        if (endInput.value && startInput.value && endInput.value < startInput.value) {
            endInput.value = startInput.value;
        }
    });
</script>
</body>
</html>