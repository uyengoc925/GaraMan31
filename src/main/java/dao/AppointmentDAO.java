package dao;

import model.Appointment2;
import model.TimeSlotDTO;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO extends DAO {

    public AppointmentDAO() {
        super();
    }
    // lấy thông tin lịch hẹn còn trống
    public List<TimeSlotDTO> getAvailableTimeSlots(LocalDate date) {
        List<TimeSlotDTO> slots = new ArrayList<>();
        String[] defaultSlots = {"08:00 - 10:00", "10:00 - 11:30", "13:30 - 15:30", "15:30 - 17:00"};

        String sql = "SELECT time, COUNT(*) as booked FROM tblAppointment2 WHERE date = ? AND time = ? GROUP BY time";
        for (String slot : defaultSlots) {
            String startTimeStr = slot.split(" - ")[0] + ":00";
            int count = 0;
            try {
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setDate(1, Date.valueOf(date));
                ps.setTime(2, Time.valueOf(startTimeStr));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    count = rs.getInt("booked");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            slots.add(new TimeSlotDTO(slot, count));
        }
        return slots;
    }
    // kiểm tra chỗ còn trống không
    public boolean checkSlotAvailable(LocalDate date, String timeStr) {
        String sql = "SELECT COUNT(*) as booked FROM tblAppointment2 WHERE date = ? AND time = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(date));
            ps.setTime(2, Time.valueOf(timeStr));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("booked") < 5;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
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