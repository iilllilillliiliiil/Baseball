<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>결제</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  :root {
    --bg:#f7f8fb; --card:#ffffff; --bd:#e5e7eb; --text:#111827; --muted:#6b7280;
    --ok:#16a34a; --ok-bg:#ecfdf5; --focus:#3b82f6;
  }
  * { box-sizing: border-box; }
  html, body { height:100%; }
  body {
    margin:0; background:var(--bg); color:var(--text);
    font-family: -apple-system, BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Arial,sans-serif;
  }
  .container {
    width:min(960px, 92%);
    margin: 28px auto 100px;
    display:grid; gap:16px;
  }
  h1 { margin:0 0 8px; font-size:22px; letter-spacing:-0.2px; }
  .sub { color:var(--muted); font-size:14px; margin-bottom:12px; }

  .section {
    background:var(--card); border:1px solid var(--bd);
    border-radius:16px; padding:20px; box-shadow: 0 1px 2px rgba(0,0,0,.04);
  }
  .section h2 { margin:0 0 12px; font-size:18px; }
  .grid { display:grid; gap:12px; }
  .row { display:grid; grid-template-columns: 140px 1fr; gap:10px; align-items:center; }
  label { font-weight:600; }
  input, select, button {
    font-size:14px; padding:10px 12px; border:1px solid var(--bd);
    border-radius:10px; background:#fff;
  }
  input:focus, select:focus {
    outline: none; border-color: var(--focus); box-shadow: 0 0 0 3px rgba(59,130,246,.16);
  }
  .account {
    display:flex; gap:8px; align-items:center; justify-content:space-between;
    border:1px dashed var(--bd); border-radius:12px; padding:10px 12px; background:#fff;
  }
  .account .meta { display:flex; gap:12px; align-items:center; flex-wrap:wrap; }
  .bank { font-weight:700; }
  .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace; }
  .muted { color:var(--muted); font-size:13px; }
  .two { display:grid; grid-template-columns: 1fr 1fr; gap:10px; }

  /* 하단 고정 결제 바 */
  .paybar {
    position:fixed; left:0; right:0; bottom:0; background:#fff;
    border-top:1px solid var(--bd); padding:12px;
  }
  .paybar-inner {
    width:min(960px, 92%); margin:0 auto;
    display:flex; gap:12px; align-items:center; justify-content:flex-end;
  }
  .btn {
    border:none; cursor:pointer;
    padding:12px 18px; border-radius:12px; font-weight:700;
    transition: all .2s ease;
    box-shadow: 0 2px 4px rgba(0,0,0,.08);
  }
  /* 홈으로 버튼 */
  .btn-outline {
    background:#e0f2fe;           /* 연한 파랑 */
    border:1px solid #38bdf8;     /* 파랑 테두리 */
    color:#0369a1;                /* 글자 파랑 */
    display:inline-flex; gap:8px; align-items:center;
  }
  .btn-outline:hover { background:#bae6fd; }
  /* 결제 버튼 */
  .btn-pay {
    background:#2563eb; color:#fff;
    display:inline-flex; gap:8px; align-items:center;
  }
  .btn-pay:hover { background:#1e40af; }

  /* 결제 완료 토스트 - 화면 최하단 바로 위로 */
  .toast {
    position:fixed; left:50%; transform:translateX(-50%);
    bottom:12px; background:var(--ok-bg); color:var(--ok);
    border:1px solid #a7f3d0; padding:12px 16px; border-radius:12px;
    box-shadow: 0 6px 18px rgba(0,0,0,.08);
    display:none; align-items:center; gap:10px; font-weight:700;
    z-index: 10;
  }
</style>
</head>
<body>
<!-- [FIX] 로그인 상태 표시 + 로그아웃 -->
<div class="topbar" style="position:fixed; top:0; z-index:10; width:100%;right:0; left:0; padding-right: 9cm;">
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
<%
  // 주문목록(productOrderResult.jsp)에서 전달된 결제금액을 읽어와 표시
  String amtParam = request.getParameter("amount");
  long amount = 0L;
  try {
    if (amtParam != null && !amtParam.isEmpty()) {
      amount = Long.parseLong(amtParam);
    }
  } catch (NumberFormatException e) {
    amount = 0L; // 숫자 아님 방어
  }
%>
  <div class="container">
    <header>
      <h1>결제</h1>
      <p class="sub">현금 입금시 아래 계좌 사용 / 카드 결제 정보를 입력하세요.</p>
    </header>

    <!-- 현금 입금 영역 (1개만 남김) -->
    <section class="section">
      <h2>현금 입금 (무통장)</h2>
      <div class="account">
        <div class="meta">
          <span class="bank">은행</span>
          <span class="mono">110-1234-1234-1234</span>
          <span class="muted">예금주: ㈜테스트</span>
        </div>
        <button type="button" class="btn btn-outline" id="copyAcct" data-account="110-1234-1234-1234">계좌결제</button>
      </div>
      <p class="muted" style="margin-top:8px;">입금 후 카드 결제 없이도 주문이 접수됩니다. (입금자명과 주문자명을 일치시켜 주세요)</p>
    </section>

    <!-- 카드 결제 입력 영역 -->
    <section class="section">
      <h2>카드 결제</h2>
      <form id="payForm" method="post" action="#">
        <div class="grid">
          <div class="row">
            <label for="holder">카드 소유자명</label>
            <input id="holder" name="holder" type="text" placeholder="홍길동" required />
          </div>

          <div class="row">
            <label for="cardNumber">카드 번호</label>
            <input id="cardNumber" name="cardNumber" inputmode="numeric" maxlength="19"
                   class="mono" placeholder="1234-1234-1234-1234" required />
          </div>

          <div class="row">
            <label>유효기간 / CVC</label>
            <div class="two">
              <input id="exp" name="exp" inputmode="numeric" maxlength="5"
                     class="mono" placeholder="MM/YY" required />
              <input id="cvc" name="cvc" inputmode="numeric" maxlength="4"
                     class="mono" placeholder="CVC" required />
            </div>
          </div>

          <div class="row">
            <label for="quota">할부</label>
            <select id="quota" name="quota" required>
              <option value="1">일시불</option>
              <option value="2">2개월</option>
              <option value="3">3개월</option>
              <option value="6">6개월</option>
              <option value="12">12개월</option>
            </select>
          </div>

          <!-- 결제 금액: 주문목록에서 온 값을 자동 표시 + 읽기 전용(추가 입력 불가) -->
          <div class="row">
            <label for="amount">결제 금액</label>
            <input id="amount" name="amount_display" type="text"
                   class="mono" value="<%= String.format("%,d원", amount) %>"
                   readonly aria-readonly="true" />
          </div>
        </div>

        <!-- 폼 안의 제출 버튼은 숨기고, 하단 고정 바의 버튼을 사용 -->
        <button type="submit" id="hiddenSubmit" style="display:none;">submit</button>
      </form>
    </section>
  </div>

  <!-- 하단 고정 바 -->
  <div class="paybar">
    <div class="paybar-inner">
      <!-- 홈으로: 아이콘 클릭 시 main.jsp 이동 -->
      <button type="button" class="btn btn-outline" id="btnHome" aria-label="홈으로">
        🏠 <span>홈으로</span>
      </button>
      <button type="button" class="btn btn-pay" id="btnPay" aria-label="결제">
        💳 <span>결제</span>
      </button>
    </div>
  </div>

  <!-- 토스트 -->
  <div class="toast" id="toast">✅ 결제되었습니다</div>

<script>
  // 계좌 복사
  (function(){
    const btn = document.getElementById('copyAcct');
    btn.addEventListener('click', async () => {
      const text = btn.dataset.account;
      try {
        await navigator.clipboard.writeText(text);
        showToast('계좌번호가 복사되었습니다');
      } catch(e) {
        alert('복사에 실패했습니다: ' + text);
      }
    });
  })();

  // 카드번호 자동 포맷팅 (####-####-####-####)
  const cardInput = document.getElementById('cardNumber');
  cardInput.addEventListener('input', () => {
    let v = cardInput.value.replace(/[^\d]/g, '').slice(0,16);
    let out = [];
    for (let i=0; i<v.length; i+=4) out.push(v.substring(i, i+4));
    cardInput.value = out.join('-');
  });

  // 유효기간 자동 포맷 (MM/YY)
  const expInput = document.getElementById('exp');
  expInput.addEventListener('input', () => {
    let v = expInput.value.replace(/[^\d]/g, '').slice(0,4);
    if (v.length >= 3) v = v.slice(0,2) + '/' + v.slice(2);
    expInput.value = v;
  });

  // 결제 버튼 → 폼 제출
  document.getElementById('btnPay').addEventListener('click', () => {
    document.getElementById('hiddenSubmit').click();
  });

  // 홈으로 이동 (아이콘/버튼 클릭 시 main.jsp)
  document.getElementById('btnHome').addEventListener('click', () => {
    window.location.href = '<%=request.getContextPath()%>/loginMain.jsp';
  });

  // 폼 제출 시: 토스트 → 서버에 주문 전체 삭제(checkout) → **페이지 유지(리다이렉트 제거)**
  document.getElementById('payForm').addEventListener('submit', async (e) => {
    e.preventDefault(); // 서버 전송 방지 (AJAX로 처리)
    const required = ['holder','cardNumber','exp','cvc','quota'];
    for (const id of required) {
      const el = document.getElementById(id);
      if (!el || !el.value) { el.focus(); return; }
    }

    // 1) 결제 완료 토스트
    showToast('결제되었습니다');

    try {
      // 2) 서버에 주문 전체 삭제 요청 (컨트롤러의 checkout 액션 호출)
      await fetch('<%=request.getContextPath()%>/ProductOrder?action=checkout', {
        method: 'POST'
      });
    } catch (err) {
      console.error('주문 비우기 실패', err);
    }

    // 3) 페이지는 그대로 유지 (리다이렉트/화면 전환 없음)
    // 필요하면 아래처럼 버튼 비활성화 정도만 선택적으로 수행할 수 있습니다:
    // document.getElementById('btnPay').disabled = true;
  });

  // 토스트 공용 함수
  let toastTimer = null;
  function showToast(msg) {
    const toast = document.getElementById('toast');
    toast.textContent = '✅ ' + msg;
    toast.style.display = 'flex';
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => { toast.style.display = 'none'; }, 1200);
  }
</script>
</body>
</html>
