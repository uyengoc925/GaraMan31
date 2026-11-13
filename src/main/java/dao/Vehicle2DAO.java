package dao;

import model.Vehicle2;
import java.sql.*;

public class VehicleDAO extends DAO {

    public VehicleDAO() {
        super();
    }

    public Vehicle2 findVehicle(Vehicle2 vehicle, int customerId) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vehicle;
    }
}
/*
Hiện tại tôi đổi ý chỉ cần tìm xe không cần tạo xe - tách tìm xe và tạo xe ra 2 hàm riêng biệt. Nếu tìm thấy xe thì trả về xe đó, nếu không tìm thấy thì trả về null. Nếu muốn tạo xe thì gọi hàm createVehicle(Vehicle2 vehicle, int customerId) để tạo xe mới.
 */