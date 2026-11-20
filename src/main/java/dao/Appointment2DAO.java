package dao;

import model.Appointment2;

import java.sql.*;
import java.sql.PreparedStatement;
import java.util.HashMap;

public class Appointment2DAO extends DAO {

    public Appointment2DAO() {
        super();
    }
    // lấy thông tin cac lich hen con trong theo khung gio
    public HashMap<String, Integer> getAvailableTimeSlot(Date date) throws SQLException {
        HashMap<String, Integer> booked = new HashMap<>();
        String sql = "SELECT `time` AS start_time, COUNT(*) AS booked "
                + "FROM tblAppointment2 "
                + "WHERE `date` = ? AND status <> 'Đã hủy' "
                + "GROUP BY `time`";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    booked.put(rs.getTime("start_time").toString(), rs.getInt("booked"));
                }
            }
        }
        return booked;
    }

    // kiểm tra chỗ còn trống không - khi khach dat lich
    public boolean checkSlotAvailable(Date date, String  time) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tblAppointment2 "
                + "WHERE `date` = ? AND `time` = ? AND status <> 'Đã hủy'";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setTime(2, Time.valueOf(time));   // "08:00:00"00"
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) < 5;
            }
        }

    }
// tạo lịch hẹn
    public int createAppointment(Appointment2 appointment) {
        String sql = "INSERT INTO tblAppointment2(`date`, `time`, status, tblVehicle2id) VALUES(?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, new java.sql.Date(appointment.getDate().getTime()));
            ps.setTime(2, Time.valueOf(appointment.getTime()));
            ps.setString(3, appointment.getStatus());
            ps.setInt(4, appointment.getVehicle().getId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    appointment.setId(keys.getInt(1));
                }
                return appointment.getId();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public Appointment2 getAppointment(int id) {
        String sql = "SELECT a.id, a.date, a.time, a.status, " +
                     "p.id AS customer_id, p.fullName, p.phoneNumber, p.gender, p.email, p.address, " +
                     "v.id AS vehicle_id, v.licensePlate, v.brand, v.vehicleType, v.color, v.description " +
                     "FROM tblAppointment2 a " +
                     "JOIN tblVehicle2 v ON a.tblVehicle2id = v.id " +
                     "JOIN tblPerson2 p ON v.tblCustomer2id = p.id " +
                     "WHERE a.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Appointment2 appointment = new Appointment2();
                    appointment.setId(rs.getInt("id"));
                    appointment.setDate(rs.getDate("date"));
                    appointment.setTime(rs.getTime("time").toLocalTime());
                    appointment.setStatus(rs.getString("status"));

                    model.Customer2 customer = new model.Customer2();
                    customer.setId(rs.getInt("customer_id"));
                    customer.setFullName(rs.getString("fullName"));
                    customer.setPhoneNumber(rs.getString("phoneNumber"));
                    customer.setGender(rs.getString("gender"));
                    customer.setEmail(rs.getString("email"));
                    customer.setAddress(rs.getString("address"));
                    appointment.setCustomer(customer);

                    model.Vehicle2 vehicle = new model.Vehicle2();
                    vehicle.setId(rs.getInt("vehicle_id"));
                    vehicle.setLicensePlate(rs.getString("licensePlate"));
                    vehicle.setBrand(rs.getString("brand"));
                    vehicle.setVehicleType(rs.getString("vehicleType"));
                    vehicle.setColor(rs.getString("color"));
                    vehicle.setDescription(rs.getString("description"));
                    appointment.setVehicle(vehicle);

                    return appointment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}