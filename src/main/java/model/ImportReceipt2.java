package model;

import java.time.LocalDateTime;
import java.util.List;

public class ImportReceipt2 {
    private Integer id;
    private LocalDateTime importDateTime;
    private Double totalImportAmount;
    private Integer totalQuantity;
    private String status;
    private Supplier2 supplier;
    private WarehouseStaff2 warehouseStaff;
    private List<ImportReceiptDetail2> importReceiptDetails;

    public ImportReceipt2() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public LocalDateTime getImportDateTime() { return importDateTime; }
    public void setImportDateTime(LocalDateTime importDateTime) { this.importDateTime = importDateTime; }

    public Double getTotalImportAmount() { return totalImportAmount; }
    public void setTotalImportAmount(Double totalImportAmount) { this.totalImportAmount = totalImportAmount; }

    public Integer getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(Integer totalQuantity) { this.totalQuantity = totalQuantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Supplier2 getSupplier() { return supplier; }
    public void setSupplier(Supplier2 supplier) { this.supplier = supplier; }

    public WarehouseStaff2 getWarehouseStaff() { return warehouseStaff; }
    public void setWarehouseStaff(WarehouseStaff2 warehouseStaff) { this.warehouseStaff = warehouseStaff; }

    public List<ImportReceiptDetail2> getImportReceiptDetails() { return importReceiptDetails; }
    public void setImportReceiptDetails(List<ImportReceiptDetail2> importReceiptDetails) { this.importReceiptDetails = importReceiptDetails; }
}