<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 예약 확인</title>
<style>
body {
	font-family: "Noto Sans KR", sans-serif;
	background: linear-gradient(to bottom, #dff1ff, #ffffff);
	margin: 0;
	padding: 0;
	text-align: center;
}

h1 {
	margin: 30px 0;
	font-size: 28px;
	color: #2c3e50;
}

.reserve-container {
	display: flex;
	justify-content: center;
	gap: 40px;
	margin-top: 40px;
}

.reserve-box {
	background: #fff;
	padding: 20px;
	border-radius: 15px;
	width: 280px;
	box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.15);
	text-align: center;
}

.reserve-label {
	font-weight: bold;
	font-size: 16px;
	margin-bottom: 12px;
	color: #444;
}

.reserve-value {
	font-size: 18px;
	color: #2c3e50;
}

.button-area {
	margin-top: 50px;
}

button {
	background-color: #e74c3c;
	color: white;
	border: none;
	padding: 14px 28px;
	font-size: 18px;
	border-radius: 10px;
	cursor: pointer;
	transition: 0.3s;
}

button:hover {
	background-color: #c0392b;
}

/* 에러 메시지 */
.error-message {
	color: red;
	margin-top: 20px;
	font-weight: bold;
}
</style>
</head>
<body>

	<h1>좌석 예약 확인</h1>
	<div class="reserve-container">
		<!-- 좌석 정보 -->
		<div class="reserve-box">
			<div class="reserve-label">선택한 좌석</div>
			<div class="reserve-value">${seat.section} ${seat.rowNum} -
				${seat.seatNum}</div>
		</div>

		<!-- 결제 금액 -->
		<div class="reserve-box">
			<div class="reserve-label">결제 금액</div>
			<div class="reserve-value">
				<c:choose>
					<c:when test="${not empty formattedPrice}">
                        ${formattedPrice}원
                    </c:when>
					<c:otherwise>
                        가격 정보를 불러올 수 없습니다.
                    </c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<!-- 예약 버튼 -->
	<div class="button-area">
		<form action="${pageContext.request.contextPath}/reserve"
			method="post">
			<input type="hidden" name="seatId" value="${seat.seatId}"> <input
				type="hidden" name="price" value="${price}">
			<button type="submit">예약 확정</button>
		</form>

	</div>

	<!-- 에러 메시지 출력 -->
	<c:if test="${not empty errorMessage}">
		<div class="error-message">${errorMessage}</div>
	</c:if>
</body>
</html>