<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>주문 목록</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  :root { --bg:#f7f8fb; --card:#ffffff; --bd:#e5e7eb; --text:#111827; --muted:#6b7280; --accent:#2563eb; }
  * { box-sizing: border-box; }
  body { margin:0; background:var(--bg); color:var(--text); font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Arial,sans-serif; }
  .container { width:min(1024px,92%); margin:28px auto 100px; display:grid; gap:16px; }
  h1 { margin:0 0 12px; font-size:22px; }
  .card { background:var(--card); border:1px solid var(--bd); border-radius:16px; padding:16px; box-shadow:0 1px 2px rgba(0,0,0,.04); }

  table { width:100%; border-collapse:collapse; }
  th, td { padding:12px; border-bottom:1px solid var(--bd); text-align:left; }
  th { background:#f9fafb; font-weight:700; }
  .right { text-align:right; }
  .muted { color:var(--muted); }

  /* 삭제 버튼 등 기존 버튼 공용 */
  .btn {
    display:inline-flex; align-items:center; gap:6px;
    border:1px solid #ccc; background:#f8f8f8; color:#111827;
    padding:8px 12px; border-radius:8px; cursor:pointer; text-decoration:none;
  }
  .btn:hover { background:#eee; }

  /* 하늘색 버튼 (주문하기/결제하기 동일 스타일 & 동일 크기) */
  .btn-sky {
    display:inline-flex; align-items:center; justify-content:center; gap:8px;
    min-width:140px; /* ← 같은 크기 */
    padding:12px 18px; border-radius:12px; font-weight:700;
    background:#e0f2fe;                /* 연한 하늘색 배경 */
    border:1px solid #38bdf8;          /* 테두리 */
    color:#0369a1;                     /* 글자색 */
    text-decoration:none; cursor:pointer;
    box-shadow:0 2px 4px rgba(0,0,0,.06); transition:.2s;
  }
  .btn-sky:hover { background:#bae6fd; }

  /* 푸터 줄 레이아웃: 버튼들 왼쪽, 금액은 오른쪽 끝 */
  .footer-actions {
    display:flex; align-items:center; gap:10px;
  }
  .footer-actions .spacer { flex:1 1 auto; }
  .total-amount { font-weight:800; font-size:18px; text-align:right; white-space:nowrap; }
</style>
</head>
<body>
<div class="container">
  <header>
    <h1>주문 목록</h1>
    <p class="muted">주문 항목의 합계를 같은 줄 오른쪽 끝에 표시합니다.</p>
  </header>

  <section class="card">
    <table aria-label="주문목록">
      <thead>
        <tr>
          <th>ID</th>
          <th>물품명</th>
          <th class="right">수량</th>
          <th class="right">단가(원)</th>
          <th class="right">금액(원)</th>
          <th>주문일시</th>
          <th>관리</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="p" items="${Products}">
          <tr>
            <td>${p.orderId}</td>
            <td>${p.productName}</td>
            <td class="right"><fmt:formatNumber value="${p.productOrderNumber}" pattern="#,###"/></td>
            <td class="right"><fmt:formatNumber value="${p.price}" pattern="#,###"/></td>
            <td class="right"><fmt:formatNumber value="${p.price * p.productOrderNumber}" pattern="#,###"/></td>
            <td>${p.orderDate}</td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/ProductOrder?action=delete" style="display:inline;">
                <input type="hidden" name="orderId" value="${p.orderId}" />
                <button class="btn" type="submit">삭제</button>
              </form>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty Products}">
          <tr><td colspan="7" class="muted">데이터가 없습니다.</td></tr>
        </c:if>
      </tbody>

      <!-- 합계 계산 (표시는 푸터 한 줄에서만) -->
      <c:set var="total" value="0" />
      <c:forEach var="pp" items="${Products}">
        <c:set var="total" value="${total + (pp.price * pp.productOrderNumber)}" />
      </c:forEach>

      <!-- 총합계 숫자 행 제거하고, 같은 줄에 버튼 2개 + 오른쪽 끝 금액 표시 -->
      <tfoot>
        <tr>
          <td colspan="7" style="background:#f9fafb;">
            <div class="footer-actions">
              <!-- 주문하기: 주문 폼으로 이동 (기존 경로 유지) -->
              <a class="btn-sky" href="${pageContext.request.contextPath}/ProductOrder?action=orderForm&showDb=1">➕ 주문하기</a>

              <!-- 결제하기: pay.jsp로 총액 POST -->
              <form method="post" action="${pageContext.request.contextPath}/pay.jsp" style="margin:0;">
                <input type="hidden" name="amount" value="${total}" />
                <button class="btn-sky" type="submit">💳 결제하기</button>
              </form>

              <!-- 오른쪽 끝 결제금액 -->
              <span class="spacer"></span>
              <span class="total-amount">
                결제금액: <fmt:formatNumber value="${total}" pattern="#,###" />원
              </span>
            </div>
          </td>
        </tr>
      </tfoot>
    </table>
  </section>
</div>
</body>
</html>
