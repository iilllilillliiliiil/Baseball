<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>삼성 라이온즈 구단 소개</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', 'Malgun Gothic', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f8ff 0%, #e8f0ff 100%);
            min-height: 100vh;
            color: #333;
        }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .header {
            text-align: center;
            padding: 40px 0;
            background: linear-gradient(135deg, #0033a0 0%, #0055ff 100%);
            color: white;
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0, 51, 160, 0.3);
        }
        .header h1 { font-size: 3.5rem; font-weight: 700; margin-bottom: 15px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .header .subtitle { font-size: 1.3rem; opacity: 0.9; font-weight: 300; }
        .main-content { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 40px; }
        .info-section {
            background: white; padding: 30px; border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .info-section:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0,0,0,0.15); }
        .info-section h2 {
            color: #0033a0; font-size: 2rem; margin-bottom: 20px;
            border-bottom: 3px solid #0033a0; padding-bottom: 10px;
        }
        .info-section p { font-size: 1.1rem; line-height: 1.8; color: #555; margin-bottom: 15px; }
        .stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 20px; }
        .stat-item {
            text-align: center; padding: 20px; background: #f8f9ff;
            border-radius: 15px; border: 2px solid #e0e7ff;
        }
        .stat-number { font-size: 2.5rem; font-weight: 700; color: #0033a0; display: block; }
        .stat-label { font-size: 0.9rem; color: #666; margin-top: 5px; }
        .logo-section { text-align: center; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
        .logo-placeholder {
            width: 200px; height: 200px; background: linear-gradient(135deg, #0033a0, #0055ff);
            border-radius: 50%; margin: 0 auto 20px; display: flex; align-items: center;
            justify-content: center; color: white; font-size: 3rem; font-weight: bold;
            box-shadow: 0 10px 30px rgba(0,51,160,0.3);
        }
        .cta-section { text-align: center; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
        .schedule-button {
            display: inline-block; padding: 18px 36px;
            background: linear-gradient(135deg, #0033a0 0%, #0055ff 100%);
            color: white; text-decoration: none; border-radius: 50px; font-size: 1.2rem;
            font-weight: 600; transition: all 0.3s ease; box-shadow: 0 8px 25px rgba(0,51,160,0.3);
            position: relative; overflow: hidden;
        }
        .schedule-button:hover { transform: translateY(-3px); box-shadow: 0 15px 35px rgba(0,51,160,0.4); }
        .schedule-button::before {
            content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent); transition: left 0.5s;
        }
        .schedule-button:hover::before { left: 100%; }
        .footer { text-align: center; padding: 30px; color: #666; font-size: 0.9rem; }
        @media (max-width: 768px) {
            .main-content { grid-template-columns: 1fr; gap: 20px; }
            .header h1 { font-size: 2.5rem; }
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<%
    // 내장 session 객체 사용
    boolean isAdmin = false;
    if (session != null && "admin".equals(session.getAttribute("role"))) {
        isAdmin = true;
    }
%>

<div class="container">
    <div class="header">
        <h1>삼성 라이온즈 🦁</h1>
        <p class="subtitle">대구를 연고로 한 KBO 리그의 전통의 명문 구단</p>
       
    </div>

    <div class="main-content">
        <div class="info-section">
            <h2>구단 소개</h2>
            <p>삼성 라이온즈는 1982년 창단된 KBO 리그의 전통의 명문 구단입니다. 대구광역시를 연고지로 하며, 삼성라이온즈파크를 홈구장으로 사용하고 있습니다.</p>
            <p>KBO 리그에서 두번째로 가장 많은 우승을 차지한 구단으로, 우리나라 사상첫 통합우승 4연패를 달성하였으며 팬들의 열정과 함께 한국 야구의 발전을 이끌어왔습니다.</p>
            <div class="stats-grid">
                <div class="stat-item"><span class="stat-number">8</span><span class="stat-label">KBO 우승</span></div>
                <div class="stat-item"><span class="stat-number">1982</span><span class="stat-label">창단년도</span></div>
                <div class="stat-item"><span class="stat-number">대구</span><span class="stat-label">연고지</span></div>
                <div class="stat-item"><span class="stat-number">삼성라이온즈</span><span class="stat-label">구단명</span></div>
            </div>
        </div>

        <div class="logo-section">
            <div class="logo-placeholder">🦁</div>
            <h1>삼성 라이온즈</h1>
            <p>전통과 명예를 자랑하는<br>한국 야구의 대표 구단</p>
        </div>
    </div>

    <div class="cta-section">
        <h2>홈 경기 일정 확인하기</h2>
        <p>삼성 라이온즈의 홈 경기 일정을 확인하고 응원하러 가세요!</p>
        <a href="<%= request.getContextPath() %>/schedule" class="schedule-button">잔여 홈 경기 일정 보기 📅</a>
    </div>

    <div class="footer">
        <p>© 2024 삼성 라이온즈. 모든 권리 보유.</p>
    </div>
</div>
</body>
</html>
