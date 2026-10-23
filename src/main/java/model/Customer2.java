package model;

import java.util.List;

public class Customer2 extends Person2 {
    private List<Vehicle2> vehicles;

    public Customer2() {
        super();
    }

    public List<Vehicle2> getVehicles() { return vehicles; }
    public void setVehicles(List<Vehicle2> vehicles) { this.vehicles = vehicles; }
}