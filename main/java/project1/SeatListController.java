package project1;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/seats")
public class SeatListController extends HttpServlet {
	private SeatService seatService = new SeatService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 인원수 파라미터 읽기 (최소 1, 최대 8, 없으면 인원수 선택 페이지로 리다이렉트)
		String personCountParam = request.getParameter("personCount");
		int personCount = 0;
		try {
			if (personCountParam != null && !personCountParam.isEmpty()) {
				personCount = Integer.parseInt(personCountParam);
				if (personCount < 1)
					personCount = 1;
				if (personCount > 8)
					personCount = 8;
			}
		} catch (Exception e) {
			personCount = 0;
		}
		if (personCount == 0) {
			// 인원수 선택 페이지로 이동
			response.sendRedirect(request.getContextPath() + "/personCountSelect.jsp");
			return;
		}

		// DB에서 구역별 좌석 정보 가져오기
		Map<String, List<List<SeatDTO>>> seatsBySection = seatService.getSeatsBySection();

		// JSP로 전달
		request.setAttribute("seatsBySection", seatsBySection);
		request.setAttribute("personCount", personCount);

		// seats.jsp로 포워딩
		request.getRequestDispatcher("/seats.jsp").forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    // 선택한 좌석들
	    String seatIdsParam = request.getParameter("seatIds");
	    String personCountParam = request.getParameter("personCount");

	    int personCount = 0;
	    try {
	        if (personCountParam != null && !personCountParam.isEmpty()) {
	            personCount = Integer.parseInt(personCountParam);
	        }
	    } catch (Exception e) {
	        personCount = 0;
	    }

	    // seatIdsParam이 null이거나 빈 문자열이면 다시 인원수 선택으로
	    if (personCount == 0 || seatIdsParam == null || seatIdsParam.trim().isEmpty()) {
	        response.sendRedirect(request.getContextPath() + "/personCountSelect.jsp");
	        return;
	    }

	    // seatIds를 배열로 변환
	    String[] selectedSeats = seatIdsParam.split(",");
	    if (selectedSeats.length == 0) {
	        response.sendRedirect(request.getContextPath() + "/personCountSelect.jsp");
	        return;
	    }

	    // 선택한 좌석과 인원 수를 pay.jsp로 넘김
	    request.setAttribute("personCount", personCount);
	    request.setAttribute("selectedSeats", selectedSeats);

	    request.getRequestDispatcher("/pay.jsp").forward(request, response);
	}
}