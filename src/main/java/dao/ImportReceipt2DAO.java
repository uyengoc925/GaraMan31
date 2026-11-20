package dao;

import model.ImportReceipt2;
import model.Supplier2;
import model.WarehouseStaff2;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ImportReceipt2DAO extends DAO {

    public ImportReceipt2DAO() {
        super();
    }

    public List<ImportReceipt2> getImportReceiptsBySupplier(int idSupplier, LocalDate startDate, LocalDate endDate) {
        List<ImportReceipt2> listReceipts = new ArrayList<>();

        String sql = "SELECT r.id, r.importDateTime, r.status, " +
                "       COALESCE(SUM(d.importQuantity), 0) AS totalQuantity, " +
                "       COALESCE(SUM(d.importQuantity * d.importUnitPrice), 0) AS totalImportAmount, " +
                "       p.id AS staffId, p.fullName AS staffName " +
                "FROM tblImportReceipt2 r " +
                "JOIN tblWarehouseStaff2 ws ON r.tblWarehouseStaff2id = ws.tblPerson2id " +
                "JOIN tblPerson2 p ON ws.tblPerson2id = p.id " +
                "LEFT JOIN tblImportReceiptDetail2 d ON d.tblImportReceipt2id = r.id " +
                "WHERE r.tblSupplier2id = ? " +
                "  AND r.status = 'Hoàn thành' " +
                "  AND r.importDateTime BETWEEN ? AND ? " +
                "GROUP BY r.id, r.importDateTime, r.status, p.id, p.fullName " +
                "ORDER BY r.importDateTime ASC, r.id ASC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idSupplier);
            ps.setDate(2, Date.valueOf(startDate));
            ps.setDate(3, Date.valueOf(endDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportReceipt2 receipt = new ImportReceipt2();
                    receipt.setId(rs.getInt("id"));
                    receipt.setImportDateTime(rs.getDate("importDateTime").toLocalDate().atStartOfDay());
                    receipt.setTotalQuantity(rs.getInt("totalQuantity"));
                    receipt.setTotalImportAmount(rs.getDouble("totalImportAmount"));
                    receipt.setStatus(rs.getString("status"));

                    WarehouseStaff2 staff = new WarehouseStaff2();
                    staff.setId(rs.getInt("staffId"));
                    staff.setFullName(rs.getString("staffName"));
                    receipt.setWarehouseStaff(staff);

                    listReceipts.add(receipt);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listReceipts;
    }

    public ImportReceipt2 getImportReceipt(int idImportReceipt) {
        ImportReceipt2 receipt = null;

        String sql = "SELECT r.id, r.importDateTime, r.status, " +
                "       COALESCE(SUM(d.importQuantity), 0) AS totalQuantity, " +
                "       COALESCE(SUM(d.importQuantity * d.importUnitPrice), 0) AS totalImportAmount, " +
                "       s.id AS supplierId, s.supplierName, s.address AS supplierAddress, " +
                "       s.phoneNumber AS supplierPhone, s.taxCode, " +
                "       p.id AS staffId, p.fullName AS staffName " +
                "FROM tblImportReceipt2 r " +
                "JOIN tblSupplier2 s ON r.tblSupplier2id = s.id " +
                "JOIN tblWarehouseStaff2 ws ON r.tblWarehouseStaff2id = ws.tblPerson2id " +
                "JOIN tblPerson2 p ON ws.tblPerson2id = p.id " +
                "LEFT JOIN tblImportReceiptDetail2 d ON d.tblImportReceipt2id = r.id " +
                "WHERE r.id = ? " +
                "GROUP BY r.id, r.importDateTime, r.status, " +
                "         s.id, s.supplierName, s.address, s.phoneNumber, s.taxCode, p.id, p.fullName";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idImportReceipt);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    receipt = new ImportReceipt2();
                    receipt.setId(rs.getInt("id"));
                    receipt.setImportDateTime(rs.getDate("importDateTime").toLocalDate().atStartOfDay());
                    receipt.setTotalQuantity(rs.getInt("totalQuantity"));
                    receipt.setTotalImportAmount(rs.getDouble("totalImportAmount"));
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return receipt;
    }
}