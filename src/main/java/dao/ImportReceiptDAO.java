package dao;

import model.ImportReceipt2;
import model.Supplier2;
import model.WarehouseStaff2;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ImportReceiptDAO extends DAO {

    public ImportReceiptDAO() {
        super();
    }

    public List<ImportReceipt2> getImportReceiptsBySupplier(int idSupplier, LocalDate startDate, LocalDate endDate) {
        List<ImportReceipt2> listReceipts = new ArrayList<>();

        String sql = "SELECT r.id, r.importDateTime, r.totalImportAmount, r.totalQuantity, r.status, " +
                "       p.id AS staffId, p.fullName AS staffName " +
                "FROM tblImportReceipt2 r " +
                "JOIN tblWarehouseStaff2 ws ON r.tblWarehouseStaff2id = ws.tblPerson2id " +
                "JOIN tblPerson2 p ON ws.tblPerson2id = p.id " +
                "WHERE r.tblSupplier2id = ? " +
                "  AND r.status = 'Hoàn thành' " +
                "  AND r.importDateTime >= ? " +
                "  AND r.importDateTime <= ? " +
                "ORDER BY r.importDateTime ASC";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idSupplier);
            ps.setString(2, startDate.toString() + " 00:00:00");
            ps.setString(3, endDate.toString() + " 23:59:59");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ImportReceipt2 receipt = new ImportReceipt2();
                receipt.setId(rs.getInt("id"));
                receipt.setImportDateTime(rs.getTimestamp("importDateTime").toLocalDateTime());
                receipt.setTotalImportAmount(rs.getDouble("totalImportAmount"));
                receipt.setTotalQuantity(rs.getInt("totalQuantity")); // Lấy trực tiếp từ cột totalQuantity
                receipt.setStatus(rs.getString("status"));

                WarehouseStaff2 staff = new WarehouseStaff2();
                staff.setId(rs.getInt("staffId"));
                staff.setFullName(rs.getString("staffName"));
                receipt.setWarehouseStaff(staff);

                listReceipts.add(receipt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listReceipts;
    }

    public ImportReceipt2 getImportReceipt(int idImportReceipt) {
        ImportReceipt2 receipt = null;

        String sql = "SELECT r.id, r.importDateTime, r.totalImportAmount, r.status, " +
                "       COALESCE(SUM(d.importQuantity), 0) AS totalQuantity, " +
                "       s.id AS supplierId, s.supplierName, s.address AS supplierAddress, s.phoneNumber AS supplierPhone, s.taxCode, " +
                "       p.id AS staffId, p.fullName AS staffName " +
                "FROM tblImportReceipt2 r " +
                "LEFT JOIN tblImportReceiptDetail2 d ON r.id = d.tblImportReceipt2id " +
                "JOIN tblSupplier2 s ON r.tblSupplier2id = s.id " +
                "JOIN tblWarehouseStaff2 ws ON r.tblWarehouseStaff2id = ws.tblPerson2id " +
                "JOIN tblPerson2 p ON ws.tblPerson2id = p.id " +
                "WHERE r.id = ? " +
                "GROUP BY r.id, r.importDateTime, r.totalImportAmount, r.status, " +
                "         s.id, s.supplierName, s.address, s.phoneNumber, s.taxCode, p.id, p.fullName";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idImportReceipt);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                receipt = new ImportReceipt2();
                receipt.setId(rs.getInt("id"));
                receipt.setImportDateTime(rs.getTimestamp("importDateTime").toLocalDateTime());
                receipt.setTotalImportAmount(rs.getDouble("totalImportAmount"));
                receipt.setTotalQuantity(rs.getInt("totalQuantity")); // Set tổng số lượng
                receipt.setStatus(rs.getString("status"));

                Supplier2 supplier = new Supplier2();
                supplier.setId(rs.getInt("supplierId"));
                supplier.setSupplierName(rs.getString("supplierName"));
                supplier.setAddress(rs.getString("supplierAddress"));
                supplier.setPhoneNumber(rs.getString("supplierPhone"));
                supplier.setTaxCode(rs.getString("taxCode"));
                receipt.setSupplier(supplier);

                WarehouseStaff2 staff = new WarehouseStaff2();
                staff.setId(rs.getInt("staffId"));
                staff.setFullName(rs.getString("staffName"));
                receipt.setWarehouseStaff(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return receipt;
    }
}