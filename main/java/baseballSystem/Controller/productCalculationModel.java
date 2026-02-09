package baseballSystem.Controller;


import java.util.List;
import baseballSystem.Controller.ProductOrderDTO;


public class productCalculationModel {
	    /**
	     * 주문된 상품들의 총 금액을 계산하는 메서드
	     * @param orders 주문 내역 리스트
	     * @return 총 금액
	     */
	    public int calculateTotalPrice(List<ProductOrderDTO> orders) {
	        int total = 0;
	        for(ProductOrderDTO order : orders) {
	            total += order.getPrice() * order.getProductOrderNumber();
	        }
	        return total;
	    }

	    /**
	     * 특정 주문의 개별 금액을 계산 (상품 단위)
	     * @param order 주문 객체
	     * @return 개별 주문 총액
	     */
	    public int calculateOrderPrice(ProductOrderDTO order) {
	        return order.getPrice() * order.getProductOrderNumber();
	    }

	    /**
	     * 주문 검증 (수량이나 가격이 잘못된 경우 방어)
	     * @param order 주문 객체
	     * @return 유효 여부
	     */
	    public boolean validateOrder(ProductOrderDTO order) {
	        if(order.getProductOrderNumber() <= 0) return false;
	        if(order.getPrice() < 0) return false;
	        if(order.getProductName() == null || order.getProductName().isEmpty()) return false;
	        return true;
	    }
	}

