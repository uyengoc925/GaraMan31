<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.Appointment2DAO" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%!
    // Escape giá trị điền lại vào thuộc tính HTML (tránh vỡ form / XSS)
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String dateParam = request.getParameter("inSelectedDate");
    if (dateParam == null || dateParam.trim().isEmpty()) {
        dateParam = request.getParameter("date");
    }
    Date selectedDate;
    if (dateParam != null && !dateParam.trim().isEmpty() && !"null".equalsIgnoreCase(dateParam.trim())) {
        try {
            selectedDate = Date.valueOf(dateParam.trim());
        } catch (IllegalArgumentException e) {
            selectedDate = new Date(System.currentTimeMillis());
        }
    } else {
        selectedDate = new Date(System.currentTimeMillis());
    }
    String[][] SLOTS = {
            {"08:00:00", "10:00:00"},
            {"10:00:00", "11:30:00"},
            {"13:30:00", "15:30:00"},
            {"15:30:00", "17:00:00"}
    };
    int CAPACITY = 5;
    Appointment2DAO appointmentDAO = new Appointment2DAO();
    HashMap<String, Integer> booked = appointmentDAO.getAvailableTimeSlot(selectedDate);
    if (booked == null) {
        booked = new HashMap<>();
    }
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = request.getParameter("error");
    }

    // Dữ liệu đã nhập trước đó (khi quay lại sau lỗi hoặc khi đổi ngày)
    String vName   = request.getParameter("txtFullName");
    String vGender = request.getParameter("cboGender");
    String vPhone  = request.getParameter("txtPhoneNumber");
    String vPlate  = request.getParameter("txtLicensePlate");
    String vBrand  = request.getParameter("txtBrand");
    String vType   = request.getParameter("txtVehicleType");
    String vColor  = request.getParameter("txtColor");
    String vSlot   = request.getParameter("radTimeSlot");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt Lịch Hẹn Trực Tuyến - GaraMan</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
        }
        body {
            background-color: #ffffff;
            color: #222222;
            padding: 25px 15px;
            display: flex;
            justify-content: center;
        }
        .main-container {
            background-color: #ffffff;
            width: 100%;
            max-width: 780px;
            padding: 10px 20px;
        }
        h2.page-title {
            color: #143666;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 24px;
            text-transform: uppercase;
        }
        h3.section-title {
            color: #143666;
            font-size: 16px;
            font-weight: bold;
            text-transform: uppercase;
            margin: 20px 0 12px 0;
        }
        .alert-error {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ef9a9a;
            padding: 10px 14px;
            border-radius: 3px;
            margin-bottom: 15px;
            font-size: 14px;
        }
        .date-picker-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            font-size: 14px;
        }
        .date-picker-row label {
            font-weight: bold;
            color: #111111;
            min-width: 115px;
        }
        .date-picker-row input[type="date"] {
            padding: 5px 12px;
            border: 1px solid #d0d7de;
            background-color: #e9f1fa;
            font-size: 14px;
            font-weight: bold;
            color: #111111;
            outline: none;
            cursor: pointer;
        }
        .date-picker-row button {
            padding: 6px 14px;
            background-color: #082356;
            color: #ffffff;
            border: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
        }
        .date-picker-row button:hover {
            background-color: #143666;
        }

        /* Bảng khung giờ */
        table.slot-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 26px;
            font-size: 14px;
        }
        table.slot-table th {
            background-color: #082356;
            color: #ffffff;
            font-weight: bold;
            text-align: center;
            padding: 8px;
            border: 1px solid #d9d9d9;
        }
        table.slot-table td {
            padding: 7px 8px;
            text-align: center;
            border: 1px solid #e0e0e0;
            vertical-align: middle;
        }
        /* Highlight nhẹ dòng đầu hoặc khi hover */
        table.slot-table tbody tr:hover:not(.disabled-row) {
            background-color: #eef6fc;
        }
        .status-available {
            color: #158066;
            font-weight: bold;
        }
        .status-full {
            color: #b71c1c;
            font-weight: bold;
        }
        .btn-lock {
            display: block;
            width: 100%;
            background-color: #a6a6a6;
            color: #ffffff;
            padding: 3px 0;
            font-size: 13px;
            font-weight: bold;
            cursor: not-allowed;
            user-select: none;
        }

        /* Form 2 cột thông tin khách hàng & xe */
        .form-grid {
            display: grid;
            grid-template-columns: 120px 1fr 140px 1fr;
            gap: 6px 14px;
            align-items: center;
            margin-bottom: 18px;
            font-size: 14px;
        }
        .form-grid label {
            font-weight: bold;
            color: #111111;
        }
        .form-grid input[type="text"],
        .form-grid input[type="tel"],
        .form-grid select {
            width: 100%;
            padding: 5px 8px;
            border: 1px solid #e0e0e0;
            font-size: 14px;
            color: #222222;
            background-color: #ffffff;
            outline: none;
        }
        .form-grid input:focus,
        .form-grid select:focus {
            border-color: #2c88d9;
        }

        /* Nút Xác nhận đặt lịch căn thẳng cột bên phải */
        .form-actions {
            display: grid;
            grid-template-columns: 120px 1fr 140px 1fr;
            gap: 0 14px;
            margin-top: 10px;
        }
        .btn-submit {
            grid-column: 3 / 5; /* Trải rộng từ cột Label 2 đến hết Input 2 */
            width: 100%;
            background-color: #2c91d6;
            color: #ffffff;
            padding: 9px 16px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.2s;
        }
        .btn-submit:hover {
            background-color: #1f78b4;
        }
    </style>
