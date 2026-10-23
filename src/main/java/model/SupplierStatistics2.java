package model;

import java.time.LocalDate;

public class SupplierStatistics2 extends Supplier2 {
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer totalImportQuantity; // Tổng số lượng phụ tùng
    private Double totalImportValue;     // Tổng tiền nhập (VNĐ)
    private Integer totalImportCount;    // Số lượt nhập

    public SupplierStatistics2() {
        super();
    }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Integer getTotalImportQuantity() { return totalImportQuantity; }
    public void setTotalImportQuantity(Integer totalImportQuantity) { this.totalImportQuantity = totalImportQuantity; }

    public Double getTotalImportValue() { return totalImportValue; }
    public void setTotalImportValue(Double totalImportValue) { this.totalImportValue = totalImportValue; }

    public Integer getTotalImportCount() { return totalImportCount; }
    public void setTotalImportCount(Integer totalImportCount) { this.totalImportCount = totalImportCount; }
}