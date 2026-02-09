package project1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReservationDAO {
	private static final String JDBC_DRIVER = "org.h2.Driver";
	private static final String JDBC_URL = "jdbc:h2:tcp://localhost/~/test";

	public Connection open() throws Exception {
		Class.forName(JDBC_DRIVER);
		return DriverManager.getConnection(JDBC_URL, "sa", "1234");
	}

	// 가격을 반환하는 메서드
	public int getSeatPrice(long seatId, String dayType) {
		String priceSql = "SELECT price FROM ticket_price WHERE section=(SELECT section FROM seat WHERE seat_id=?) AND day_type=?";
		try (Connection conn = open(); PreparedStatement ps = conn.prepareStatement(priceSql)) {
			ps.setLong(1, seatId);
			ps.setString(2, dayType);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -10000; // 가격 조회 실패
	}

	// 결제 금액이 맞는지 확인 후 예매
	public boolean reserveSeat(long memberId, long gameId, long seatId, String dayType, int paidPrice) {
		String priceSql = "SELECT price FROM ticket_price WHERE section=(SELECT section FROM seat WHERE seat_id=?) AND day_type=?";
		String checkReservedSql = "SELECT is_reserved FROM seat WHERE seat_id=?";
		String insertSql = "INSERT INTO reservation(member_id, game_id, seat_id, day_type, total_price) VALUES(?,?,?,?,?)";
		String updateSql = "UPDATE seat SET is_reserved=true WHERE seat_id=?";
		try (Connection conn = open()) {
			conn.setAutoCommit(false);

			// 1. 이미 예매된 좌석인지 확인
			try (PreparedStatement ps = conn.prepareStatement(checkReservedSql)) {
				ps.setLong(1, seatId);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
					boolean isReserved = rs.getBoolean(1);
					if (isReserved) {
						conn.rollback();
						return false; // 이미 예매된 좌석
					}
				} else {
					conn.rollback();
					return false; // 좌석 없음
				}
			}

			// 2. 가격 확인
			int price;
			try (PreparedStatement ps = conn.prepareStatement(priceSql)) {
				ps.setLong(1, seatId);
				ps.setString(2, dayType);
				ResultSet rs = ps.executeQuery();
				if (!rs.next()) {
					conn.rollback();
					return false;
				}
				price = rs.getInt(1);
			}

			// 결제 금액이 실제 가격과 다르면 실패
			if (price != paidPrice) {
				conn.rollback();
				return false;
			}

			try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
				ps.setLong(1, memberId);
				ps.setLong(2, gameId);
				ps.setLong(3, seatId);
				ps.setString(4, dayType);
				ps.setInt(5, price);
				ps.executeUpdate();
			}

			try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
				ps.setLong(1, seatId);
				ps.executeUpdate();
			}

			conn.commit();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}