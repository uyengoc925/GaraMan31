package model;

public class ImportReceiptDetail2 {
    private Integer id;
    private Integer importQuantity;
    private Double importUnitPrice;
    private SparePart2 sparePart;

    public ImportReceiptDetail2() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getImportQuantity() { return importQuantity; }
    public void setImportQuantity(Integer importQuantity) { this.importQuantity = importQuantity; }

    public Double getImportUnitPrice() { return importUnitPrice; }
    public void setImportUnitPrice(Double importUnitPrice) { this.importUnitPrice = importUnitPrice; }

    public SparePart2 getSparePart() { return sparePart; }
    public void setSparePart(SparePart2 sparePart) { this.sparePart = sparePart; }
}