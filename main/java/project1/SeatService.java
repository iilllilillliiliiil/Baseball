package project1;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SeatService {
	private SeatDAO seatDAO = new SeatDAO();

	// DB에서 전체 좌석 불러오기
	public List<SeatDTO> getAllSeats() {
		return seatDAO.getAllSeats();
	}

	// 섹션별 레이아웃 생성 (컨트롤러에서 seatsBySection 이름으로 받음)
	public Map<String, List<List<SeatDTO>>> getSeatsBySection() {
		List<SeatDTO> seats = seatDAO.getAllSeats();
		Map<String, List<List<SeatDTO>>> layout = new LinkedHashMap<>();

		// VIP (6시 방향, 맨 밑 3줄 x 10좌석 → 1~30)
		List<List<SeatDTO>> vip = new ArrayList<>();
		for (int i = 0; i < 3; i++)
			vip.add(new ArrayList<>());

		// 3루 (왼쪽, 10줄 x 3좌석 → 31~60)
		List<List<SeatDTO>> thirdBase = new ArrayList<>();
		for (int i = 0; i < 10; i++)
			thirdBase.add(new ArrayList<>());

		// 1루 (오른쪽, 10줄 x 3좌석 → 61~90)
		List<List<SeatDTO>> firstBase = new ArrayList<>();
		for (int i = 0; i < 10; i++)
			firstBase.add(new ArrayList<>());

		// FAMILY (12시 방향, 맨 위 2줄 x 5좌석 → 91~100)
		List<List<SeatDTO>> family = new ArrayList<>();
		for (int i = 0; i < 2; i++)
			family.add(new ArrayList<>());

		// 분류 작업
		for (SeatDTO seat : seats) {
			String section = seat.getSection();
			int row = seat.getRowNum() - 1;
			
			if ("VIP".equals(section)) { // VIP
				if (row >= 0 && row < vip.size()) {
					vip.get(row).add(seat);
				}
			} else if ("3루".equals(section)) { // 3루
				if (row >= 0 && row < thirdBase.size()) {
					thirdBase.get(row).add(seat);
				}
			} else if ("1루".equals(section)) { // 1루
				if (row >= 0 && row < firstBase.size()) {
					firstBase.get(row).add(seat);
				}
			} else if ("family".equals(section)) { // FAMILY
				if (row >= 0 && row < family.size()) {
					family.get(row).add(seat);
				}
			}
		}

		layout.put("VIP", vip);
		layout.put("3루", thirdBase);
		layout.put("1루", firstBase);
		layout.put("family", family);

		return layout;
	}
}