<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap" %>
<%@ page import="baseballSystem.Controller.FoodOrder" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>야구장 스낵 주문</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<style>
  .food-card:hover { transform: scale(1.05); cursor: pointer; transition: 0.2s; }
  .food-card img { width: 150px; height: 150px; object-fit: cover; margin: 0 auto; }
  .food-card { display: flex; flex-direction: column; justify-content: flex-start; height: 100%; }
  .card-body { flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
</style>
</head>
<body class="bg-light">

<div class="container mt-5">
  <h2 class="text-center mb-4">⚾ 야구장 스낵 주문</h2>

  <form method="post" action="<%=request.getContextPath()%>/FoodOrder?action=order">

<%
    // 서블릿에서 forward한 DB 연동 리스트
    @SuppressWarnings("unchecked")
    List<baseballSystem.Controller.FoodOrder> foodsFromDB = 
        (List<baseballSystem.Controller.FoodOrder>) request.getAttribute("foods");

    // null일 경우 기본 하드코딩 배열 유지
    if(foodsFromDB == null) {
        String[][] defaultFoods = {
            {"맥주","5000"},
            {"피자","15000"},
            {"치킨","15000"},
            {"떡튀순","5000"},
            {"핫도그","3000"},
            {"도시락","8000"},
            {"탄산음료","2000"},
            {"이온음료","2000"},
            {"생수","1000"}
        };
        foodsFromDB = new java.util.ArrayList<>();
        for(String[] f : defaultFoods) {
            baseballSystem.Controller.FoodOrder fo = new baseballSystem.Controller.FoodOrder();
            fo.setFoodName(f[0]);
            fo.setPrice(Integer.parseInt(f[1]));
            foodsFromDB.add(fo);
        }
    }

    // 이미지 매칭용 Map (foodName → 이미지 경로)
    java.util.Map<String,String> foodImgMap = new java.util.HashMap<>();
    foodImgMap.put("맥주","/images/beer.jpg");
    foodImgMap.put("피자","/images/pizza.jpg");
    foodImgMap.put("치킨","/images/chicken.jpg");
    foodImgMap.put("떡튀순","/images/snacks.jpg");
    foodImgMap.put("핫도그","/images/hotdog.jpg");
    foodImgMap.put("도시락","/images/foodbox.jpg");
    foodImgMap.put("탄산음료","/images/drinks.jpg");
    foodImgMap.put("이온음료","/images/drinks1.jpg");
    foodImgMap.put("생수","/images/waters.jpg");
%>

    <div class="row row-cols-1 row-cols-md-3 g-4">
<%
    for(baseballSystem.Controller.FoodOrder f : foodsFromDB){
        String foodName = f.getFoodName();
        int foodPrice = f.getPrice();
        String foodImg = foodImgMap.get(foodName); // 이미지 매칭
%>
      <div class="col d-flex">
        <div class="card food-card text-center flex-fill">
          <img src="<%=request.getContextPath() + foodImg%>" class="card-img-top" alt="<%=foodName%>">
          <div class="card-body">
            <h5 class="card-title"><%=foodName%></h5>
            <p class="card-text">가격: <%=foodPrice%>원</p>
            <input type="number" name="orderQuantity_<%=foodName%>" class="form-control mb-2" placeholder="수량">
            <div class="form-check">
              <input class="form-check-input" name="orderSelected_<%=foodName%>" type="checkbox" value="<%=foodName%>">
              <label class="form-check-label">선택</label>
            </div>
          </div>
        </div>
      </div>
<% } %>
    </div>

    <div class="d-grid mt-4">
      <button type="submit" class="btn btn-danger btn-lg">장바구니 담기</button>
    </div>
  </form>
</div>

</body>
</html>
