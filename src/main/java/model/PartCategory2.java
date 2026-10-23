package model;

import java.util.List;

public class PartCategory2 {
    private Integer id;
    private String categoryName;
    private String description;
    private String status;
    private List<SparePart2> spareParts;

    public PartCategory2() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<SparePart2> getSpareParts() { return spareParts; }
    public void setSpareParts(List<SparePart2> spareParts) { this.spareParts = spareParts; }
}