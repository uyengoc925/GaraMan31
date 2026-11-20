package model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Date;

public class Appointment2 {
    private int id;
    private Date date;
    private LocalTime time;
    private String status;
    private Customer2 customer;
    private Vehicle2 vehicle;
    private SalesStaff2 salesStaff;
    public Appointment2() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public LocalTime getTime() { return time; }
    public void setTime(LocalTime time) { this.time = time; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Customer2 getCustomer() { return customer; }
    public void setCustomer(Customer2 customer) { this.customer = customer; }

    public Vehicle2 getVehicle() { return vehicle; }
    public void setVehicle(Vehicle2 vehicle) { this.vehicle = vehicle; }

    public SalesStaff2 getSalesStaff() { return salesStaff; }
    public void setSalesStaff(SalesStaff2 salesStaff) { this.salesStaff = salesStaff; }
}