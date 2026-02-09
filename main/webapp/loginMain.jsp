<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>메인 메뉴</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  * { box-sizing: border-box; }
  body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", Arial, sans-serif;
  color: #111827;

  /* 배경 이미지 추가 */
  background: url("images/screen.jpg") no-repeat center center fixed;
  background-size: cover;   /* 화면 꽉 채우기 */
}
  .container {
    width: 75%;
    margin: 40px auto;
    
   
  
  }

  .top {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    font-size: 14px;
    color: #374151;
    margin-bottom: 8px;
  }
  .top strong { font-weight: 700; }

  h1 {
    margin: 0 0 20px;
    text-align: center;
    font-size: 26px;
    letter-spacing: -0.2px;
  }

  /* 그리드: 2행 × 3칸 */
  .grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(220px, 1fr));
    gap: 24px;
  }

  /* ✅ 카드: 이미지 위에 텍스트 오버레이 */
  .card {
    position: relative;           /* 오버레이 기준점 */
    display: block;
    aspect-ratio: 1 / 1;          /* 정사각형 */
    background: #fff;
    border-radius: 18px;
    border: 1px solid #b9d1ff;
    overflow: hidden;
    text-decoration: none;
    color: inherit;
    box-shadow: 0 4px 14px rgba(0,0,0,0.06);
    transition: transform .16s ease, box-shadow .16s ease, border-color .16s ease;
    font-size: 1.1em;
  }
  .card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 28px rgba(0,0,0,0.12);
    border-color: #8fb4ff;
  }

  /* 이미지 영역 */
  .thumb {
    position: absolute;
    inset: 0;                     /* 카드 전체 채움 */
    background: #eef2ff;
  }
  .thumb img {
    width: 100%; height: 100%;
    display: block; object-fit: cover;
  }
  .thumb .ph {
    position: absolute; inset: 0;
    display: none; align-items: center; justify-content: center;
    color: #6b7280; font-weight: 700; background: #f1f5f9;
  }

  /* ✅ 어둡게 깔리는 그라데이션 (텍스트 가독성) */
  .shade {
    position: absolute;
    left: 0; right: 0; bottom: 0;
    height: 42%;
    background: linear-gradient(to top, rgba(0,0,0,.55), rgba(0,0,0,0));
    pointer-events: none;
  }

  /* ✅ 텍스트 라벨: 사진 위에 고정 */
  .label {
    position: absolute;
    left: 16px; right: 16px; bottom: 14px;
    color: #fff;                  /* 흰색 글자 */
    display: flex; align-items: center; justify-content: space-between;
    font-weight: 800;
    text-shadow: 0 1px 2px rgba(0,0,0,.35);
  }
  .name { font-weight: 800; }
  .chev { opacity: .9; font-size: 1.2em; }

  @media (max-width: 900px) {
    .grid { grid-template-columns: repeat(2, minmax(220px, 1fr)); }
  }
  @media (max-width: 520px) {
    .container { width: 95%; }
    .grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
  <div class="container">
    <div class="topbar" style="position:sticky; top:0; z-index:10;">
      <div style="display:flex; justify-content:flex-end; align-items:center; gap:10px; padding:10px 12px; font-size:14px; color:#374151;">
        <span><strong><%= String.valueOf(session.getAttribute("loginUser")) %></strong> 님</span>
        <span class="live-dot" title="로그인 중" aria-label="로그인 중"
              style="width:8px;height:8px;border-radius:999px;background:#16a34a;display:inline-block;"></span>
        <span class="muted" style="color:#6b7280;">로그인 중</span>
        <button type="button" onclick="location.href='loginBefore.jsp'"
                style="margin-left:8px; padding:6px 10px; border:1px solid #cbd5e1; background:#fff; border-radius:8px; cursor:pointer;">
          로그아웃
        </button>
      </div>
    </div>

    <h1>야구장 서비스 메뉴</h1>

    <div class="grid">
      <!-- 1 -->
      <a class="card" href="a.jsp">
        <div class="thumb">
          <img src="images/login.jpg" alt="로그인/회원 가입/회원정보"
               onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
          <div class="ph">이미지 준비중</div>
        </div>
        <div class="shade"></div>
        <div class="label"><span class="name">1. 회원정보</span><span class="chev">›</span></div>
      </a>

      <!-- 2 -->
      <a class="card" href="index.jsp">
        <div class="thumb">
          <img src="images/team.jpg" alt="팀, 경기, 구단 정보"
               onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
          <div class="ph">이미지 준비중</div>
        </div>
        <div class="shade"></div>
        <div class="label"><span class="name">2. 팀 · 경기 · 구단 관리자 정보</span><span class="chev">›</span></div>
      </a>

      <!-- 3 -->
      <a class="card" href="<%=request.getContextPath()%>/seats">
        <div class="thumb">
          <img src="images/stadium.jpg" alt="티켓 예매"
               onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
          <div class="ph">이미지 준비중</div>
        </div>
        <div class="shade"></div>
        <div class="label"><span class="name">3. 티켓 예매</span><span class="chev">›</span></div>
      </a>

      <!-- 4 -->
      <a class="card" href="ProductOrder3.jsp">
        <div class="thumb">
          <img src="images/shop.jpg" alt="쇼핑"
               onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
          <div class="ph">이미지 준비중</div>
        </div>
        <div class="shade"></div>
        <div class="label"><span class="name">4. 굿즈, 쇼핑</span><span class="chev">›</span></div>
      </a>

      <!-- 5 -->
      <a class="card" href="FoodInfo.jsp">
        <div class="thumb">
          <img src="images/food.jpg" alt="음식"
               onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
          <div class="ph">이미지 준비중</div>
        </div>
        <div class="shade"></div>
        <div class="label"><span class="name">5. 음식</span><span class="chev">›</span></div>
      </a>

      <!-- 6 -->
      <a class="card" href="f.jsp">
        <div class="thumb">
          <img src="images/parking.jpg" alt="관리자"
               onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
          <div class="ph">이미지 준비중</div>
        </div>
        <div class="shade"></div>
        <div class="label"><span class="name">6. 이름없음</span><span class="chev">›</span></div>
      </a>
    </div>
  </div>
</body>
</html>
