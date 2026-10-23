<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.SupplierDAO, dao.ImportReceiptDAO, model.Supplier2, model.ImportReceipt2, java.util.List, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    int idSupplier = Integer.parseInt(request.getParameter("idSupplier"));
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    LocalDate startDate = LocalDate.parse(startDateStr);
    LocalDate endDate = LocalDate.parse(endDateStr);

    SupplierDAO supplierDAO = new SupplierDAO();
    Supplier2 supplier = supplierDAO.getSupplier(idSupplier);

    ImportReceiptDAO receiptDAO = new ImportReceiptDAO();
    List<ImportReceipt2> listReceipts = receiptDAO.getImportReceiptsBySupplier(idSupplier, startDate, endDate);

    double grandTotalValue = 0;
    int grandTotalQty = 0;
    for (ImportReceipt2 r : listReceipts) {
        grandTotalValue += r.getTotalImportAmount();
        grandTotalQty += r.getTotalQuantity();
    }

    // Đổi định dạng hiển thị khoảng thời gian dd/MM/yyyy
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String displayDateRange = startDate.format(dtf) + " – " + endDate.format(dtf);

    request.setAttribute("supplier", supplier);
    request.setAttribute("listReceipts", listReceipts);
    request.setAttribute("displayDateRange", displayDateRange);
    request.setAttribute("startDate", startDateStr);
    request.setAttribute("endDate", endDateStr);
    request.setAttribute("grandTotalValue", grandTotalValue);
    request.setAttribute("grandTotalQty", grandTotalQty);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết lịch sử nhập hàng theo nhà cung cấp</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px 40px; color: #333; }
        h2 { color: #002B66; text-align: center; text-transform: uppercase; margin-bottom: 20px; }
        .header-section { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .info-box p { margin: 5px 0; font-size: 14px; }
        .info-box strong { color: #002B66; }
        .btn-back { background-color: #5B9BD5; color: white; border: none; padding: 8px 25px; font-weight: bold; text-decoration: none; border-radius: 3px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background-color: #002B66; color: white; padding: 10px; border: 1px solid #ccc; font-size: 14px; }
        td { padding: 10px; border: 1px solid #ccc; text-align: center; font-size: 14px; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .total-row { font-weight: bold; background-color: #e6f0ff !important; }
        a.link-detail { color: #002B66; text-decoration: underline; font-weight: bold; }
    </style>
</head>
<body>
<h2>CHI TIẾT LỊCH SỬ NHẬP HÀNG THEO NHÀ CUNG CẤP</h2>

<div class="header-section">
    <div class="info-box">
        <p><strong>THÔNG TIN NHÀ CUNG CẤP:</strong></p>
        <p><strong>Mã nhà cung cấp:</strong> NCC<fmt:formatNumber value="${supplier.id}" pattern="000"/></p>
        <p><strong>Khoảng thời gian:</strong> ${displayDateRange}</p>
        <p><strong>Tên nhà cung cấp:</strong> ${supplier.supplierName}</p>
    </div>
    <div>
        <a href="ViewSupplierStatistics.jsp?startDate=${startDate}&endDate=${endDate}" class="btn-back">Quay lại</a>
    </div>
</div>

<table>
    <thead>
    <tr>
        <th>STT</th>
        <th>Mã phiếu nhập</th>
        <th>Ngày giờ nhập kho</th>
        <th>Mã NV kho</th>
        <th>Tổng SL nhập</th>
        <th>Tổng tiền(VNĐ)</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="receipt" items="${listReceipts}" varStatus="loop">
        <tr>
            <td>${loop.index + 1}</td>
            <td>PN<fmt:parseDate value="${receipt.importDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" /><fmt:formatDate value="${parsedDate}" pattern="yyyyMMdd" />-<fmt:formatNumber value="${receipt.id}" pattern="00"/></td>
            <td><fmt:parseDate value="${receipt.importDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" /><fmt:formatDate value="${pDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
            <td>NV<fmt:formatNumber value="${receipt.warehouseStaff.id}" pattern="000"/></td>
            <td>${receipt.totalQuantity}</td> <!-- Đã bỏ thẻ </td> bị thừa ở đây -->
            <td style="text-align: right;"><fmt:formatNumber value="${receipt.totalImportAmount}" type="number" groupingUsed="true"/></td>
            <td>
                <a class="link-detail" href="ViewImportReceiptDetail.jsp?idReceipt=${receipt.id}&idSupplier=${supplier.id}&startDate=${startDate}&endDate=${endDate}">Xem hóa đơn</a>
            </td>
        </tr>
    </c:forEach>
    <tr class="total-row">
        <td colspan="4" style="text-align: right;">Tổng cộng</td>
        <td>${grandTotalQty}</td> <!-- Thay ${totalQty} thành ${grandTotalQty} -->
        <td style="text-align: right;"><fmt:formatNumber value="${grandTotalValue}" type="number" groupingUsed="true"/></td>
        <td></td>
    </tr>
    </tbody>
</table>
</body>
</html>