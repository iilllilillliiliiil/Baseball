package baseballSystem.Controller;

import java.sql.Timestamp;  // ★ 반드시 추가

public class ProductOrderDTO {
	private Long orderId;
	private String user_id;  // FK -> MemberRegister.user_id
	private String productId; // FK -> productInfo.productId
	private int productPrice; // 단가(상품 기준)
	private String productName;
	private int productOrderNumber;
	private int price;
	// 문자열로도 보관(예: "yyyy-MM-dd HH:mm:ss") — DB가 VARCHAR일 때 사용
	private String orderDate;
	// DB 컬럼이 TIMESTAMP일 때 사용
	private Timestamp orderTimestamp;

	public ProductOrderDTO() {}
	
	public ProductOrderDTO(Long orderId, String productName, int productOrderNumber, int price, String orderDate) 
	{
		this.orderId = orderId;
		this.productName = productName;
		this.productOrderNumber = productOrderNumber;
		this.price = price;
		this.orderDate = orderDate;
		
	}

	// getter, setter 硫붿냼�뱶
	public Long getOrderId() {
		return orderId;
	}

	public String getUser_id() { 
		return user_id; 
	}
	
	public void setUser_id(String user_id) { 
		this.user_id = user_id; 
	}

	public String getProductId() {
		return productId; 
	}
	
	public void setProductId(String productId) {
		this.productId = productId; 
	}
	
	public int getProductPrice() {
		return productPrice; 
	}
	
	public void setProductPrice(int productPrice) { 
		this.productPrice = productPrice; 
	}
	
	public void setOrderId(Long orderId) {
		this.orderId = orderId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getProductOrderNumber() {
		return productOrderNumber;
	}

	public void setProductOrderNumber(int productOrderNumber) {
		this.productOrderNumber = productOrderNumber;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}
	
	public Timestamp getOrderTimestamp() {
	     return orderTimestamp;
	}
	
	public void setOrderTimestamp(Timestamp orderTimestamp) {
	     this.orderTimestamp = orderTimestamp;
	}
	
	
}
