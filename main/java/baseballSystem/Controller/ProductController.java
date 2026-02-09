package baseballSystem.Controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;

@WebServlet("/ProductOrder")
public class ProductController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	ProductDAO dao;
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		dao = new ProductDAO();
	} // init()

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String action = request.getParameter("action");
		String view = "";
		
	
		if(action == null ) {
			view = list(request, response);
		} else {
			switch(action) {
			case "list": 
				view = list(request, response); 
				break;
			case "order": 
				view = insert(request, response); 
				break;
			case "delete": 
				view = delete(request, response); 
			    break;
			
			 // [FIX] 폼 진입 시 DB 목록을 미리 세팅해서 JSP에서 바로 사용 가능   <----여기서 부터
            case "orderForm":
            	// showDb=1로 온 경우에만 기존 주문목록 로딩
            	if ("1".equals(request.getParameter("showDb"))) {
	                try {
	                    List<ProductOrderDTO> all = dao.getAll();
	                    request.setAttribute("Products", all);
	                    request.setAttribute("showDb", Boolean.TRUE);
	                } catch (Exception e) {
	                    request.setAttribute("error", "목록 조회 오류: " + e.getMessage());
	                }
	                view = "ProductOrder3.jsp";  // /webapp/productorder.jsp
	                break;
            	}   
            	view = "ProductOrder3.jsp";
                break;			    
            // 결제하기: 테이블 비우고 IDENTITY 재시작 (다음 주문부터 orderId=1)
            case "pay":
                view = pay(request, response);
                break;
               
            case "checkout":
                view = checkout(request, response);
                break;  //  <=== 여기까지 
                
	    	default: 
				view = list(request, response); 
				break;
			}
		}
			
			if (view != null && view.startsWith("redirect:")) {
			    String target = view.substring("redirect:".length());
			    response.sendRedirect(request.getContextPath() + target);
			    return; 
			}
			
			// String forwardPath = "/" + view;
			getServletContext().getRequestDispatcher("/"+view).forward(request, response);
		} // service()
	
	public String list(HttpServletRequest request, HttpServletResponse response)
	{
		 try {
	            List<ProductOrderDTO> all = dao.getAll();
	            request.setAttribute("Products", all);
	        } catch (Exception e) {
	            request.setAttribute("error", "목록 조회 오류: " + e.getMessage());
	        } // JSP에서 ${Products}
            
            Object temp = request.getSession().getAttribute("temp");
     
      
        if (temp != null) {
            request.setAttribute("temp", temp);
            request.getSession().removeAttribute("temp");
        }
		
	    return "ProductOrderResult.jsp"; 
	} // list()
	
	
	
	
	public String insert(HttpServletRequest request, HttpServletResponse response) {
		
		
     // =====================[FIX] 파라미터 수집을 유연하게 =====================
        String[] names  = firstNonNull(
                request.getParameterValues("productName[]"),
                request.getParameterValues("productName")
        );
        String[] qtys   = firstNonNull(
                request.getParameterValues("productOrderNumber[]"),
                request.getParameterValues("productOrderNumber")
        );
        String[] prices = firstNonNull(
                request.getParameterValues("price[]"),
                request.getParameterValues("price")
        );
        
        // ▼ 스키마 필수 컬럼
        String[] productIds = firstNonNull(
                request.getParameterValues("productId[]"),
                request.getParameterValues("productId")
        );
        
                     
                
        String[] dates  = firstNonNull(
                request.getParameterValues("orderDate[]"),
                request.getParameterValues("orderDate")
        );
        
        // 1) 파라미터 자체가 비어 있을 때
        if (names == null || qtys == null || prices == null || dates == null) {
        	return "redirect:/ProductOrder?action=list"; // PRG
        }
        
        // 2) 유효 길이가 0일 때
        // =====================[FIX] 길이/널 안전한 최소 길이 계산 =================
        int n = minLen(names, qtys, prices, dates, productIds);
        if (n <= 0) {
            request.getSession().setAttribute("temp", "유효한 주문 항목이 없습니다.");
            return "redirect:/ProductOrder?action=list"; // ← [CHANGED]
        }
       
   
        
        Map<String, ProductOrderDTO> merged = new LinkedHashMap<>();
      
        for (int i = 0; i < n; i++) 
        {
        	 // =====================[FIX] 인덱싱 안전화 ============================
            String name = (i < names.length)  ? safeTrim(names[i])  : null;
            String qstr = (i < qtys.length)   ? qtys[i]             : null;
            String pstr = (i < prices.length) ? prices[i]           : null;
            String dt   = (i < dates.length)  ? safeTrim(dates[i])  : null;
            // ===================================================================
            int qty   = parseIntSafe(qstr, 0);
            int price = parseIntSafe(pstr, 0);

            // 검증 먼저
            // 유효성 검사 (누락/잘못된 값은 스킵)
            if (name == null || name.isEmpty() || qty <= 0 || price < 0 || dt == null || dt.isEmpty()) {
                continue;
             }
            
          
         // [FIX] 목록에는 시:분이 보이도록 저장 시점에 HH:mm 붙이기 (KST, 초 제외)
            String dtWithTime = toDateTimeWithNowHm(dt);
	        
	        String key = name + "|" + price + "|" + dt;// date-only for merge
	        
	        ProductOrderDTO s = merged.get(key);
	    
	        if (s == null) {
	        s = new ProductOrderDTO();
	        s.setProductName(name);
	        s.setProductOrderNumber(qty);
	        s.setPrice(price);
	        s.setOrderDate(dtWithTime); // [FIX] yyyy-MM-dd HH:mm 저장
            
            
            // 로그인 사용자 (FK)
            String loginUser = (String) request.getSession().getAttribute("loginUser");
            if (loginUser != null) s.setUser_id(loginUser);
            
         // 상품 식별자 (FK)
            String pid = (productIds != null && i < productIds.length) ? productIds[i] : null;
            if (pid != null) s.setProductId(pid);
          
        
            int unitPrice = 0;
            if (pid != null) {
                Integer v = dao.findProductPriceById(pid);
                if (v != null) unitPrice = v;
            }
            s.setProductPrice(unitPrice); // [@PRODUCTPRICE]
            
            
            
            merged.put(key, s);
	        
	        } else {
	            // 동일 항목이면 수량만 누적
	            s.setProductOrderNumber(s.getProductOrderNumber() + qty);
	           }
           }
        
     // [FIX] 빈 병합 결과 처리
        if (merged.isEmpty()) {
            request.getSession().setAttribute("temp", "유효한 주문 항목이 없습니다.");
            return "redirect:/ProductOrder?action=list"; // ← [CHANGED]
    
        }
  
        int insertedCount = 0;
        try {
            for (ProductOrderDTO s : merged.values()) {
                dao.insert(s);
                insertedCount++;
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("temp", "주문 저장 오류: " + e.getMessage());
            return "redirect:/ProductOrder?action=list";
        }
        
   
        request.getSession().setAttribute("temp","주문이 저장되었습니다. (" + merged.size() + "건)");
            return "redirect:/ProductOrder?action=list";
       } 
        
        
	
	
	public String delete(HttpServletRequest request, HttpServletResponse response) {
        long id = parseIntSafe(request.getParameter("orderId"), -1);
        if (id <= 0) {
            request.setAttribute("error", "잘못된 주문번호입니다.");
            return list(request, response);
        }
        try {
            dao.delete(id);
        } catch (Exception e) {
            request.setAttribute("error", "삭제 오류: " + e.getMessage());
            return list(request, response);
        }
        return "redirect:/ProductOrder?action=list";
    }
	  
	  /**  결제 화면 열기: 현재 장바구니/주문을 보여주며 결제 확인 시 checkout으로 이동 */
	    private String pay(HttpServletRequest request, HttpServletResponse response) {
	        try {
	            List<ProductOrderDTO> all = dao.getAll(); // 결제 전에 확인용으로 목록 전달
	            request.setAttribute("Products", all);
	        } catch (Exception e) {
	            request.setAttribute("error", "결제 준비 중 오류: " + e.getMessage());
	            return "ProductOrderResult.jsp";
	        }
	        return "pay.jsp"; // /pay.jsp
	    }

	    /** 결제 확정: 주문 테이블 비우고 IDENTITY 리셋 */
	// 결제 처리: 테이블 비우고, IDENTITY 리셋
	    private String checkout(HttpServletRequest request, HttpServletResponse response) {
	        try {
	            dao.clearAllAndRestartIds(); // TRUNCATE + RESTART WITH 1
	            request.getSession().setAttribute("temp", "결제가 완료되었습니다. 다음 주문을 시작하세요.");
	        } catch (Exception e) {
	            request.setAttribute("error", "결제 처리 오류: " + e.getMessage());
	            return list(request, response);
	        }
	        return "redirect:/ProductOrder?action=list";
	    }

	   
	    // ---------------------- 유틸 ----------------------
	    private static String safeTrim(String s) {
	        return (s == null) ? null : s.trim();
	    }
	    private static int parseIntSafe(String s, int def) {
	        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
	    }
	    // [FIX] 널 허용 최소 길이 계산
	    private static int minLen(String[]... arrs) {
	        int min = Integer.MAX_VALUE;
	        for (String[] a : arrs) {
	            if (a == null) return 0;
	            min = Math.min(min, a.length);
	        }
	        return (min == Integer.MAX_VALUE) ? 0 : min;
	    }
	    // [FIX] 첫 번째 non-null 배열 반환
	    private static String[] firstNonNull(String[] a, String[] b) {
	        return (a != null) ? a : b;
	    }
	    
	 // [FIX] yyyy-MM-dd + 현재 KST 시:분(HH:mm) 조합
	    private static String toDateTimeWithNowHm(String dateStr) {
	        try {
	            LocalDate d = LocalDate.parse(dateStr); // yyyy-MM-dd
	            LocalTime t = LocalTime.now(ZoneId.of("Asia/Seoul")).withNano(0);
	            LocalDateTime dt = LocalDateTime.of(d, t);
	            return dt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	        } catch (Exception e) {
	            // 파싱 실패 시 원문 반환(최소한 목록 표시는 되도록)
	            return dateStr;
	        }
	    }
}
	
