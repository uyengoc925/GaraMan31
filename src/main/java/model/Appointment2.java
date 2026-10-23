package model;

import java.time.LocalDate;
import java.time.LocalTime;

public class Appointment2 {
    private int id;
    private LocalDate date;
    private LocalTime time;
    private String status;
    private Customer2 customer;
    private Vehicle2 vehicle;

    public Appointment2() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getTime() { return time; }
    public void setTime(LocalTime time) { this.time = time; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Customer2 getCustomer() { return customer; }
    public void setCustomer(Customer2 customer) { this.customer = customer; }

    public Vehicle2 getVehicle() { return vehicle; }
    public void setVehicle(Vehicle2 vehicle) { this.vehicle = vehicle; }
}