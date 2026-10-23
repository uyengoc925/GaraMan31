package dao;

import model.Customer2;
import java.sql.*;

public class CustomerDAO extends DAO {

    public CustomerDAO() {
        super();
    }

    public Customer2 findOrCreateCustomer(Customer2 customer) {
        String sqlSearch = "SELECT p.id, p.fullName, p.gender, p.phoneNumber, p.email, p.address " +
                "FROM tblPerson2 p JOIN tblCustomer2 c ON p.id = c.tblPerson2id " +
                "WHERE p.phoneNumber = ?";
        try {
            PreparedStatement psSearch = con.prepareStatement(sqlSearch);
            psSearch.setString(1, customer.getPhoneNumber());
            ResultSet rs = psSearch.executeQuery();
            if (rs.next()) {
                customer.setId(rs.getInt("id"));
                customer.setFullName(rs.getString("fullName"));
                customer.setGender(rs.getString("gender"));
                return customer;
            }

            String sqlInsertPerson = "INSERT INTO tblPerson2(fullName, gender, phoneNumber, email, address) VALUES(?, ?, ?, ?, ?)";
            PreparedStatement psPerson = con.prepareStatement(sqlInsertPerson, Statement.RETURN_GENERATED_KEYS);
            psPerson.setString(1, customer.getFullName());
            psPerson.setString(2, customer.getGender());
            psPerson.setString(3, customer.getPhoneNumber());
            psPerson.setString(4, customer.getEmail());
            psPerson.setString(5, customer.getAddress());
            psPerson.executeUpdate();

            ResultSet generatedKeys = psPerson.getGeneratedKeys();
            if (generatedKeys.next()) {
                int personId = generatedKeys.getInt(1);
                customer.setId(personId);

                String sqlInsertCustomer = "INSERT INTO tblCustomer2(tblPerson2id) VALUES(?)";
                PreparedStatement psCustomer = con.prepareStatement(sqlInsertCustomer);
                psCustomer.setInt(1, personId);
                psCustomer.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }
}