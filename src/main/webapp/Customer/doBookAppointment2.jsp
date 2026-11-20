<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.Appointment2DAO, dao.Customer2DAO, dao.Vehicle2DAO" %>
<%@ page import="model.Appointment2, model.Customer2, model.Vehicle2" %>
<%@ page import="java.time.LocalDate, java.time.LocalTime" %>
<%@ page import="java.sql.Date" %>
<%!
    // Quay lại form đặt lịch, giữ nguyên dữ liệu đã nhập (forward cùng request)
    private void back(HttpServletRequest request, HttpServletResponse response, String msg) throws Exception {
        request.setAttribute("errorMessage", msg);
        request.getRequestDispatcher("ViewBookAppointment2.jsp").forward(request, response);
    }
%>
<%
    request.setCharacterEncoding("UTF-8");

    // Chỉ chấp nhận phương thức POST
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("ViewBookAppointment2.jsp");
        return;
    }

    String strDate = null;
    try {
        // 1. Thu thập dữ liệu từ Form
        strDate = request.getParameter("inSelectedDate");
        if (strDate == null || strDate.trim().isEmpty() || "null".equalsIgnoreCase(strDate.trim())) {
            strDate = request.getParameter("date");
        }
        if (strDate == null || strDate.trim().isEmpty() || "null".equalsIgnoreCase(strDate.trim())) {
            strDate = LocalDate.now().toString();
        }
        strDate = strDate.trim();
        Date date = Date.valueOf(strDate);
        String strTimeSlot = request.getParameter("radTimeSlot");

        String fullName = request.getParameter("txtFullName");
        String gender = request.getParameter("cboGender");
        String phoneNumber = request.getParameter("txtPhoneNumber");
        String licensePlate = request.getParameter("txtLicensePlate");
        String brand = request.getParameter("txtBrand");
        String vehicleType = request.getParameter("txtVehicleType");
        String color = request.getParameter("txtColor");

        if (strDate == null || strTimeSlot == null || fullName == null || phoneNumber == null || licensePlate == null) {
            back(request, response, "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            return;
        }
        if (!phoneNumber.matches("[0-9]{10}") || phoneNumber.charAt(0) != '0') {
            back(request, response, "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0!");
            return;
        }

        String plate = Vehicle2.normalizeLicensePlate(licensePlate);
        if (plate == null) {
            back(request, response, "Biển số xe không hợp lệ! Ví dụ đúng: 30H-123.45 hoặc 30LD-123.45");
            return;
        }
        String startTimeStr = strTimeSlot.split(" - ")[0] + ":00";
        LocalTime time = LocalTime.parse(startTimeStr);

        Appointment2DAO appointmentDAO = new Appointment2DAO();

        // 2. Kiểm tra sức chứa tại thời điểm bấm Xác nhận đặt lịch (Concurrency Check)
        boolean isSlotAvailable = appointmentDAO.checkSlotAvailable(date, startTimeStr);
        if (!isSlotAvailable) {
            back(request, response, "Rất tiếc! Khung giờ " + strTimeSlot + " ngày " + strDate
                    + " vừa được đăng ký hết chỗ. Vui lòng chọn khung giờ khác!");
            return;
        }

        // 3. Tìm hoặc Tạo mới Khách hàng
        Customer2DAO customerDAO = new Customer2DAO();
        Customer2 customerParam = new Customer2();
        customerParam.setFullName(fullName);
        customerParam.setGender(gender);
        customerParam.setPhoneNumber(phoneNumber);
        Customer2 customer = customerDAO.findCustomer(customerParam);

        if(customer == null) {
            customer = customerParam;
            int customerId = customerDAO.createCustomer(customer);
            if(customerId == 0){
                throw new Exception("Không thể tạo khách hàng");
            }
            else{
                customer.setId(customerId);
            }
        }
        // 4. Tìm hoặc Tạo mới Phương tiện
        Vehicle2 vehicle = new Vehicle2();
        vehicle.setLicensePlate(plate);          // dùng biển số đã chuẩn hóa
        vehicle.setBrand(brand);
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color);

        Vehicle2DAO vehicleDAO = new Vehicle2DAO();
        Vehicle2 foundVehicle = vehicleDAO.findVehicle(vehicle, customer.getId());
        if(foundVehicle == null) {
            int vehicleId = vehicleDAO.createVehicle(vehicle, customer.getId());
            vehicle.setId(vehicleId);
        } else {
            vehicle = foundVehicle;
        }

        // 5. Khởi tạo đối tượng Lịch hẹn ở trạng thái "Chờ tiếp nhận"
        Appointment2 appointment = new Appointment2();
        appointment.setDate(date);
        appointment.setTime(time);
        appointment.setStatus("Chờ tiếp nhận");
        appointment.setCustomer(customer);
        appointment.setVehicle(vehicle);

        // 6. Thực hiện lưu chứng từ Lịch hẹn vào CSDL
        int isSuccess = appointmentDAO.createAppointment(appointment);

        if (isSuccess != 0) {
            session.setAttribute("createdAppointment", isSuccess); // appointmentId
            response.sendRedirect("ViewConfirmAppointment2.jsp");
        } else {
            back(request, response, "Lỗi hệ thống! Không thể khởi tạo lịch hẹn.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        back(request, response, "Dữ liệu nhập vào không hợp lệ: " + e.getMessage());
    }
%>