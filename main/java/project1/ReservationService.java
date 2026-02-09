package project1;

import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.Set;

public class ReservationService {
	private final ReservationDAO reservationDAO = new ReservationDAO();
	private final HolidayDAO holidayDAO = new HolidayDAO();

	// 오늘 날짜 기준으로 요일/공휴일 판단 (공휴일은 DB에서 읽어옴)
	public String getDayTypeForToday() {
		LocalDate today = LocalDate.now();
		DayOfWeek dayOfWeek = today.getDayOfWeek();
		Set<LocalDate> holidays = holidayDAO.getHolidays();
		if (dayOfWeek == DayOfWeek.FRIDAY || dayOfWeek == DayOfWeek.SATURDAY || dayOfWeek == DayOfWeek.SUNDAY || holidays.contains(today)) {
			return "주말/공휴일";
		} else {
			return "주중";
		}
	}

	// 가격 조회
	public int getSeatPrice(long seatId) {
		String dayType = getDayTypeForToday();
		return reservationDAO.getSeatPrice(seatId, dayType);
	}

	// 결제 금액을 받아 예매
	public boolean reserveSeat(long memberId, long gameId, long seatId, int paidPrice) {
		String dayType = getDayTypeForToday();
		return reservationDAO.reserveSeat(memberId, gameId, seatId, dayType, paidPrice);
	}
}