</head>
<body>

<div class="main-container">
    <h2 class="page-title">ĐẶT LỊCH HẸN TRỰC TUYẾN</h2>

    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="alert-error"><%= esc(errorMessage) %></div>
    <% } %>

    <!-- MỘT form duy nhất: mặc định gửi về trang này (đổi ngày / Xem lịch),
         riêng nút Xác nhận dùng formaction để gửi sang doBookAppointment2.jsp -->
    <form method="POST" action="ViewBookAppointment2.jsp" id="bookForm">
        <h3 class="section-title">1. CHỌN THỜI GIAN HẸN</h3>

        <div class="date-picker-row">
            <label for="date">Ngày hẹn (*):</label>
            <input type="date" id="date" name="inSelectedDate" value="<%=selectedDate%>" min="<%=new Date(System.currentTimeMillis())%>" onchange="reloadSlots()"/>
            <button type="button" onclick="reloadSlots()">Xem lịch</button>
        </div>

        <table class="slot-table">
            <thead>
            <tr>
                <th style="width: 25%;">Khung giờ</th>
                <th style="width: 20%;">Số xe đã đặt</th>
                <th style="width: 15%;">Sức chứa</th>
                <th style="width: 20%;">Trạng thái</th>
                <th style="width: 20%;">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <%
                int index = 1;
                for (String[] s : SLOTS) {
                    String startTime = s[0];
                    String endTime = s[1];
                    int n = booked.getOrDefault(startTime, 0);
                    boolean full = n >= CAPACITY;
                    String label = startTime.substring(0, 5) + " - " + endTime.substring(0, 5);
            %>
            <tr class="<%= full ? "disabled-row" : "" %>">
                <td><%= label %></td>
                <td><%= n %></td>
                <td><%= CAPACITY %></td>
                <td>
                    <% if (full) { %>
                    <span class="status-full">Đã đầy</span>
                    <% } else { %>
                    <span class="status-available">Còn trống</span>
                    <% } %>
                </td>
                <td>
                    <% if (!full) { %>
                    <input type="radio" name="radTimeSlot" value="<%= label %>" <%= label.equals(vSlot) ? "checked" : "" %> required/>
                    <% } else { %>
                    <div class="btn-lock">Khóa</div>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <h3 class="section-title">2. THÔNG TIN KHÁCH HÀNG & PHƯƠNG TIỆN</h3>

        <div class="form-grid">
            <label>Họ và tên *:</label>
            <input type="text" name="txtFullName" value="<%= esc(vName) %>" placeholder="Nguyễn Văn An" required/>

            <label>Giới tính:</label>
            <select name="cboGender">
                <option value="Nam"  <%= "Nam".equals(vGender)  ? "selected" : "" %>>Nam</option>
                <option value="Nữ"   <%= "Nữ".equals(vGender)   ? "selected" : "" %>>Nữ</option>
                <option value="Khác" <%= "Khác".equals(vGender) ? "selected" : "" %>>Khác</option>
            </select>

            <label>Số điện thoại *:</label>
            <input type="tel" name="txtPhoneNumber" value="<%= esc(vPhone) %>" pattern="[0-9]{10}" placeholder="0987654321" required/>

            <label>Biển số xe *:</label>
            <input type="text" name="txtLicensePlate" value="<%= esc(vPlate) %>" placeholder="30H-123.45" required/>

            <label>Hãng xe*:</label>
            <input type="text" name="txtBrand" value="<%= esc(vBrand) %>" placeholder="Toyota" required/>

            <label>Dòng xe / Loại xe:</label>
            <input type="text" name="txtVehicleType" value="<%= esc(vType) %>" placeholder="Cross" required/>

            <label>Màu xe*:</label>
            <input type="text" name="txtColor" value="<%= esc(vColor) %>" placeholder="Đỏ" required/>

            <div></div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-submit" name="btnConfirmBooking" formaction="doBookAppointment2.jsp">XÁC NHẬN ĐẶT LỊCH</button>
        </div>
    </form>
</div>

<script>
    // Đổi ngày: bỏ chọn khung giờ cũ rồi tải lại trang (các ô thông tin được điền lại)
    function reloadSlots() {
        document.querySelectorAll('input[name="radTimeSlot"]').forEach(function (r) { r.checked = false; });
        document.getElementById('bookForm').submit();
    }
</script>

</body>
</html>
