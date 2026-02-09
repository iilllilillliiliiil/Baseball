package baseballSystem.Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FoodOrder")
public class FoodController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if(action == null || action.equals("list")) {
            showMenuList(request, response);
        } else if(action.equals("order")) {
            showCart(request, response);
        }
    }
    //리스트 DB 연동
    private void showMenuList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	//FoodDAO 객체 생성
    	FoodDAO dao = new FoodDAO();
    	//DB에서 FOODS 테이블 조회
    	List<FoodOrder> foodsFromDB = dao.getAll();
        // JSP에서 기존 이미지 사용위해 foodsFromDB를 전달
    	// FoodInfo.jsp에서 foodName으로 반복하면서 이미지 src는 기존 그대로 
//        String[][] foods = {
//            {"맥주","5,000","/images/beer.jpg"},
//            {"피자","15,00","/images/pizza.jpg"},
//            {"치킨","15,000","/images/chicken.jpg"},
//            {"떡튀순","5,000","/images/snacks.jpg"},
//            {"핫도그","3,000","/images/hotdog.jpg"},
//            {"도시락","8,000","/images/foodbox.jpg"},
//            {"탄산음료","2,000","/images/drinks.jpg"},
//            {"이온음료","2,000","/images/drinks1.jpg"},
//            {"생수","1,000","/images/waters.jpg"}
//        };

        // JSP로 전달
        request.setAttribute("foods", foodsFromDB);
        RequestDispatcher rd = request.getRequestDispatcher("/FoodInfo.jsp");
        rd.forward(request, response); // JSP 화면 그대로 보여줌
    }

    private void showCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // FoodDAO 객체 생성
    	FoodDAO dao = new FoodDAO();
    	List<FoodOrder> foodsFromDB = dao.getAll();
//        String[][] foods = {
//            {"맥주","5000"}, {"피자","15000"}, {"치킨","15000"},
//            {"떡튀순","5000"}, {"핫도그","3000"}, {"도시락","8000"},
//            {"탄산음료","2000"}, {"이온음료","2000"}, {"생수","1000"}
//        };

        java.util.List<FoodOrder> cartList = new java.util.ArrayList<>();
        for(FoodOrder f : foodsFromDB) {
            String name = f.getFoodName();
            int price = f.getPrice();

            String selected = request.getParameter("orderSelected_" + name);
            String qtyStr = request.getParameter("orderQuantity_" + name);
            int qty = 0;
            try { qty = Integer.parseInt(qtyStr); } catch(Exception e) {}

            if(selected != null && qty > 0) {
                FoodOrder order = new FoodOrder();
                order.setFoodName(name);
                order.setPrice(price);
                order.setFoodOrderNumber(qty);
                cartList.add(order);
            }
        }

        request.setAttribute("cartList", cartList);
        RequestDispatcher rd = request.getRequestDispatcher("/Cart.jsp");
        rd.forward(request, response);
    }
}
