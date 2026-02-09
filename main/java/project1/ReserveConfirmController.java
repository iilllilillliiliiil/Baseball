package project1;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// 예약 확정 시 좌석을 DB에서 막고, 좌석 목록으로 리다이렉트
@WebServlet({"/reserve", "/reserveConfirm"})
public class ReserveConfirmController extends HttpServlet {
	private final ReservationService reservationService = new ReservationService();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		long seatId = Long.parseLong(request.getParameter("seatId"));
		long memberId = 1L; // 로그인 미구현, 임시값
		long gameId = 1L; // 임시값
		int paidPrice = Integer.parseInt(request.getParameter("paidPrice"));

		// 좌석 예약 시도
		boolean success = reservationService.reserveSeat(memberId, gameId, seatId, paidPrice);

		if (success) {
			// 성공 시 좌석 목록으로 리다이렉트 (SeatListController)
			response.sendRedirect(request.getContextPath() + "/seats");
		} else {
			// 실패 시 에러 메시지와 함께 이전 페이지로 이동
			request.setAttribute("errorMsg", "이미 예약된 좌석이거나 결제 금액이 올바르지 않습니다.");
			// 좌석 정보 다시 조회
			SeatDAO seatDAO = new SeatDAO();
			SeatDTO seat = null;
			for (SeatDTO s : seatDAO.getAllSeats()) {
				if (s.getSeatId() == seatId) {
					seat = s;
					break;
				}
			}
			request.setAttribute("seat", seat);
			request.setAttribute("seatId", seatId);
			request.setAttribute("paidPrice", paidPrice);
			request.getRequestDispatcher("/reserve.jsp").forward(request, response);
		}
	}

	// GET 요청(좌석 클릭 시) 처리 추가
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 좌석 ID 파라미터 받기
		String seatIdParam = request.getParameter("seatId");
		if (seatIdParam == null) {
			response.sendRedirect(request.getContextPath() + "/seats");
			return;
		}
		int seatId = Integer.parseInt(seatIdParam);

		// 좌석 정보 조회
		SeatDAO seatDAO = new SeatDAO();
		SeatDTO seat = null;
		for (SeatDTO s : seatDAO.getAllSeats()) {
			if (s.getSeatId() == seatId) {
				seat = s;
				break;
			}
		}
		if (seat == null) {
			response.sendRedirect(request.getContextPath() + "/seats");
			return;
		}

		// 가격 정보 조회
		ReservationService reservationService = new ReservationService();
		int price = reservationService.getSeatPrice(seatId);
		String formattedPrice = String.format("%,d", price);

		// JSP로 전달
		request.setAttribute("seat", seat);
		request.setAttribute("seatId", seatId);
		request.setAttribute("price", price);
		request.setAttribute("formattedPrice", formattedPrice);

		request.getRequestDispatcher("/pay.jsp").forward(request, response);
	}
}