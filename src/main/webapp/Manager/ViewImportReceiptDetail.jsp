<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ImportReceiptDAO, dao.ImportReceiptDetailDAO, model.ImportReceipt2, model.ImportReceiptDetail2, java.util.List, java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    int idReceipt = Integer.parseInt(request.getParameter("idReceipt"));
    int idSupplier = Integer.parseInt(request.getParameter("idSupplier"));
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    ImportReceiptDAO receiptDAO = new ImportReceiptDAO();
    ImportReceipt2 receipt = receiptDAO.getImportReceipt(idReceipt);

    ImportReceiptDetailDAO detailDAO = new ImportReceiptDetailDAO();
    List<ImportReceiptDetail2> listDetails = detailDAO.getImportReceiptDetail(idReceipt);

    int totalQuantity = 0;
    double grandTotal = 0;
    for (ImportReceiptDetail2 d : listDetails) {
        totalQuantity += d.getImportQuantity();
        grandTotal += d.getSubtotal();
    }

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    String formattedDateTime = receipt.getImportDateTime().format(dtf);

    request.setAttribute("receipt", receipt);
    request.setAttribute("listDetails", listDetails);
    request.setAttribute("formattedDateTime", formattedDateTime);
    request.setAttribute("totalQuantity", totalQuantity);
    request.setAttribute("grandTotal", grandTotal);
    request.setAttribute("idSupplier", idSupplier);
    request.setAttribute("startDate", startDateStr);
    request.setAttribute("endDate", endDateStr);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn nhập kho chi tiết</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px 40px; color: #333; }
        h2 { color: #002B66; text-align: center; text-transform: uppercase; margin-bottom: 25px; }
        .invoice-info { display: flex; justify-content: space-between; margin-bottom: 20px; }
        .info-col { width: 48%; }
        .info-col p { margin: 6px 0; font-size: 14px; }
        .info-col strong { color: #002B66; }
        .btn-back { background-color: #5B9BD5; color: white; border: none; padding: 8px 25px; font-weight: bold; text-decoration: none; border-radius: 3px; float: right; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; clear: both; }
        th { background-color: #002B66; color: white; padding: 10px; border: 1px solid #ccc; font-size: 14px; }
        td { padding: 10px; border: 1px solid #ccc; text-align: center; font-size: 14px; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .total-row { font-weight: bold; background-color: #e6f0ff !important; }
    </style>
</head>
<body>
<h2>HÓA ĐƠN NHẬP KHO CHI TIẾT</h2>

<a href="ViewSupplierImportHistory.jsp?idSupplier=${idSupplier}&startDate=${startDate}&endDate=${endDate}" class="btn-back">Quay lại</a>

<div class="invoice-info">
    <div class="info-col">
        <p><strong>Phiếu nhập:</strong> PN<fmt:parseDate value="${receipt.importDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" /><fmt:formatDate value="${parsedDate}" pattern="yyyyMMdd" />-<fmt:formatNumber value="${receipt.id}" pattern="00"/></p>
        <p><strong>Nhà cung cấp:</strong> ${receipt.supplier.supplierName} (NCC<fmt:formatNumber value="${receipt.supplier.id}" pattern="000"/>)</p>
        <p><strong>Địa chỉ NCC:</strong> ${receipt.supplier.address}</p>
        <p><strong>Mã số thuế:</strong> ${receipt.supplier.taxCode}</p>
    </div>
    <div class="info-col">
        <p><strong>Thời gian nhập kho:</strong> ${formattedDateTime}</p>
        <p><strong>Nhân viên nhập kho:</strong> ${receipt.warehouseStaff.fullName} (NV<fmt:formatNumber value="${receipt.warehouseStaff.id}" pattern="000"/>)</p>
        <p><strong>Số điện thoại NCC:</strong> ${receipt.supplier.phoneNumber}</p>
    </div>
</div>

<table>
    <thead>
    <tr>
        <th>STT</th>
        <th>Mã phụ tùng</th>
        <th>Tên phụ tùng</th>
        <th>Đơn vị tính</th>
        <th>SL nhập</th>
        <th>Đơn giá nhập (VNĐ)</th>
        <th>Thành tiền (VNĐ)</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="detail" items="${listDetails}" varStatus="loop">
        <tr>
            <td>${loop.index + 1}</td>
            <td>PT<fmt:formatNumber value="${detail.sparePart.id}" pattern="000"/></td>
            <td style="text-align: left;">${detail.sparePart.partName}</td>
            <td>${detail.sparePart.unit}</td>
            <td>${detail.importQuantity}</td>
            <td style="text-align: right;"><fmt:formatNumber value="${detail.importUnitPrice}" type="number" groupingUsed="true"/></td>
            <td style="text-align: right;"><fmt:formatNumber value="${detail.subtotal}" type="number" groupingUsed="true"/></td>
        </tr>
    </c:forEach>
    <tr class="total-row">
        <td colspan="4" style="text-align: right;">TỔNG CỘNG</td>
        <td>${totalQuantity}</td>
        <td></td>
        <td style="text-align: right;"><fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/></td>
    </tr>
    </tbody>
</table>
</body>
</html>