package model;

public class Employee2 extends Person2 {
    private String username;
    private String password;
    private String position;

    public Employee2() {
        super();
    }

    public Employee2(Integer id, String fullName, String gender, String phoneNumber, String email, String address,
                     String username, String password, String position) {
        super(id, fullName, gender, phoneNumber, email, address);
        this.username = username;
        this.password = password;
        this.position = position;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}