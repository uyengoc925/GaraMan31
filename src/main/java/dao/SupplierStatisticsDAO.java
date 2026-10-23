package dao;

import model.SupplierStatistics2;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SupplierStatisticsDAO extends DAO {

    public SupplierStatisticsDAO() {
        super();
    }

    public List<SupplierStatistics2> getSupplierImportStatistics(LocalDate startDate, LocalDate endDate) {
        List<SupplierStatistics2> listStats = new ArrayList<>();

        String sql = "SELECT s.id, s.supplierName, s.phoneNumber, s.contactPerson, s.address, s.taxCode, s.status, " +
                "       COUNT(DISTINCT r.id) AS totalImportCount, " +
                "       COALESCE(SUM(d.importQuantity), 0) AS totalImportQuantity, " +
                "       COALESCE(SUM(d.subtotal), 0) AS totalImportValue " +
                "FROM tblSupplier2 s " +
                "JOIN tblImportReceipt2 r ON s.id = r.tblSupplier2id " +
                "JOIN tblImportReceiptDetail2 d ON r.id = d.tblImportReceipt2id " +
                "WHERE r.status = 'Hoàn thành' " +
                "  AND r.importDateTime >= ? " +
                "  AND r.importDateTime <= ? " +
                "GROUP BY s.id, s.supplierName, s.phoneNumber, s.contactPerson, s.address, s.taxCode, s.status " +
                "ORDER BY totalImportQuantity DESC";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, startDate.toString() + " 00:00:00");
            ps.setString(2, endDate.toString() + " 23:59:59");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SupplierStatistics2 stat = new SupplierStatistics2();
                stat.setId(rs.getInt("id"));
                stat.setSupplierName(rs.getString("supplierName"));
                stat.setPhoneNumber(rs.getString("phoneNumber"));
                stat.setContactPerson(rs.getString("contactPerson"));
                stat.setAddress(rs.getString("address"));
                stat.setTaxCode(rs.getString("taxCode"));
                stat.setStatus(rs.getString("status"));

                stat.setStartDate(startDate);
                stat.setEndDate(endDate);
                stat.setTotalImportCount(rs.getInt("totalImportCount"));
                stat.setTotalImportQuantity(rs.getInt("totalImportQuantity"));
                stat.setTotalImportValue(rs.getDouble("totalImportValue"));

                listStats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listStats;
    }
}