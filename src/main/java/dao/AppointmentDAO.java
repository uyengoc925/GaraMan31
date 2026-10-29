package dao;

import model.Appointment2;

import javax.print.DocFlavor;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class AppointmentDAO extends DAO {

    public AppointmentDAO() {
        super();
    }
    // lấy thông tin lịch hẹn còn trống
    public HashMap<String, Integer> getAvailableTimeSlot(java.sql.Date date) throws SQLException {
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

    // kiểm tra chỗ còn trống không
    public boolean checkSlotAvailable(java.time.LocalDate date, String startTime) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tblAppointment2 "
                + "WHERE `date` = ? AND `time` = ? AND status <> 'Đã hủy'";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(date));
            ps.setTime(2, java.sql.Time.valueOf(startTime));   // "08:00:00"
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) < 5;
            }
        }
    }
// tạo lịch hẹn
    public boolean createAppointment(Appointment2 appointment) {
        String sql = "INSERT INTO tblAppointment2(date, time, status, tblCustomer2id, tblVehicle2id) VALUES(?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, Date.valueOf(appointment.getDate()));
            ps.setTime(2, Time.valueOf(appointment.getTime()));
            ps.setString(3, appointment.getStatus());
            ps.setInt(4, appointment.getCustomer().getId());
            ps.setInt(5, appointment.getVehicle().getId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    appointment.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}