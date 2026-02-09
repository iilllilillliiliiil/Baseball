<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인원수 선택</title>
<style>
body {
	background: linear-gradient(to bottom, #d1e9ff, #ffffff);
	font-family: 'Do Hyeon', sans-serif;
	margin: 0;
	padding: 0;
}

.select-container {
	max-width: 400px;
	margin: 80px auto 0;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.10);
	padding: 36px 32px 32px 32px;
	text-align: center;
}

.select-container h1 {
	font-size: 32px;
	margin-bottom: 18px;
	color: #00274d;
}

.select-container label {
	font-size: 20px;
	font-weight: bold;
}

.select-container select {
	font-size: 18px;
	padding: 8px 16px;
	border-radius: 8px;
	border: 1px solid #bcd;
	margin: 18px 0 24px 0;
}

.select-container button {
	background: #2563eb;
	color: #fff;
	font-size: 18px;
	border: none;
	border-radius: 10px;
	padding: 12px 32px;
	cursor: pointer;
	transition: background 0.2s;
}

.select-container button:hover {
	background: #1e40af;
}
</style>
</head>
<body>
	<div class="select-container">
		<h1>인원수 선택</h1>
		<form action="${pageContext.request.contextPath}/seats" method="get">
			<label for="personCount">예약 인원</label><br> <select
				id="personCount" name="personCount" required>
				<c:forEach var="i" begin="1" end="8">
					<option value="${i}">${i}명</option>
				</c:forEach>
			</select> <br>
			<button type="submit">좌석 선택하기</button>
		</form>
	</div>
</body>
</html>