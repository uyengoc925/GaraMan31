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

    try {
        // 1. Thu thập dữ liệu từ Form
        String strDate = request.getParameter("date");
        String strTimeSlot = request.getParameter("timeSlot");
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String phoneNumber = request.getParameter("phoneNumber");
        String licensePlate = request.getParameter("licensePlate");
        String brand = request.getParameter("brand");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");

        LocalDate date = LocalDate.parse(strDate);
        String startTimeStr = strTimeSlot.split(" - ")[0] + ":00";
        LocalTime time = LocalTime.parse(startTimeStr);

        AppointmentDAO appointmentDAO = new AppointmentDAO();

        // 2. Kiểm tra sức chứa tại thời điểm bấm Xác nhận đặt lịch (Concurrency Check)
        boolean isSlotAvailable = appointmentDAO.checkSlotAvailable(date, startTimeStr);
        if (!isSlotAvailable) {
            String errorMsg = URLEncoder.encode("Rất tiếc! Khung giờ " + strTimeSlot + " ngày " + strDate + " vừa được đăng ký hết chỗ. Vui lòng chọn khung giờ khác!", "UTF-8");
            response.sendRedirect("UIBookAppointment.jsp?date=" + strDate + "&error=" + errorMsg);
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
            response.sendRedirect("UIBookAppointment.jsp?date=" + strDate + "&error=" + errorMsg);
        }

    } catch (Exception e) {
        e.printStackTrace();
        String errorMsg = URLEncoder.encode("Dữ liệu nhập vào không hợp lệ: " + e.getMessage(), "UTF-8");
        response.sendRedirect("UIBookAppointment.jsp?error=" + errorMsg);
    }
%>