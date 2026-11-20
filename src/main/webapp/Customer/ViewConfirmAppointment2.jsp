<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment2" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.Appointment2DAO" %>
<%
    Object sessionAttr = session.getAttribute("createdAppointment");
    if (sessionAttr == null) {
        response.sendRedirect("ViewBookAppointment2.jsp");
        return;
    }
    int appointmentId = (Integer) sessionAttr;
    Appointment2DAO appointmentDAO = new Appointment2DAO();
    Appointment2 appointment = appointmentDAO.getAppointment(appointmentId);
    if (appointment == null) {
%>
        <div style="text-align: center; margin-top: 50px; font-family: Arial, sans-serif;">
            <h2>Không tìm thấy thông tin lịch hẹn #<%= appointmentId %></h2>
            <a href="ViewBookAppointment2.jsp">Quay lại trang đặt lịch</a>
        </div>
<%
        return;
    }

    // Định dạng mã lịch hẹn: YYYYMMDD + ID 3 chữ số (Ví dụ: 20261015001)
    String datePart = new SimpleDateFormat("yyyyMMdd").format(appointment.getDate());
    String appointmentCode = datePart + String.format("%03d", appointment.getId());

    // Định dạng thời gian hẹn: 08:00 - 10:00, ngày dd/MM/yyyy
    String[][] SLOTS = {
            {"08:00:00", "10:00:00"},
            {"10:00:00", "11:30:00"},
            {"13:30:00", "15:30:00"},
            {"15:30:00", "17:00:00"}
    };
    String slotRange = appointment.getTime().toString().substring(0, 5);
    for (String[] s : SLOTS) {
        if (s[0].startsWith(slotRange)) {
            slotRange = s[0].substring(0, 5) + " - " + s[1].substring(0, 5);
            break;
        }
    }
    String dateDisplay = new SimpleDateFormat("dd/MM/yyyy").format(appointment.getDate());
    String timeDisplay = slotRange + ", ngày " + dateDisplay;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt Lịch Hẹn Thành Công - GaraMan</title>
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
            padding: 35px 15px;
            display: flex;
            justify-content: center;
        }
        .confirm-container {
            width: 100%;
            max-width: 620px;
        }
        .success-title {
            color: #0e7c61;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .subtitle {
            text-align: center;
            font-style: italic;
            color: #666666;
            font-size: 14px;
            margin-bottom: 24px;
        }

        /* Bảng chi tiết lịch hẹn */
        table.detail-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 22px;
            font-size: 14px;
        }
        table.detail-table th {
            background-color: #263645;
            color: #ffffff;
            font-weight: bold;
            text-align: center;
            padding: 9px 12px;
            border: 1px solid #d9d9d9;
        }
        table.detail-table td {
            padding: 7px 12px;
            border: 1px solid #e0e0e0;
        }
        table.detail-table td.col-label {
            width: 38%;
            font-weight: bold;
            color: #111111;
        }
        table.detail-table td.col-value {
            width: 62%;
            color: #222222;
        }
        /* Tô màu xanh đậm cho mã lịch hẹn */
        table.detail-table tbody tr:first-child td.col-value strong {
            color: #143666;
            font-size: 15px;
        }
        .status-radio {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* Nút Về trang chủ căn thẳng với cột Dữ liệu bên phải */
        .action-row {
            display: flex;
            justify-content: flex-end;
        }
        .btn-home {
            width: 62%; /* Bằng đúng chiều rộng cột Dữ liệu */
            background-color: #152b54;
            color: #ffffff;
            border: none;
            padding: 9px 16px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-home:hover {
            background-color: #0e1e3d;
        }
    </style>
</head>
<body>

<div class="confirm-container">
    <h2 class="success-title">ĐẶT LỊCH HẸN THÀNH CÔNG!</h2>
    <p class="subtitle">Cảm ơn quý khách. Lịch hẹn của quý khách đã được lưu vào hệ thống.</p>

    <table class="detail-table" name="tblAppointment">
        <thead>
        <tr>
            <th>Trường thông tin</th>
            <th>Dữ liệu</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="col-label">Mã lịch hẹn</td>
            <td class="col-value"><strong><%= appointmentCode %></strong></td>
        </tr>
        <tr>
            <td class="col-label">Trạng thái</td>
            <td class="col-value">
                <span class="status-radio">
                    <input type="radio" checked readonly/>
                    <%= appointment.getStatus() != null ? appointment.getStatus() : "Chờ xác nhận" %>
                </span>
            </td>
        </tr>
        <tr>
            <td class="col-label">Họ và tên khách hàng</td>
            <td class="col-value"><%= appointment.getCustomer().getFullName() %></td>
        </tr>
        <tr>
            <td class="col-label">Số điện thoại</td>
            <td class="col-value"><%= appointment.getCustomer().getPhoneNumber() %></td>
        </tr>
        <tr>
            <td class="col-label">Biển số xe</td>
            <td class="col-value"><%= appointment.getVehicle().getLicensePlate() %></td>
        </tr>
        <tr>
            <td class="col-label">Hãng xe</td>
            <td class="col-value"><%= appointment.getVehicle().getBrand() %></td>
        </tr>
        <tr>
            <td class="col-label">Dòng xe</td>
            <td class="col-value"><%= appointment.getVehicle().getVehicleType() %></td>
        </tr>
        <tr>
            <td class="col-label">Màu xe</td>
            <td class="col-value"><%= appointment.getVehicle().getColor() %></td>
        </tr>
        <tr>
            <td class="col-label">Thời gian hẹn</td>
            <td class="col-value"><strong><%= timeDisplay %></strong></td>
        </tr>
        </tbody>
    </table>

    <form action="ViewPublicHome2.jsp" method="GET">
        <%
            // Xóa thông tin khỏi Session sau khi hiển thị xong để tránh trùng lặp khi F5
            session.removeAttribute("createdAppointment");
        %>
        <div class="action-row">
            <button type="submit" class="btn-home" name="btnHome">Về trang chủ</button>
        </div>
    </form>
</div>

</body>
</html>
