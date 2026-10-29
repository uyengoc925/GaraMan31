        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%@ page import="com.mysql.cj.protocol.FullReadInputStream" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Lấy ngày đã chọn từ URL parameter, nếu chưa chọn thì mặc định là ngày hôm nay
    String dateParam = request.getParameter("inSelectedDate");
    if (dateParam == null || dateParam.trim().isEmpty()) {
        dateParam = request.getParameter("date");
    }
    LocalDate selectedDate;
    if (dateParam != null && !dateParam.trim().isEmpty() && !"null".equalsIgnoreCase(dateParam.trim())) {
        try {
            selectedDate = LocalDate.parse(dateParam.trim());
        } catch (Exception e) {
            selectedDate = LocalDate.now(); // Gán mặc định nếu định dạng chuỗi bị sai
        }
    } else {
        selectedDate = LocalDate.now();
    }
    String[][] SLOTS = {
            {"08:00:00", "10:00:00"},
            {"10:00:00", "11:30:00"},
            {"13:30:00", "15:30:00"},
            {"15:30:00", "17:00:00"}
    };
    int CAPACITY = 5;
    // Gọi DAO để lấy danh sách các khung giờ và số lượt đã đặt trong ngày đã chọn
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    HashMap<String, Integer> booked = appointmentDAO.getAvailableTimeSlot(Date.valueOf(selectedDate));
    if (booked == null) {
        booked = new HashMap<>();
    }
    // Lấy thông báo lỗi (nếu có từ doBookAppointment.jsp chuyển về)
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = request.getParameter("error");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Form Đặt Lịch Hẹn Trực Tuyến - GaraMan</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 20px 0;
            color: #333;
        }
        .form-container {
            width: 60%;
            max-width: 800px;
            margin: 0 auto;
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 25px; }
        h3 { color: #007bff; border-bottom: 2px solid #e9ecef; padding-bottom: 8px; margin-top: 30px; }
        .form-group { margin-bottom: 16px; display: flex; align-items: center; }
        .form-group label { width: 180px; font-weight: 600; color: #495057; }
        .form-group input, .form-group select {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
        }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #dee2e6; padding: 12px; text-align: center; }
        th { background-color: #f8f9fa; color: #495057; }
        .disabled-row { background-color: #e9ecef; color: #6c757d; }
        .badge-success { color: #28a745; font-weight: bold; }
        .badge-danger { color: #dc3545; font-weight: bold; }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .btn-submit {
            display: block;
            width: 100%;
            padding: 14px;
            background-color: #28a745;
            color: white;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 30px;
        }
        .btn-submit:hover { background-color: #218838; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>FORM ĐẶT LỊCH HẸN TRỰC TUYẾN</h2>

    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="alert-error"><%=errorMessage%></div>
    <% } %>

    <!-- Form Chọn Ngày hẹn (Gửi GET để tự làm mới danh sách khung giờ) -->
    <form method="GET" action="UIBookAppointment.jsp" id="dateForm">
        <div class="form-group">
            <label for="date">Chọn Ngày hẹn:</label>
            <input type="date" id="date" name="inSelectedDate" value="<%=selectedDate%>" min="<%=LocalDate.now()%>" onchange="document.getElementById('dateForm').submit()"/>
        </div>
    </form>

    <!-- Form Đặt Lịch Hẹn (Gửi POST sang doBookAppointment.jsp để xử lý lưu CSDL) -->
    <form method="POST" action="doBookAppointment.jsp">
        <input type="hidden" name="inSelectedDate" value="<%=selectedDate%>"/>

        <h3>1. Danh sách Khung giờ hẹn</h3>
        <table>
            <thead>
            <tr>
                <th>STT</th>
                <th>Khung giờ</th>
                <th>Số xe đã đặt</th>
                <th>Sức chứa</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
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
                <td><%= index++ %></td>
                <td><%= label %></td>
                <td><%= n %></td>
                <td><%= CAPACITY %></td>
                <td>
                    <% if (full) { %>
                    <span class="badge-danger">Đã đầy</span>
                    <% } else { %>
                    <span class="badge-success">Còn trống</span>
                    <% } %>
                </td>
                <td>
                    <% if (!full) { %>
                    <input type="radio" name="radTimeSlot" value="<%= startTime.substring(0, 5) %> - <%= endTime.substring(0, 5) %>" required/>
                    <% } else { %>
                    <input type="radio" disabled/>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <h3>2. Thông tin Khách hàng & Phương tiện</h3>
        <div class="form-group">
            <label>Họ và tên (*):</label>
            <input type="text" name="txtFullName" placeholder="Ví dụ: Nguyễn Văn An" required/>
        </div>
        <div class="form-group">
            <label>Giới tính:</label>
            <select name="cboGender">
                <option value="Nam">Nam</option>
                <option value="Nữ">Nữ</option>
                <option value="Khác">Khác</option>

            </select>
        </div>
        <div class="form-group">
            <label>Số điện thoại (*):</label>
            <input type="tel" name="txtPhoneNumber" pattern="[0-9]{10}" placeholder="Nhập đủ 10 chữ số" required/>
        </div>
        <div class="form-group">
            <label>Biển số xe (*):</label>
            <input type="text" name="txtLicensePlate" placeholder="Ví dụ: 30H-123.45" required/>
        </div>
        <div class="form-group">
            <label>Hãng xe:</label>
            <input type="text" name="txtBrand" placeholder="Ví dụ: Toyota" required/>
        </div>
        <div class="form-group">
            <label>Loại xe:</label>
            <input type="text" name="txtVehicleType" placeholder="Ví dụ: Cross" required/>
        </div>
        <div class="form-group">
            <label>Màu xe:</label>
            <input type="text" name="txtColor" placeholder="Ví dụ: Đỏ" required/>
        </div>

        <button type="submit" class="btn-submit" name="btnConfirmBooking"  >Xác nhận đặt lịch</button>
    </form>
</div>

</body>
</html>