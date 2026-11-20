package dao;
import model.Employee2;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class Employee2DAO extends DAO {
    public Employee2DAO(){
        super();

    }
    public boolean CheckLogin(Employee2 employee2){
       boolean result = false;
       if (employee2.getUsername() == null || employee2.getPassword() == null) return false;
       if(employee2.getUsername().contains("true") ||
           employee2.getUsername().contains("=")||
                  employee2.getPassword().contains("true")||
       employee2.getPassword().contains("=")) return false;
        String sql = "SELECT p.id, p.fullName, p.gender, p.phoneNumber, p.email, p.address, " +
                     "e.username, e.password, e.position " +
                     "FROM tblEmployee2 e " +
                     "JOIN tblPerson2 p ON e.tblPerson2id = p.id " +
                     "WHERE e.username = ? AND e.password = ?";
        try{
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, employee2.getUsername());
            ps.setString(2, employee2.getPassword());
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                employee2.setId(rs.getInt("id"));
                employee2.setFullName(rs.getString("fullName"));
                employee2.setGender(rs.getString("gender"));
                employee2.setPhoneNumber(rs.getString("phoneNumber"));
                employee2.setEmail(rs.getString("email"));
                employee2.setAddress(rs.getString("address"));
                employee2.setUsername(rs.getString("username"));
                employee2.setPassword(rs.getString("password"));
                employee2.setPosition(rs.getString("position"));
                result = true;
            }
        }catch (SQLException e){
            e.printStackTrace();
            result = false;
        }
        return result;
    }
}

