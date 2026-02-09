<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, baseballSystem.Controller.FoodOrder" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <h2 class="text-center mb-4">🛒 장바구니 확인</h2>

  <%
    // 서블릿에서 전달받은 cartList를 가져옴
    // FoodController에서 setAttribute("cartList", cartList) 한 값
    @SuppressWarnings("unchecked")
    List<FoodOrder> cartList = (List<FoodOrder>) request.getAttribute("cartList");

    // 총 금액 초기화
    int total = 0;
  %>

  <% if(cartList == null || cartList.isEmpty()) { %>
    <!-- 장바구니가 비었을 경우 -->
    <div class="alert alert-warning text-center">
      선택한 음식이 없습니다. 
      <a href="<%=request.getContextPath()%>/FoodOrder?action=list">주문하러 가기</a>
    </div>
  <% } else { %>
    <!-- 장바구니에 상품이 있을 경우 -->
    <table class="table table-bordered text-center mx-auto" style="width:70%;">
      <thead class="table-danger">
        <tr>
          <th>음식</th>
          <th>수량</th>
          <th>단가</th>
          <th>금액</th>
        </tr>
      </thead>
      <tbody>
        <% for(FoodOrder f : cartList) {
             // 금액 = 단가 * 수량
             int price = f.getPrice() * f.getFoodOrderNumber();
             total += price;
        %>
        <tr>
          <td><%= f.getFoodName() %></td>
          <td><%= f.getFoodOrderNumber() %></td>
          <td><%= f.getPrice() %>원</td>
          <td><%= price %>원</td>
        </tr>
        <% } %>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="3">총 합계</th>
          <th><%= total %>원</th>
        </tr>
      </tfoot>
    </table>

    <div class="text-center mt-4">
      <!-- 결제 페이지로 이동, amount를 hidden으로 전달 -->
      <!-- 개선: GET 방식 대신 POST로 전달하면 보안성 증가 -->
      <form method="get" action="<%=request.getContextPath()%>/pay.jsp">
        <input type="hidden" name="amount" value="<%=total%>">
        <button type="submit" class="btn btn-success btn-lg">결제하기</button>
      </form>
    </div>
  <% } %>
</div>
</body>
</html>
