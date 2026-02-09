package project1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

	private static final String JDBC_DRIVER = "org.h2.Driver";
	private static final String JDBC_URL = "jdbc:h2:tcp://localhost/~/jwbookdb";

	public Connection open() throws Exception {
		Class.forName(JDBC_DRIVER);
		return DriverManager.getConnection(JDBC_URL, "jwbook", "1234");
	}

    // 모든 좌석 조회 (List<SeatDTO>로 리턴)
    public List<SeatDTO> getAllSeats() {
        List<SeatDTO> seats = new ArrayList<>();

        String sql = "SELECT seat_id, row_num, seat_num, section, is_reserved FROM seat ORDER BY section, row_num, seat_num";

        try {
            conn = open();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                SeatDTO seat = new SeatDTO();
                seat.setSeatId(rs.getInt("seat_id"));
                seat.setRowNum(rs.getInt("row_num"));
                seat.setSeatNum(rs.getInt("seat_num"));
                seat.setSection(rs.getString("section"));
                seat.setReserved(rs.getBoolean("is_reserved"));
                seats.add(seat);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return seats;
    }
}