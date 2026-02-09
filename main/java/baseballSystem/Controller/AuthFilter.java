package baseballSystem.Controller;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 최소 버전 인증 필터:
 *  - 세션에 "loginUser"가 없으면 /loginMain.jsp 로 리다이렉트
 *  - /loginMain.jsp 는 예외로 통과 (무한 리다이렉트 방지)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();

        // 로그인 페이지 및 정적 리소스는 항상 통과
        boolean isLoginPage = uri.endsWith("/loginBefore.jsp") || uri.endsWith("/loginMain.jsp");
        boolean isStatic = uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/") || uri.contains("/META-INF/") || uri.contains("/favicon");
        if (isLoginPage || isStatic) {
            chain.doFilter(req, res);
            return;
        }
        
        // 세션에 로그인 사용자 존재 여부 확인
        HttpSession session = request.getSession(false);
        Object loginUser = (session == null) ? null : session.getAttribute("loginUser");

        // 미로그인 → 로그인 페이지로 이동
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/loginBefore.jsp");
            return;
        }

        // 로그인 상태 → 진행
        chain.doFilter(req, res);
    }

}
