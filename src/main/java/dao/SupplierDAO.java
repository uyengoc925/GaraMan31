package dao;

import model.Supplier2;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SupplierDAO extends DAO {

    public SupplierDAO() {
        super();
    }

    public Supplier2 getSupplier(int idSupplier) {
        Supplier2 supplier = null;
        String sql = "SELECT * FROM tblSupplier2 WHERE id = ?";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idSupplier);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                supplier = new Supplier2();
                supplier.setId(rs.getInt("id"));
                supplier.setSupplierName(rs.getString("supplierName"));
                supplier.setPhoneNumber(rs.getString("phoneNumber"));
                supplier.setContactPerson(rs.getString("contactPerson"));
                supplier.setAddress(rs.getString("address"));
                supplier.setTaxCode(rs.getString("taxCode"));
                supplier.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return supplier;
    }
}