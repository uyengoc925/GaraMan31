package model;

import java.util.List;

public class Supplier2 {
    private Integer id;
    private String supplierName;
    private String phoneNumber;
    private String contactPerson;
    private String address;
    private String taxCode;
    private String status;
    private List<ImportReceipt2> importReceipts;

    public Supplier2() {}

    public Supplier2(Integer id, String supplierName, String phoneNumber, String contactPerson,
                     String address, String taxCode, String status) {
        this.id = id;
        this.supplierName = supplierName;
        this.phoneNumber = phoneNumber;
        this.contactPerson = contactPerson;
        this.address = address;
        this.taxCode = taxCode;
        this.status = status;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getTaxCode() { return taxCode; }
    public void setTaxCode(String taxCode) { this.taxCode = taxCode; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<ImportReceipt2> getImportReceipts() { return importReceipts; }
    public void setImportReceipts(List<ImportReceipt2> importReceipts) { this.importReceipts = importReceipts; }
}