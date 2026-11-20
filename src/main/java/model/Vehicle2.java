package model;

public class Vehicle2 {
    private int id;
    private String licensePlate;
    private String brand;
    private String vehicleType;
    private String color;
    private String description;

    public Vehicle2() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    // Trả về biển số chuẩn hóa dạng 30H-123.45, hoặc null nếu không hợp lệ
    public static String normalizeLicensePlate(String input) {
        if (input == null) return null;
        String s = input.replaceAll("[\\s.\\-]", "").toUpperCase(java.util.Locale.ROOT);
        java.util.regex.Matcher m = java.util.regex.Pattern
                .compile("^(\\d{2})([A-Z]{1,2})(\\d{3})(\\d{2})$").matcher(s);
        if (!m.matches()) return null;
        return m.group(1) + m.group(2) + "-" + m.group(3) + "." + m.group(4);
    }
}