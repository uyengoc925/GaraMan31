package dao;

import model.Customer2;
import java.sql.*;

public class Customer2DAO extends DAO {

    public Customer2DAO() {
        super();
    }

    public Customer2 findCustomer(Customer2 customer) {
        String sqlSearch = "SELECT p.* FROM tblPerson2 p JOIN tblCustomer2 c " +
                "ON p.id = c.tblPerson2id WHERE p.phoneNumber = ?";
        try{
            PreparedStatement psSearch = con.prepareStatement(sqlSearch);
            psSearch.setString(1, customer.getPhoneNumber());
            ResultSet rs = psSearch.executeQuery();
            if(rs.next()){
                Customer2 found = new Customer2();
                found.setId(rs.getInt("id"));
                found.setFullName(rs.getString("fullName"));
                found.setGender(rs.getString("gender"));
                found.setPhoneNumber(rs.getString("phoneNumber"));
                found.setEmail(rs.getString("email"));
                found.setAddress(rs.getString("address"));
                return found;
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    public int createCustomer(Customer2 customer2) {
        String sqlInsertPerson = "INSERT INTO tblPerson2 (fullName, gender, phoneNumber, email, address) VALUES (?, ?, ?, ?, ?)";
        String sqlInsertCustomer = "INSERT INTO tblCustomer2 (tblPerson2id) VALUES (?)";

        try {
            con.setAutoCommit(false);

            // 1. Thêm vào bảng tblPerson2 và lấy ID tự tăng
            PreparedStatement psPerson = con.prepareStatement(sqlInsertPerson, Statement.RETURN_GENERATED_KEYS);
            psPerson.setString(1, customer2.getFullName());
            psPerson.setString(2, customer2.getGender());
            psPerson.setString(3, customer2.getPhoneNumber());
            psPerson.setString(4, customer2.getEmail());
            psPerson.setString(5, customer2.getAddress());
            psPerson.executeUpdate();

            ResultSet generatedKeys = psPerson.getGeneratedKeys();
            int personId = -1;
            if (generatedKeys.next()) {
                personId = generatedKeys.getInt(1);
                customer2.setId(personId);
            }

            if (personId != -1) {
                PreparedStatement psCustomer = con.prepareStatement(sqlInsertCustomer);
                psCustomer.setInt(1, personId);
                psCustomer.executeUpdate();
                con.commit();
                con.setAutoCommit(true);
                return personId;
            }
            con.rollback();
            con.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return 0;
    }
}