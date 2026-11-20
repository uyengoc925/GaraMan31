package model;

import java.time.LocalDate;

public class SupplierStatistics2 extends Supplier2 {
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer totalImportReceipts; // Tổng số lượt nhập hàng
    private Double totalImportValue;     // Tổng tiền nhập (VNĐ)
    private Integer totalImportQuantity;    // Số lượng linh kiện nhập

    public SupplierStatistics2() {
        super();
    }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Integer getTotalImportReceipts() { return totalImportReceipts; }
    public void setTotalImportReceipts(Integer totalImportQuantity) { this.totalImportReceipts = totalImportQuantity; }

    public Double getTotalImportValue() { return totalImportValue; }
    public void setTotalImportValue(Double totalImportValue) { this.totalImportValue = totalImportValue; }

    public Integer getTotalImportQuantity() { return totalImportQuantity; }
    public void setTotalImportQuantity(Integer totalImportQuantity) { this.totalImportQuantity = totalImportQuantity; }
}