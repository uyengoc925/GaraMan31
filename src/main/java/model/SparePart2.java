package model;

public class SparePart2 {
    private Integer id;
    private String partName;
    private String unit;
    private Double unitPrice;
    private Integer minimumStock;
    private Integer actualStock;
    private String description;
    private String status;

    public SparePart2() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public Double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(Double unitPrice) { this.unitPrice = unitPrice; }

    public Integer getMinimumStock() { return minimumStock; }
    public void setMinimumStock(Integer minimumStock) { this.minimumStock = minimumStock; }

    public Integer getActualStock() { return actualStock; }
    public void setActualStock(Integer actualStock) { this.actualStock = actualStock; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}