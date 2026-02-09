package baseballSystem.Controller;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodDAO {

    Connection conn = null;       
    PreparedStatement pstmt;       

    private static final String JDBC_DRIVER = "org.h2.Driver";
    private static final String JDBC_URL    = "jdbc:h2:tcp://localhost/~/jwbookdb";
    private static final String JDBC_USER   = "jwbook";
    private static final String JDBC_PASS   = "1234";

    public void open() {
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            if(conn != null) System.out.println("연결 성공!");
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void close() {
        try {
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }
    //INSERT 구간 대소문자 정확히
    public void insert(FoodOrder s) {
        open(); 
        String sql = "INSERT INTO FOODS(FOOD_NAME, PRICE, QUANTITY) VALUES(?,?,?)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, s.getFoodName());
            pstmt.setInt(2, s.getPrice());
            pstmt.setInt(3, s.getFoodOrderNumber());
           
           // pstmt.setString(4, s.getDate());
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
    }

    public List<FoodOrder> getAll() {
        open(); 
        List<FoodOrder> foodOrderList = new ArrayList<>();
        try {
            pstmt = conn.prepareStatement("SELECT * FROM FOODS");
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()) {
                FoodOrder s = new FoodOrder();
                s.setId(rs.getLong("FOOD_ID"));
                s.setFoodName(rs.getString("FOOD_NAME"));
                s.setPrice(rs.getInt("PRICE"));
                s.setFoodOrderNumber(rs.getInt("QUANTITY"));
                
                //s.setDate(rs.getString("date"));
                foodOrderList.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { close(); }
        return foodOrderList;
    }
}
