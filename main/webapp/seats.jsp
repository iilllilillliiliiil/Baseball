<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 선택</title>
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Orbit&display=swap')
	;

body {
	background: linear-gradient(to bottom, #d1e9ff, #ffffff);
	font-family: 'Do Hyeon', sans-serif;
	margin: 0;
	padding: 20px;
}

h1 {
	text-align: center;
	font-size: 36px;
	font-family: 'Orbit', sans-serif;
	margin-bottom: 40px;
	color: #00274d;
}

.stadium {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 60px;
}

.seat {
	width: 45px;
	height: 45px;
	margin: 2px;
	border-radius: 8px;
	cursor: pointer;
	font-size: 12px;
	font-weight: bold;
	border: none;
	transition: transform 0.2s, opacity 0.2s;
}

.seat.selected {
	outline: 3px solid #2563eb;
	box-shadow: 0 0 0 2px #fff, 0 0 0 5px #2563eb;
}

.seat:hover {
	transform: scale(1.1);
	opacity: 0.9;
}

.available {
	background-color: #4CAF50;
	color: white;
}

.reserved {
	background-color: #9e9e9e;
	color: #eeeeee;
	cursor: not-allowed;
}

.family .seat.available {
	background-color: #ffb74d;
}

.vip .seat.available {
	background-color: #e91e63;
}

.first-base .seat.available {
	background-color: #2196f3;
}

.third-base .seat.available {
	background-color: #8bc34a;
}

.section-title {
	font-size: 26px;
	font-weight: bold;
	margin-bottom: 10px;
	text-align: center;
	padding: 5px 15px;
	border-radius: 12px;
	color: white;
}

.family .section-title {
	background-color: #ff9800;
}

.vip .section-title {
	background-color: #ad1457;
}

.first-base .section-title {
	background-color: #1976d2;
}

.third-base .section-title {
	background-color: #558b2f;
}

.center-section {
	display: flex;
	flex-direction: column;
	align-items: center;
}

.side-sections {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	width: 80%;
	margin: 40px 0;
}

.side {
	display: flex;
	flex-direction: column;
	align-items: center;
}

.seat-grid {
	display: grid;
	gap: 10px;
}

#selectedInfo {
	margin: 30px auto 0;
	text-align: center;
	font-size: 18px;
	color: #2563eb;
}

#seatForm {
	text-align: center;
	margin-top: 30px;
}

#seatForm button[type="submit"] {
	background: #2563eb;
	color: #fff;
	font-size: 20px;
	border: none;
	border-radius: 10px;
	padding: 12px 32px;
	cursor: pointer;
	transition: background 0.2s;
}

#seatForm button[type="submit"]:hover {
	background: #1e40af;
}
</style>
</head>
<body>
	<%
	// 인원수 파라미터 처리 (최소 1, 최대 8)
	int personCount = 1;
	try {
		String pc = request.getParameter("personCount");
		if (pc != null && !pc.isEmpty()) {
			personCount = Integer.parseInt(pc);
			if (personCount < 1)
		personCount = 1;
			if (personCount > 8)
		personCount = 8;
		}
	} catch (Exception e) {
		personCount = 1;
	}
	%>
	<h1>⚾ 좌석 선택</h1>
	<div id="selectedInfo">
		선택 인원 : <strong><%=personCount%></strong>명<br> 좌석을 <span
			id="seatCountText"></span> 선택하세요.
	</div>
	<form id="seatForm" action="${pageContext.request.contextPath}/seats"
		method="post">
		<input type="hidden" name="personCount" value="<%=personCount%>">
		<input type="hidden" id="selectedSeatsInput" name="seatIds" value="">
		<div class="stadium">
			<!-- Family -->
			<div class="center-section family">
				<div class="section-title">FAMILY</div>
				<div class="seat-grid"
					style="grid-template-columns: repeat(5, 40px);">
					<c:forEach var="row" items="${seatsBySection['family']}">
						<c:forEach var="seat" items="${row}">
							<c:choose>
								<c:when test="${seat.reserved}">
									<button type="button" class="seat reserved" disabled>
										${seat.rowNum} - ${seat.seatNum}</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="seat available"
										data-seat-id="${seat.seatId}" data-section="family"
										data-row="${seat.rowNum}" data-num="${seat.seatNum}">
										${seat.rowNum} - ${seat.seatNum}</button>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:forEach>
				</div>
			</div>
			<!-- 3루 & 1루 -->
			<div class="side-sections">
				<div class="side third-base">
					<div class="section-title">3루</div>
					<div class="seat-grid"
						style="grid-template-columns: repeat(3, 40px);">
						<c:forEach var="row" items="${seatsBySection['3루']}">
							<c:forEach var="seat" items="${row}">
								<c:choose>
									<c:when test="${seat.reserved}">
										<button type="button" class="seat reserved" disabled>
											${seat.rowNum} - ${seat.seatNum}</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="seat available"
											data-seat-id="${seat.seatId}" data-section="3루"
											data-row="${seat.rowNum}" data-num="${seat.seatNum}">
											${seat.rowNum} - ${seat.seatNum}</button>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</c:forEach>
					</div>
				</div>
				<div class="side first-base">
					<div class="section-title">1루</div>
					<div class="seat-grid"
						style="grid-template-columns: repeat(3, 40px);">
						<c:forEach var="row" items="${seatsBySection['1루']}">
							<c:forEach var="seat" items="${row}">
								<c:choose>
									<c:when test="${seat.reserved}">
										<button type="button" class="seat reserved" disabled>
											${seat.rowNum} - ${seat.seatNum}</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="seat available"
											data-seat-id="${seat.seatId}" data-section="1루"
											data-row="${seat.rowNum}" data-num="${seat.seatNum}">
											${seat.rowNum} - ${seat.seatNum}</button>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</c:forEach>
					</div>
				</div>
			</div>
			<!-- VIP -->
			<div class="center-section vip">
				<div class="section-title">VIP</div>
				<div class="seat-grid"
					style="grid-template-columns: repeat(10, 40px);">
					<c:forEach var="row" items="${seatsBySection['VIP']}">
						<c:forEach var="seat" items="${row}">
							<c:choose>
								<c:when test="${seat.reserved}">
									<button type="button" class="seat reserved" disabled>
										${seat.rowNum} - ${seat.seatNum}</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="seat available"
										data-seat-id="${seat.seatId}" data-section="VIP"
										data-row="${seat.rowNum}" data-num="${seat.seatNum}">
										${seat.rowNum} - ${seat.seatNum}</button>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:forEach>
				</div>
			</div>
		</div>
		<div style="margin-top: 30px;">
			<button type="submit" id="submitBtn" disabled>예약 확인</button>
		</div>
	</form>
	<script>
