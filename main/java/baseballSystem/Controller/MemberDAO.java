package baseballSystem.Controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * 로그인 전용 최소 DAO
 *  - MemberRegister(user_id, password) 일치 여부만 검사
 *  - 다른 기능은 추가하지 않음
 */
public class MemberDAO {
    private Connection conn;

    // ProductDAO와 동일한 H2 접속 정보(프로젝트 내 일관성 유지)
    private static final String JDBC_DRIVER = "org.h2.Driver";
    private static final String JDBC_URL    = "jdbc:h2:tcp://localhost/~/jwbookdb";
    private static final String JDBC_USER   = "jwbook";
    private static final String JDBC_PASS   = "1234";
    
    private void open() throws Exception {
        Class.forName(JDBC_DRIVER);
        conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
    }

    private void close() {
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }

    /** 아이디/비밀번호 일치 여부 */
    public boolean checkLogin(String userId, String password) {
        String sql = "SELECT 1 FROM MemberRegister WHERE user_id=? AND password=?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            open();
            ps = conn.prepareStatement(sql);
            ps.setString(1, userId);
            ps.setString(2, password);
            rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            throw new RuntimeException("로그인 검사 실패: " + e.getMessage(), e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            close();
        }
    }
}
