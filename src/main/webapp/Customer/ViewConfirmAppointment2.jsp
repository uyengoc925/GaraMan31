<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment2" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // Lấy thông tin lịch hẹn mới tạo ra từ Session
    Appointment2 appointment = (Appointment2) session.getAttribute("createdAppointment");
    // Format mã lịch hẹn dạng LHyyyyMMdd-00X
    if (appointment == null) {
       // gui thong bao erro den lich hen - va gui lai

        return;
    }
    String formattedDate = appointment.getDate().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
    String appointmentCode = "LH" + formattedDate + "-" + String.format("%03d", appointment.getId());
    String[][] SLOTS = {
            {"08:00:00", "10:00:00"},
            {"10:00:00", "11:30:00"},
            {"13:30:00", "15:30:00"},
            {"15:30:00", "17:00:00"}
    };
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Đặt Lịch Thành Công - GaraMan</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 40px 0;
            display: flex;
            justify-content: center;
        }
        .card {
            width: 50%;
            max-width: 650px;
            background: #ffffff;
            padding: 35px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h2 { color: #28a745; margin-bottom: 5px; }
        .header p { color: #6c757d; font-size: 14px; margin: 0; }
        .detail-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .detail-table td { padding: 12px 10px; border-bottom: 1px solid #e9ecef; }
        .detail-table td.label { font-weight: bold; color: #495057; width: 40%; }
        .detail-table td.value { color: #212529; }
        .status-badge {
            background-color: #fff3cd;
            color: #856404;
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: bold;
            display: inline-block;
        }
        .btn-home {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            text-align: center;
            font-weight: bold;
            text-decoration: none;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-home:hover { background-color: #0056b3; }
    </style>
</head>
<body>

<div class="card">
    <div class="header">
        <h2> ĐẶT LỊCH HẸN THÀNH CÔNG!</h2>
        <p>Cảm ơn quý khách đã tin tưởng dịch vụ của GaraMan</p>
    </div>

    <table class="detail-table">
        <tr>
            <td class="label">Mã lịch hẹn:</td>
            <td class="value"><strong style="color: #007bff;"><%= appointmentCode %></strong></td>
        </tr>
        <tr>
            <td class="label">Trạng thái:</td>
            <td class="value"><span class="status-badge">🟡 <%= appointment.getStatus() %></span></td>
        </tr>
        <tr>
            <td class="label">Họ và tên khách hàng:</td>
            <td class="value"><%= appointment.getCustomer().getFullName() %></td>
        </tr>
        <tr>
            <td class="label">Số điện thoại:</td>
            <td class="value"><%= appointment.getCustomer().getPhoneNumber() %></td>
        </tr>
        <tr>
            <td class="label">Biển số xe:</td>
            <td class="value"><strong><%= appointment.getVehicle().getLicensePlate() %></strong></td>
        </tr>
        <tr>
            <td class="label">Thông tin xe:</td>
            <td class="value">
                <%= appointment.getVehicle().getBrand() %> -
                <%= appointment.getVehicle().getVehicleType() %>
                (<%= appointment.getVehicle().getColor() %>)
            </td>
        </tr>
        <tr>
            <td class="label">Thời gian hẹn:</td>
            <td class="value">
                <strong style="color: #dc3545;">
<%--                    // can hien thi ca khung gio hen--%>
                    <%= appointment.getTime() %>, ngày <%= appointment.getDate() %>
                </strong>
            </td>
        </tr>
    </table>

    <form action="ViewPublicHome.jsp" method="GET">
        <%
            // Xóa thông tin khỏi Session sau khi hiển thị xong để tránh trùng lặp khi F5
            session.removeAttribute("createdAppointment");
        %>
        <button type="submit" class="btn-home" name="btnOk" >Oke</button>
    </form>
</div>

</body>
</html>