package baseballSystem.Controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
	Connection conn = null;
	PreparedStatement pstmt;
	
	 private static final String JDBC_DRIVER = "org.h2.Driver";
	    private static final String JDBC_URL    = "jdbc:h2:tcp://localhost/~/jwbookdb";
	    private static final String JDBC_USER   = "jwbook";
	    private static final String JDBC_PASS   = "1234";
	
	// ✅ 생성자: 아무것도 하지 않음 (안전)
    public ProductDAO() { }
    
	public void open() {
		try {
			Class.forName(JDBC_DRIVER);
			conn = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
			if(conn == null) 
			{System.out.println("연결안됨!");} 
			else
			{System.out.println("연결됨!");} 	
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // open()
	
	public void close() {
		try {	
			if(conn != null) conn.close();
			} catch (Exception ignore) {}
	} // close()
	
	public List<ProductOrderDTO> getAll() {
		open();
		String sql = "SELECT orderId, productName, productOrderNumber, price, orderDate FROM ProductOrder ORDER BY orderId DESC";
		
		PreparedStatement ps = null;   // ✅ 스코프를 try 바깥에서 선언
        ResultSet rs = null;           // ✅ 스코프를 try 바깥에서 선언
        List<ProductOrderDTO> ProductOrder = new ArrayList<>();
        
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
		while(rs.next()) {
				ProductOrderDTO s = new ProductOrderDTO();
				s.setOrderId(rs.getLong("orderId"));
				s.setProductName(rs.getString("productName"));
				s.setProductOrderNumber(rs.getInt("productOrderNumber"));
				s.setPrice(rs.getInt("price"));
				s.setOrderDate(rs.getString("orderDate"));
			    ProductOrder.add(s);
			}
		} catch (SQLException e) {
            throw new RuntimeException("조회 실패", e);
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception ignore) {}
	        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
			close();
		}
		
		return ProductOrder ;
	} // getAll()
	
	 // [@PRODUCTPRICE] 서버에서 productId로 공식 단가 조회
    public Integer findProductPriceById(String productId) {
        open();
        String sql = "SELECT productPrice FROM productInfo WHERE productId = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, productId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("단가 조회 실패", e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            close();
        }
    }
	
	public void insert(ProductOrderDTO s) {
		open();
		 // ▼ SQL 스키마의 필수 컬럼 반영 (user_id, productId, productPrice 추가)
		String sql = "INSERT INTO ProductOrder(user_id, productId, productName, productOrderNumber, price, orderDate)";
		sql += " values(?,?,?,?,?,?)";
		PreparedStatement ps = null; // ✅
		
		
	    try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, s.getUser_id());
            ps.setString(2, s.getProductId());
            ps.setString(3, s.getProductName());
            ps.setInt(4, s.getProductOrderNumber());
            ps.setInt(5, s.getPrice());
            ps.setString(6, s.getOrderDate());
			ps.executeUpdate();
			
		} catch (SQLException e) {
            throw new RuntimeException("저장 실패", e);
		} finally {
			try { if (ps != null) ps.close(); } catch (Exception ignore) {}
			close();
		}
	} // insert()
	
	public void delete(long orderId) {
	    open();  // DB 연결
	    String sql = "DELETE FROM ProductOrder WHERE orderId = ?"; // id를 기준으로 삭제

	    PreparedStatement ps = null; // ✅
	    
	    try {
	        ps = conn.prepareStatement(sql);
	        ps.setLong(1, orderId); // ?에 id 값 넣기
	        ps.executeUpdate(); // 삭제 실행
	      
	    } catch (SQLException e) {
	    	 throw new RuntimeException("삭제 실패", e);
	    } finally {
	    	 try { if (ps != null) ps.close(); } catch (Exception ignore) {}
	        close(); // 연결 닫기
	    }
	}
	
	// 아래는 트랜잭션 예시 유틸(기존 코드 일부)...
	// ProductDAO.java 안
	public void insertBatch(List<ProductOrderDTO> list) throws Exception {
	    open();
	    boolean oldAuto = conn.getAutoCommit();
	    PreparedStatement ps = null;
	    try {
	        conn.setAutoCommit(false);

	        // 현재 스키마에 맞게 productPrice, orderDate 포함
	        final String sql =
	            "INSERT INTO ProductOrder(" +
	            " user_id, productId, productName, " +
	            " productOrderNumber, price, orderDate" +
	            ") VALUES (?,?,?,?,?,?)";
	        ps = conn.prepareStatement(sql);

	        for (ProductOrderDTO s : list) {
	          
	            ps.setString(1, s.getUser_id());
	            ps.setString(2, s.getProductId());
	            ps.setString(3, s.getProductName());
	            ps.setInt(4, s.getProductOrderNumber());
	            ps.setInt(5, s.getPrice());
	            ps.setString(6, s.getOrderDate());

	            // orderDate 컬럼 타입이 TIMESTAMP 라면 setTimestamp 사용 권장
	            // 예: ps.setTimestamp(7, Timestamp.valueOf(s.getOrderDate()));
	            // 문자열이라면 아래처럼 setString 유지
	           

	            ps.addBatch();
	        }

	        ps.executeBatch();
	        conn.commit();

	    } catch (Exception ex) {
	        try { conn.rollback(); } catch (Exception ignore) {}
	        throw ex;
	    } finally {
	        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
	        try { conn.setAutoCommit(oldAuto); } catch (Exception ignore) {}
	        close();
	    }
	}
	
	// (선택) 결제 완료 후 초기화: 테이블 비우고 IDENTITY 재시작
    public void clearAllAndRestartIds() throws Exception {
        open();
        Statement st = null;
        boolean oldAuto = true;
            		
        try {
        	 if (conn == null) 
        	 {
        		 throw new IllegalStateException("DB 연결 실패: conn == null");
        	  }

            oldAuto = conn.getAutoCommit(); // ✅ 여기서 읽고
        	conn.setAutoCommit(false);      // 트랜잭션 시작

        	st = conn.createStatement();

        	// 테이블 비우기 (FK 등으로 TRUNCATE 실패 시 DELETE로 대체)   <==== 여기서 부터 끝까지 컨트롤러 화일에 좌측처럼 표기
        	try {
        	     st.execute("TRUNCATE TABLE productOrder");
        	    } catch (Exception e) {
        	     st.execute("DELETE FROM productOrder");
        	    }

        	 // IDENTITY 리셋 (H2 IDENTITY 컬럼인 경우)
        	try {
        	     st.execute("ALTER TABLE productOrder ALTER COLUMN orderId RESTART WITH 1");
        	    } catch (Exception identityErr) {
        	      // 시퀀스 기반일 수 있는 환경일 때는 시퀀스 리셋을 시도 (필요 시 프로젝트에 맞게 이름 매칭 강화)
        	      // 예시:
        	      // st.execute("ALTER SEQUENCE PUBLIC.SYSTEM_SEQUENCE_xxx RESTART WITH 1");
        	       throw identityErr; // 프로젝트별로 맞춰 처리
        		}

        		conn.commit();                  // ✅ 성공 시 커밋
        	    } catch (Exception ex) {
        	        try { if (conn != null) conn.rollback(); } catch (Exception ignore) {}
        	        throw ex;                       // 호출자에게 전파
                } finally {
        		    try { if (st != null) st.close(); } catch (Exception ignore) {}
        		    try { if (conn != null) conn.setAutoCommit(oldAuto); } catch (Exception ignore) {} // ✅ 원복
        		    close();                        // 연결 정리
        	   }
        	}
}
        		
              