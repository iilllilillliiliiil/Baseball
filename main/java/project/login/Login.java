package project.login;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class Login extends HttpServlet {

    private static final String ADMIN_ID = "admin";
    private static final String ADMIN_PW = "1234";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // login.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (ADMIN_ID.equals(username) && ADMIN_PW.equals(password)) {
            // 로그인 성공: 세션에 role 저장
            HttpSession session = request.getSession();
            session.setAttribute("role", "admin");
            response.sendRedirect(request.getContextPath() + "/schedule"); // 관리자용 일정 페이지 이동
        } else {
            // 로그인 실패
            request.setAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
