package dao;

import model.ImportReceiptDetail2;
import model.SparePart2;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImportReceiptDetai2DAO extends DAO {

    public ImportReceiptDetai2DAO() {
        super();
    }

    public List<ImportReceiptDetail2> getImportReceiptDetail(int idImportReceipt) {
        List<ImportReceiptDetail2> listDetails = new ArrayList<>();

        String sql = "SELECT d.id, d.importQuantity, d.importUnitPrice, " +
                "       sp.id AS partId, sp.partName, sp.unit " +
                "FROM tblImportReceiptDetail2 d " +
                "JOIN tblSparePart2 sp ON d.tblSparePart2id = sp.id " +
                "WHERE d.tblImportReceipt2id = ? " +
                "ORDER BY d.id";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idImportReceipt);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ImportReceiptDetail2 detail = new ImportReceiptDetail2();
                detail.setId(rs.getInt("id"));
                detail.setImportQuantity(rs.getInt("importQuantity"));
                detail.setImportUnitPrice(rs.getDouble("importUnitPrice"));

                SparePart2 part = new SparePart2();
                part.setId(rs.getInt("partId"));
                part.setPartName(rs.getString("partName"));
                part.setUnit(rs.getString("unit"));

                detail.setSparePart(part);
                listDetails.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listDetails;
    }
}