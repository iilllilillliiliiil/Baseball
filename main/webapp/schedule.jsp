<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="project.model.GameDto" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>삼성 라이온즈 잔여 홈 경기 일정</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f8ff;
            text-align: center;
            padding: 30px;
        }
        h1 {
            color: #0033a0;
            margin-bottom: 20px;
        }
        table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 80%;
            background-color: #ffffff;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #0033a0;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f0f4ff;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px;
            background-color: #0033a0;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }
        .button:hover {
            background-color: #0055ff;
        }
    </style>
</head>
<body>
<%
    // 세션 기반으로 관리자 여부 체크
    boolean isAdmin = false;
    if (session != null && "admin".equals(session.getAttribute("role"))) {
        isAdmin = true;
    }

    // 경기 리스트 가져오기
    List<GameDto> games = (List<GameDto>) request.getAttribute("games");
%>

<h1>삼성 라이온즈 잔여 홈 경기 일정</h1>

<table border="1">
    <tr>
        <th>날짜</th>
        <th>시간</th>
        <th>상대팀</th>
        <th>구장</th>
        <% if (isAdmin) { %>
            <th>관리</th>
        <% } %>
    </tr>
    <%
        int i = 0;
        if (games != null && !games.isEmpty()) {
            for (GameDto g : games) {
    %>
    <tr>
        <td><%= g.getDate() %></td>
        <td><%= g.getTime() %></td>
        <td><%= g.getOpponent() %></td>
        <td><%= g.getStadium() %></td>
        <% if (isAdmin) { %>
        <td>
            <!-- 삭제 버튼 -->
            <form action="<%= request.getContextPath() %>/schedule" method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="index" value="<%= i %>">
                <button type="submit">삭제</button>
            </form>
        </td>
        <% } %>
    </tr>
    <%
                i++;
            }
        } else {
    %>
    <tr>
        <td colspan="<%= isAdmin ? 5 : 4 %>">잔여 홈 경기가 없습니다.</td>
    </tr>
    <% } %>
</table>

<% if (isAdmin) { %>
<h2>경기 추가</h2>
<form action="<%= request.getContextPath() %>/schedule" method="post">
    <input type="hidden" name="action" value="add">
    날짜: <input type="date" name="date" required>
    시간: <input type="time" name="time" required>
    상대팀: <input type="text" name="opponent" required>
    구장: <input type="text" name="stadium" value="대구 삼성 라이온즈 파크">
    <button type="submit">추가</button>
</form>
<% } %>

<br>
<a class="button" href="<%= request.getContextPath() %>/index.jsp">구단 정보로 돌아가기</a>
<a class="button" href="<%= request.getContextPath() %>/loginMain.jsp">처음 화면으로 돌아가기</a>

<%-- 로그인/로그아웃 버튼 --%>
<%
    if (isAdmin) {
%>
    <form action="<%= request.getContextPath() %>/logout" method="post">
        <button type="submit" class="button">로그아웃</button>
    </form>
<%
    } else {
%>
    <a href="<%= request.getContextPath() %>/login.jsp" class="button">관리자 로그인</a>
<% } %>

</body>
</html>
