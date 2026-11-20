package dao;

import model.Vehicle2;
import java.sql.*;

public class Vehicle2DAO extends DAO {

    public Vehicle2DAO() {
        super();
    }
    // 1. Tìm xe theo biển số
    public Vehicle2 findVehicle(Vehicle2 vehicle, int customerId) {
        Vehicle2 foundVehicle = null;
        String sql = "SELECT * FROM tblVehicle2 WHERE licensePlate = ? AND tblCustomer2id = ?";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, vehicle.getLicensePlate());
            ps.setInt(2, customerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                foundVehicle = new Vehicle2();
                foundVehicle.setId(rs.getInt("id"));
                foundVehicle.setLicensePlate(rs.getString("licensePlate"));
                foundVehicle.setVehicleType(rs.getString("vehicleType"));
                foundVehicle.setColor(rs.getString("color"));
                foundVehicle.setDescription(rs.getString("description"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return foundVehicle;
    }
    public int createVehicle(Vehicle2 vehicle, int customerId) {
        String sqlInsert = "INSERT INTO tblVehicle2 (licensePlate, brand, vehicleType, color, description, tblCustomer2id) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            // Sử dụng RETURN_GENERATED_KEYS để lấy ID tự tăng
            PreparedStatement psInsert = con.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
            psInsert.setString(1, vehicle.getLicensePlate());
            psInsert.setString(2, vehicle.getBrand());
            psInsert.setString(3, vehicle.getVehicleType());
            psInsert.setString(4, vehicle.getColor());
            psInsert.setString(5, vehicle.getDescription());
            psInsert.setInt(6, customerId);

            int affectedRows = psInsert.executeUpdate();
            if( affectedRows > 0){
                ResultSet generatedKeys = psInsert.getGeneratedKeys();
                if (generatedKeys.next()) {
                    vehicle.setId(generatedKeys.getInt(1));
                }
                return vehicle.getId();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


}
