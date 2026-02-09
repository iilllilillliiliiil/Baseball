package baseballSystem.Controller;

public class FoodOrder {
    private Long id;               // FOOD_ID     
    private String foodName;       // FOOD_NAME   
    private int foodOrderNumber;   // QUANTITY   
    private int price;             // PRICE   
    //private String date;              

    public FoodOrder() {}

    public FoodOrder(Long id, String foodName, int foodOrderNumber, int price, String date) {
        this.id = id;				
        this.foodName = foodName;   
        this.foodOrderNumber = foodOrderNumber; 
        this.price = price;  
    //this.date = date;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public int getFoodOrderNumber() { return foodOrderNumber; }
    public void setFoodOrderNumber(int foodOrderNumber) { this.foodOrderNumber = foodOrderNumber; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    //public String getDate() { return date; }
    //public void setDate(String date) { this.date = date; }
}