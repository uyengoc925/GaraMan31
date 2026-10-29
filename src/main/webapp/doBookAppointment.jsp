<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AppointmentDAO, dao.CustomerDAO, dao.VehicleDAO" %>
<%@ page import="model.Appointment2, model.Customer2, model.Vehicle2" %>
<%@ page import="java.time.LocalDate, java.time.LocalTime" %>
<%@ page import="java.net.URLEncoder" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Chỉ chấp nhận phương thức POST
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("UIBookAppointment.jsp");
        return;
    }

    String strDate = null;
    try {
        // 1. Thu thập dữ liệu từ Form
        strDate = request.getParameter("inSelectedDate");
        if (strDate == null || strDate.trim().isEmpty()) {
            strDate = request.getParameter("date");
        }
        if (strDate == null || strDate.trim().isEmpty() || "null".equalsIgnoreCase(strDate.trim())) {
            strDate = LocalDate.now().toString();
        }
        strDate = strDate.trim();
       // Đảm bảo strDate không bao giờ là null hoặc chuỗi "null"
        String strTimeSlot = request.getParameter("radTimeSlot");

        String fullName = request.getParameter("txtFullName");
        String gender = request.getParameter("cboGender");
        String phoneNumber = request.getParameter("txtPhoneNumber");
        String licensePlate = request.getParameter("txtLicensePlate");
        String brand = request.getParameter("txtBrand");
        String vehicleType = request.getParameter("txtVehicleType");
        String color = request.getParameter("txtColor");

        if (strDate == null || strTimeSlot == null || fullName == null || phoneNumber == null || licensePlate == null) {
            String errorMsg = URLEncoder.encode("Vui lòng điền đầy đủ các thông tin bắt buộc!", "UTF-8");
            response.sendRedirect("UIBookAppointment.jsp?inSelectedDate=" + strDate + "&error=" + errorMsg);
            return;
        }
        if (!phoneNumber.matches("[0-9]{10}")) {
            String errorMsg = URLEncoder.encode("Số điện thoại phải gồm đúng 10 chữ số!", "UTF-8");
            response.sendRedirect("UIBookAppointment.jsp?inSelectedDate=" + strDate + "&error=" + errorMsg);
            return;
        }
        LocalDate date = LocalDate.parse(strDate);
        if (date.isBefore(LocalDate.now())) {
            String errorMsg = URLEncoder.encode("Không thể đặt lịch cho ngày trong quá khứ!", "UTF-8");
            response.sendRedirect("UIBookAppointment.jsp?inSelectedDate=" + LocalDate.now() + "&error=" + errorMsg);
            return;
        }
        String startTimeStr = strTimeSlot.split(" - ")[0] + ":00";
        LocalTime time = LocalTime.parse(startTimeStr);

        AppointmentDAO appointmentDAO = new AppointmentDAO();

        // 2. Kiểm tra sức chứa tại thời điểm bấm Xác nhận đặt lịch (Concurrency Check)
        boolean isSlotAvailable = appointmentDAO.checkSlotAvailable(date, startTimeStr);
        if (!isSlotAvailable) {
            String errorMsg = URLEncoder.encode("Rất tiếc! Khung giờ " + strTimeSlot + " ngày " + strDate + " vừa được đăng ký hết chỗ. Vui lòng chọn khung giờ khác!", "UTF-8");
            response.sendRedirect("UIBookAppointment.jsp?inSelectedDate=" + strDate + "&error=" + errorMsg);
            return;
        }

        // 3. Tìm hoặc Tạo mới Khách hàng
        Customer2 customer = new Customer2();
        customer.setFullName(fullName);
        customer.setGender(gender);
        customer.setPhoneNumber(phoneNumber);

        CustomerDAO customerDAO = new CustomerDAO();
        customer = customerDAO.findOrCreateCustomer(customer);

        // 4. Tìm hoặc Tạo mới Phương tiện
        Vehicle2 vehicle = new Vehicle2();
        vehicle.setLicensePlate(licensePlate);
        vehicle.setBrand(brand);
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color);

        VehicleDAO vehicleDAO = new VehicleDAO();
        vehicle = vehicleDAO.findOrCreateVehicle(vehicle, customer.getId());

        // 5. Khởi tạo đối tượng Lịch hẹn ở trạng thái "Chờ tiếp nhận"
        Appointment2 appointment = new Appointment2();
        appointment.setDate(date);
        appointment.setTime(time);
        appointment.setStatus("Chờ tiếp nhận");
        appointment.setCustomer(customer);
        appointment.setVehicle(vehicle);

        // 6. Thực hiện lưu chứng từ Lịch hẹn vào CSDL
        boolean isSuccess = appointmentDAO.createAppointment(appointment);

        if (isSuccess) {
            // Lưu lịch hẹn vào Session để hiển thị ở trang xác nhận thành công
            session.setAttribute("createdAppointment", appointment);
            response.sendRedirect("UIConfirmAppointment.jsp");
        } else {
            String errorMsg = URLEncoder.encode("Lỗi hệ thống! Không thể khởi tạo lịch hẹn.", "UTF-8");
            response.sendRedirect("UIBookAppointment.jsp?inSelectedDate=" + strDate + "&error=" + errorMsg);
        }

    } catch (Exception e) {
        e.printStackTrace();
        String errorMsg = URLEncoder.encode("Dữ liệu nhập vào không hợp lệ: " + e.getMessage(), "UTF-8");
        // Truyền thêm inSelectedDate để trang UI không bị crash
        response.sendRedirect("UIBookAppointment.jsp?inSelectedDate=" + strDate + "&error=" + errorMsg);
    }
%>