<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>물품 주문</title>
<style>
  :root { --bd:#e5e7eb; --muted:#6b7280; --bg:#f8fafc; --hover:#eef2f7; }
  body { font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", sans-serif; margin:24px; }
  h2 { margin-bottom:16px; }

  /* 레이아웃: [좌 스페이서 3cm] | [이미지 10cm] | [이미지-카탈로그 4.5cm] | [카탈로그 260px] | [카탈로그-주문 3cm] | [주문 320px] */
  .layout {
    display: grid;
    grid-template-columns: 3cm 10cm 9cm 260px 1.5cm 340px; /* ← 11.5cm 에서 7cm 줄여 전체를 왼쪽으로 이동 */
    align-items: start;
  }

  .panel { border:1px solid var(--bd); border-radius:10px; background:#fff; }
  .panel .hd { padding:12px 14px; border-bottom:1px solid var(--bd); font-weight:600; }
  .panel .bd { padding:12px 14px; }

  /* 링크 이미지 박스: 위로 5cm, 왼쪽으로 3cm 이동 (기존 6cm 아래, 3cm 오른쪽 → 1cm 아래, 0 왼쪽) */
  .center-wrap { margin-left: 0; margin-top: 1cm; }
  .image-slot { width: 10cm; height: 5cm; }
  .image-card {
    width: 10cm; height: 5cm;
    border:1px dashed #cbd5e1; border-radius:12px; background:#f9fafb;
    display:flex; align-items:center; justify-content:center; overflow:hidden;
  }
  .image-card a { display:inline-block; width:100%; height:100%; }
  .image-card img { width:100%; height:100%; object-fit: contain; display:block; border-radius:8px; }
  .image-help { text-align:left; font-size:12px; color:var(--muted); margin-top:8px; }

  .catalog { list-style:none; margin:0; padding:0; max-height:360px; overflow:auto; }
  .vstack { display:flex; flex-direction:column; gap:12px; }
  .field label { font-size:12px; color:#374151; display:block; margin-bottom:6px; }
  
  
  input[type="text"], input[type="number"], input[type="date"], select { 
  width:90%; 
  padding:10px; 
  border:1px solid #d1d5db; 
  border-radius:8px; }
  
 /
  
  .readonly-chip { background:#f3f4f6; border:1px dashed #cbd5e1; padding:8px 10px; border-radius:8px; color:#374151; }
  .btn { cursor:pointer; border:1px solid #cbd5e1; background:var(--bg); border-radius:8px; padding:10px 12px; }
  .btn:hover { background:var(--hover); }

  table { width:100%; border-collapse:collapse; margin-top:16px; }
  th, td { border:1px solid var(--bd); padding:8px; text-align:left; }
  th { background:#f9fafb; }
  .right { text-align:right; }
  .muted { color:var(--muted); font-size:12px; }
  .section-title { margin-top:28px; margin-bottom:8px; font-weight:600; }
</style>
</head>
<body>
<!-- [FIX] 로그인 상태 표시 + 로그아웃 -->
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

<h2>물품 주문</h2>

<!-- 주문 입력 폼 -->
<form id="orderForm" method="post" action="${pageContext.request.contextPath}/ProductOrder?action=order">
  <div class="layout">
    <!-- [0] 좌 스페이서 3cm -->
    <div></div>

    <!-- [1] 링크 이미지 (상단 5cm↑, 좌측 3cm← 적용 완료) -->
    <div class="center-wrap">
      <div class="image-slot">
        <div class="image-card">
          <!-- 링크/이미지 URL만 교체 -->
          <a id="promoLink" href="https://example.com" target="_blank" aria-label="프로모션 이미지 링크">
            <img id="promoImg" src="https://via.placeholder.com/1280x640.png?text=10cm+x+5cm+Link+Image" alt="링크 이미지">
          </a>
        </div>
        <div class="image-help">링크/이미지 변경: <code>#promoLink</code>의 <code>href</code>, <code>#promoImg</code>의 <code>src</code>.</div>
      </div>
    </div>

    <!-- [2] 이미지-카탈로그 간 스페이서 4.5cm (두 패널을 7cm 왼쪽으로) -->
    <div></div>

    <!-- [3] 카탈로그 패널 -->
    <div class="panel">
      <div class="hd">물품 목록(클릭하여 선택)</div>
      <div class="bd">
        <label for="nameSelect" class="muted" style="display:block;margin-bottom:6px;">물품 선택</label>
        <select id="nameSelect">
          <option value="">-- 물품을 선택하세요 --</option>
        </select>
        <div class="muted" style="margin-top:8px;">목록에서 물품을 클릭하면 오른쪽에 선택됩니다.</div>
        <ul id="catalog" class="catalog" aria-label="물품 목록"></ul>
      </div>
    </div>

    <!-- [4] 카탈로그-주문 정보 간 스페이서 3cm(변경 없음) -->
    <div></div>

    <!-- [5] 주문 정보 -->
    <div class="panel">
      <div class="hd">주문 정보</div>
      <div class="bd">
        <input type="hidden" id="name" />
        <div class="vstack">
          <div class="field">
            <label>선택된 물품</label>
            <div id="nameDisplay" class="readonly-chip">아직 선택되지 않음</div>
          </div>
          <div class="field">
            <label for="qty">수량</label>
            <input type="number" id="qty" min="1" value="1" />
          </div>
          <div class="field">
            <label for="price">단가(원)</label>
            <input type="number" id="price" min="0" value="0" />
          </div>
          <div class="field">
            <label for="date">주문일자</label>
            <input type="date" id="date" />
          </div>
          <div>
            <button type="button" id="btnAdd" class="btn" style="width:100%;">주문추가</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="muted" style="margin-top:10px;">
    ※ “주문추가”로 장바구니에 담은 뒤 “주문하기”를 누르면 저장됩니다. (추가 없이 주문하기 눌러도 전송됨)
  </div>

  <!-- 장바구니 테이블 -->
  <table id="cartTable" aria-label="장바구니">
    <thead>
      <tr>
        <th>물품명</th>
        <th class="right">수량</th>
        <th class="right">단가</th>
        <th class="right">합계</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="cartBody">
      <tr id="emptyRow"><td colspan="5" class="muted">장바구니가 비어 있습니다.</td></tr>
    </tbody>
  </table>

  <!-- 서버로 제출될 hidden 입력들 (배열) -->
  <div id="hiddenItems" style="display:none;"></div>

  <div style="margin-top:12px;">
    <button type="submit" class="btn">주문하기</button>
    <a class="btn" href="${pageContext.request.contextPath}/ProductOrder?action=list">주문목록으로</a>
  </div>
</form>

<!-- (옵션) 기존 DB 주문 목록 -->
<c:if test="${showDb eq true}">
  <h3 class="section-title">기존 주문목록 (DB)</h3>
  <table>
    <thead>
      <tr>
        <th>주문번호</th>
        <th>물품명</th>
        <th class="right">수량</th>
        <th class="right">단가</th>
        <th class="right">합계</th>
        <th>주문일시</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${not empty Products}">
        <c:forEach var="p" items="${Products}">
          <tr>
            <td><c:out value="${p.orderId}"/></td>
            <td><c:out value="${p.productName}"/></td>
            <td class="right"><c:out value="${p.productOrderNumber}"/></td>
            <td class="right"><fmt:formatNumber value="${p.price}" pattern="#,###"/></td>
            <td class="right"><fmt:formatNumber value="${p.price * p.productOrderNumber}" pattern="#,###"/></td>
            <td><c:out value="${p.orderDate}"/></td>
          </tr>
        </c:forEach>
      </c:if>
      <c:if test="${empty Products}">
        <tr><td colspan="6" class="muted">저장된 주문이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>
</c:if>

<script>
(function(){
  const $ = (sel) => document.querySelector(sel);
  const nameSelect = $('#nameSelect');
  const nameHidden = $('#name');
  const nameDisplay = $('#nameDisplay');
  const cartBody = $('#cartBody');
  const emptyRow = $('#emptyRow');
  const hiddenItems = $('#hiddenItems');
  const qtyEl = $('#qty'), priceEl = $('#price'), dateEl = $('#date');
  const btnAdd = $('#btnAdd');
  let lineSeq = 0;

  const PRODUCTS = [
	  { key:'cap_logo',           pid:'P1', name:'팀 로고 모자',       price:25000 },
	    { key:'home_samsung_2025',  pid:'P2', name:'홈 삼성 유니폼 2025', price:89000 },
	    { key:'support_scarf',      pid:'P3', name:'지지 머플러',         price:18000 },
	    { key:'official_logo_ball', pid:'P4', name:'공식 로고 볼',        price:12000 },
	    { key:'hand_fan',           pid:'P5', name:'손 선풍기',           price:15000 },
	    { key:'cheer_stick',        pid:'P6', name:'응원봉',               price:35000 }
	  ];
 
  const PRICE_MAP = {};
  <!-- [FIX] 이름 → productId 매핑을 추가하여 컨트롤러로 productId[] 전송 -->
  const PID_MAP = {}; // [FIX]

  for (var i=0;i<PRODUCTS.length;i++){
    PRICE_MAP[PRODUCTS[i].name] = PRODUCTS[i].price;
    PID_MAP[PRODUCTS[i].name]  = PRODUCTS[i].pid; // [FIX]
  }
  
  for (var i=0;i<PRODUCTS.length;i++){
    PRICE_MAP[PRODUCTS[i].name] = PRODUCTS[i].price;
  }

  function renderDropdown(){
    while (nameSelect.options.length > 1) {
      nameSelect.remove(1);
    }
    for (var i=0;i<PRODUCTS.length;i++){
      var opt = document.createElement('option');
      opt.value = PRODUCTS[i].name;
      opt.text = PRODUCTS[i].name;
      nameSelect.appendChild(opt);
    }
  }

  nameSelect.addEventListener('change', function(){
    const name = nameSelect.value || '';
    nameHidden.value = name;
    nameDisplay.textContent = name ? name : '아직 선택되지 않음';
    if (name && PRICE_MAP[name] != null) {
      priceEl.value = String(PRICE_MAP[name]);
    }
  });

  function fmt(n){
    try { return new Intl.NumberFormat('ko-KR').format(n); }
    catch(e){ return n; }
  }

  function ensureNotEmpty() {
    const hasRows = cartBody.querySelectorAll('tr[data-id]').length > 0;
    if (hasRows) {
      if (emptyRow) emptyRow.remove();
    } else {
      if (!document.getElementById('emptyRow')) {
        const tr = document.createElement('tr');
        tr.id = 'emptyRow';
        const td = document.createElement('td');
        td.colSpan = 5;
        td.className = 'muted';
        td.textContent = '장바구니가 비어 있습니다.';
        tr.appendChild(td);
        cartBody.appendChild(tr);
      }
    }
  }

  btnAdd.addEventListener('click', function() {
    const name = (nameHidden.value || '').trim();
    const qty = parseInt(qtyEl.value, 10) || 0;
    const price= parseInt(priceEl.value, 10) || 0;
    const date = (dateEl.value || '').trim();
    if (!name || qty <= 0 || price < 0 || !date) return;

    lineSeq += 1;
    const id = 'line_' + lineSeq;

    const tr = document.createElement('tr');
    tr.setAttribute('data-id', id);
    tr.innerHTML =
      '<td>' + escapeHtml(name) + '</td>' +
      '<td class="right">' + fmt(qty) + '</td>' +
      '<td class="right">' + fmt(price) + '</td>' +
      '<td class="right">' + fmt(qty * price) + '</td>' +
      '<td><button type="button" class="btn btn-del" data-id="' + id + '">삭제</button></td>';
    cartBody.appendChild(tr);

    const wrap = document.createElement('div');
    wrap.setAttribute('data-id', id);
    wrap.innerHTML =
      '<input type="hidden" name="productName[]" value="' + escapeHtml(name) + '">' +
      '<input type="hidden" name="productOrderNumber[]" value="' + qty + '">' +
      '<input type="hidden" name="price[]" value="' + price + '">' +
      '<input type="hidden" name="orderDate[]" value="' + date + '">'+
      '<input type="hidden" name="productId[]" value="' + (PID_MAP[name]||"") + '">'; // [FIX] 추가
    hiddenItems.appendChild(wrap);

    ensureNotEmpty();

    tr.querySelector('.btn-del').addEventListener('click', function(){
      const k = this.getAttribute('data-id');
      const row = cartBody.querySelector('tr[data-id="'+k+'"]');
      const h = hiddenItems.querySelector('div[data-id="'+k+'"]');
      if (row) row.remove();
      if (h) h.remove();
      ensureNotEmpty();
    });

    qtyEl.value = '1';
  });

  function escapeHtml(s){
    return String(s)
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
  }

  // 오늘 날짜 기본값
  const today = new Date();
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth()+1).padStart(2,'0');
  const dd = String(today.getDate()).padStart(2,'0');
  const dateInput = document.querySelector('#date');
  dateInput.value = yyyy + '-' + mm + '-' + dd;

  renderDropdown();
  ensureNotEmpty();

  /* ▼▼▼ 추가: 선택한 물품에 따라 링크/이미지 변경 (요청 변수명 사용) ▼▼▼ */
  // 1) 링크이미지 매핑용 변수들 (원하는 URL로만 바꾸면 됩니다)
  const capWeb = { 
		    href: '<%=request.getContextPath()%>/images/cap.jpg',   // 프로젝트 내 cap.jpg 경로
		    img: '<%=request.getContextPath()%>/images/cap.jpg'     // 실제 이미지 표시
		  };
  const uniformWeb  = { href: 'https://example.com/uniform',  img: 'https://via.placeholder.com/1280x640.png?text=%ED%99%88+%EC%82%BC%EC%84%B1+%EC%9C%A0%EB%8B%88%ED%8F%BC+2025' };
  const scarfWeb    = { href: 'https://example.com/scarf',    img: 'https://via.placeholder.com/1280x640.png?text=%EC%A7%80%EC%A7%80+%EB%A8%B8%ED%94%8C%EB%9F%AC' };
  const logoballWeb = { href: 'https://example.com/logoball', img: 'https://via.placeholder.com/1280x640.png?text=%EA%B3%B5%EC%8B%9D+%EB%A1%9C%EA%B3%A0+%EB%B3%BC' };
  const handfanWeb  = { href: 'https://example.com/handfan',  img: 'https://via.placeholder.com/1280x640.png?text=%EC%86%90+%EC%84%A0%ED%92%8D%EA%B8%B0' };
  const stickWeb    = { href: 'https://example.com/stick',    img: 'https://via.placeholder.com/1280x640.png?text=%EC%9D%91%EC%9B%90%EB%B4%89' };

  // 2) 상품명 → 위 변수 매핑
  const IMAGE_MAP = {
    '팀 로고 모자': capWeb,
    '홈 삼성 유니폼 2025': uniformWeb,
    '지지 머플러': scarfWeb,
    '공식 로고 볼': logoballWeb,
    '손 선풍기': handfanWeb,
    '응원봉': stickWeb
  };

  // 3) 실제 DOM(링크/이미지) 요소
  const promoLinkEl = document.getElementById('promoLink');
  const promoImgEl  = document.getElementById('promoImg');

  // 4) 적용 함수
  function applyLinkImageByName(name){
    const cfg = IMAGE_MAP[name];
    if (!cfg) return;
    if (cfg.href) promoLinkEl.href = cfg.href;
    if (cfg.img)  promoImgEl.src   = cfg.img;
  }

  // 5) 기존 로직을 건드리지 않고 '추가' 리스너만 붙임
  nameSelect.addEventListener('change', function(){
    applyLinkImageByName(nameSelect.value || '');
  });

  // 6) 초기 값에도 반영(새로고침 직후 선택값이 있다면 바로 적용)
  applyLinkImageByName(nameSelect.value || '');
  /* ▲▲▲ 추가 끝 ▲▲▲ */

})();
</script>
</body>
</html>
