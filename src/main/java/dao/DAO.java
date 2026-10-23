package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {
    protected Connection con;

    public DAO() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/garaman_db?useSSL=false&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "123456";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}