(function(){
	const personCount = <%=personCount%>;
	const seatButtons = document.querySelectorAll('.seat.available');
	const selectedSeats = [];
	const selectedInfo = document.getElementById('selectedInfo');
	const selectedSeatsInput = document.getElementById('selectedSeatsInput');
	const submitBtn = document.getElementById('submitBtn');
	const seatCountText = document.getElementById('seatCountText');

	// 패밀리존은 4명당 1좌석, 나머지는 인원수만큼
	function getMaxSelectable(section) {
		if(section === 'family') {
			return Math.ceil(personCount / 4);
		}
		return personCount;
	}
	let currentSection = null; // 선택 중인 구역(섹션) 고정

	// 안내문구 갱신
	function updateSeatCountText() {
		if(currentSection === 'family') {
			seatCountText.textContent = "최대 " + getMaxSelectable('family') + "개 (패밀리존: 4명당 1좌석)";
		} else if(currentSection) {
			seatCountText.textContent = "최대 " + getMaxSelectable(currentSection) + "개";
		} else {
			seatCountText.textContent = "최대 " + personCount + "개";
		}
	}
	updateSeatCountText();

	seatButtons.forEach(btn => {
		btn.addEventListener('click', function(){
			const seatId = this.dataset.seatId;
			const section = this.dataset.section;

			// 첫 선택이면 섹션 고정
			if(selectedSeats.length === 0) {
				currentSection = section;
				updateSeatCountText();
			}
			// 다른 섹션 클릭 시 안내
			if(section !== currentSection) {
				alert('한 번에 한 구역(섹션)만 선택할 수 있습니다.');
				return;
			}
			const maxSelectable = getMaxSelectable(section);

			const idx = selectedSeats.indexOf(seatId);
			if(idx >= 0) {
				// 선택 해제
				selectedSeats.splice(idx, 1);
				this.classList.remove('selected');
			} else {
				if(selectedSeats.length >= maxSelectable) {
					alert('최대 ' + maxSelectable + '개까지 선택할 수 있습니다.');
					return;
				}
				selectedSeats.push(seatId);
				this.classList.add('selected');
			}
			// 선택 없으면 섹션 초기화
			if(selectedSeats.length === 0) {
				currentSection = null;
				updateSeatCountText();
			}
			selectedSeatsInput.value = selectedSeats.join(',');
			submitBtn.disabled = selectedSeats.length !== getMaxSelectable(currentSection || section);
		});
	});

	// 폼 제출 시 선택 개수 체크
	document.getElementById('seatForm').addEventListener('submit', function(e){
		const max = getMaxSelectable(currentSection);
		if(selectedSeats.length !== max) {
			alert('좌석을 ' + max + '개 선택해야 합니다.');
			e.preventDefault();
		}
	});
})();
</script>
</body>
</html>