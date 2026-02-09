package project.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/login")
public class AdminController extends HttpServlet {

    private final String ADMIN_ID = "admin";
    private final String ADMIN_PW = "1234";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("adminId");
        String pw = request.getParameter("adminPw");

        if (ADMIN_ID.equals(id) && ADMIN_PW.equals(pw)) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", true);
            response.sendRedirect(request.getContextPath() + "/schedule");
        } else {
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?error=1");
        }
    }
}
