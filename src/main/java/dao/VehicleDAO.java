package dao;

import model.Vehicle2;
import java.sql.*;

public class VehicleDAO extends DAO {

    public VehicleDAO() {
        super();
    }

    public Vehicle2 findOrCreateVehicle(Vehicle2 vehicle, int customerId) {
        // tìm xe
        String sqlSearch = "SELECT * FROM tblVehicle2 WHERE licensePlate = ?";
        try {
            PreparedStatement psSearch = con.prepareStatement(sqlSearch);
            psSearch.setString(1, vehicle.getLicensePlate());
            ResultSet rs = psSearch.executeQuery();
            if (rs.next()) {
                vehicle.setId(rs.getInt("id"));
                vehicle.setBrand(rs.getString("brand"));
                vehicle.setVehicleType(rs.getString("vehicleType"));
                vehicle.setColor(rs.getString("color"));
                return vehicle;
            }
            // không thấy thì thêm xe
            String sqlInsert = "INSERT INTO tblVehicle2(licensePlate, brand, vehicleType, color, description, tblCustomer2id) VALUES(?, ?, ?, ?, ?, ?)";
            PreparedStatement psInsert = con.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
            psInsert.setString(1, vehicle.getLicensePlate());
            psInsert.setString(2, vehicle.getBrand());
            psInsert.setString(3, vehicle.getVehicleType());
            psInsert.setString(4, vehicle.getColor());
            psInsert.setString(5, vehicle.getDescription());
            psInsert.setInt(6, customerId);
            psInsert.executeUpdate();

            ResultSet keys = psInsert.getGeneratedKeys();
            if (keys.next()) {
                vehicle.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vehicle;
    }
}