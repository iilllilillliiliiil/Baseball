package project1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

public class HolidayDAO {
	private static final String JDBC_DRIVER = "org.h2.Driver";
	private static final String JDBC_URL = "jdbc:h2:tcp://localhost/~/test";

	public Connection open() throws Exception {
		Class.forName(JDBC_DRIVER);
		return DriverManager.getConnection(JDBC_URL, "sa", "1234");
	}

	// DB에서 공휴일 목록을 읽어옴
	public Set<LocalDate> getHolidays() {
		Set<LocalDate> holidays = new HashSet<>();
		String sql = "SELECT holiday_date FROM holiday";
		try (Connection conn = open();
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				holidays.add(rs.getDate("holiday_date").toLocalDate());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return holidays;
	}
}