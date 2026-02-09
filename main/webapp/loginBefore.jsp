<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // ▼ 로그인 처리(POST로 제출되었을 때만 동작)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String userId   = request.getParameter("user_id");
        String password = request.getParameter("password");

     // DB 검증 (MemberRegister 테이블)
         
       baseballSystem.Controller.MemberDAO dao = new baseballSystem.Controller.MemberDAO();
        boolean ok = dao.checkLogin(userId, password);


        if (ok) {
            // ✅ 로그인 성공 → 세션에 저장
            request.getSession(true).setAttribute("loginUser", userId);
            // 메인 화면으로 이동
            response.sendRedirect(request.getContextPath() + "/loginMain.jsp");
            return; // 아래 화면 렌더링 중단
        } else {
            request.setAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>로그인</title>
<style>
  body { font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", Arial, sans-serif;
         margin: 40px; }
  form { max-width: 360px; display: grid; gap: 12px; }
  label { display: grid; gap: 6px; }
  input, button { padding: 10px; font-size: 14px; }
  .error { color: #b91c1c; margin-top: 8px; }
  .card { border:1px solid #e5e7eb; border-radius: 10px; padding:16px; max-width:420px; }
</style>
</head>
<body>
  <h2>로그인</h2>

  <div class="card">
    <% if (request.getAttribute("errorMsg") != null) { %>
      <div class="error"><%= request.getAttribute("errorMsg") %></div>
    <% } %>

    <form method="post" action="<%=request.getContextPath()%>/loginBefore.jsp">
      <label>아이디
        <input name="user_id" required />
      </label>
      <label>비밀번호
        <input type="password" name="password" required />
      </label>
      <button type="submit">로그인</button>
    </form>
  </div>

  <p style="margin-top:20px; color:#6b7280;">
    데모 계정: <code>user / pass</code>
  </p>
</body>
</html>
