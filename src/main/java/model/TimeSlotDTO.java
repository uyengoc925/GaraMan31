package model;

public class TimeSlotDTO {
    private String timeSlot; // VD: "08:00 - 10:00"
    private int bookedCount;
    private int capacity = 5;
    private String status;    // "Còn trống" hoặc "Đã đầy"

    public TimeSlotDTO(String timeSlot, int bookedCount) {
        this.timeSlot = timeSlot;
        this.bookedCount = bookedCount;
        this.status = (bookedCount >= capacity) ? "Đã đầy" : "Còn trống";
    }

    public String getTimeSlot() { return timeSlot; }
    public int getBookedCount() { return bookedCount; }
    public int getCapacity() { return capacity; }
    public String getStatus() { return status; }
}