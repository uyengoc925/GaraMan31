package dao;

import model.SupplierStatistics2;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SupplierStatistics2DAO extends DAO {

    public SupplierStatistics2DAO() {
        super();
    }

    public List<SupplierStatistics2> getSupplierImportStatistics(LocalDate startDate, LocalDate endDate) {
        List<SupplierStatistics2> listStats = new ArrayList<>();

        String sql = "SELECT s.id, s.supplierName, s.phoneNumber, s.contactPerson, s.address, s.taxCode, s.status, " +
                "       COUNT(DISTINCT r.id) AS totalImportReceipts, " +
                "       COALESCE(SUM(d.importQuantity), 0) AS totalImportQuantity, " +
                "       COALESCE(SUM(d.importQuantity * d.importUnitPrice), 0) AS totalImportValue " +
                "FROM tblSupplier2 s " +
                "JOIN tblImportReceipt2 r ON s.id = r.tblSupplier2id " +
                "JOIN tblImportReceiptDetail2 d ON r.id = d.tblImportReceipt2id " +
                "WHERE r.status = 'Hoàn thành' " +
                "  AND r.importDateTime BETWEEN ? AND ? " +
                "GROUP BY s.id, s.supplierName, s.phoneNumber, s.contactPerson, s.address, s.taxCode, s.status " +
                "ORDER BY totalImportQuantity DESC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = ps.executeQuery()) {
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
                    stat.setTotalImportReceipts(rs.getInt("totalImportReceipts"));
                    stat.setTotalImportQuantity(rs.getInt("totalImportQuantity"));
                    stat.setTotalImportValue(rs.getDouble("totalImportValue"));

                    listStats.add(stat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listStats;
    }
}