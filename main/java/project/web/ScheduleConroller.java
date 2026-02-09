package project.web;

import project.model.GameDto;
import project.repo.SLModel;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/schedule")
public class ScheduleConroller extends HttpServlet {
    private SLModel model = new SLModel();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	List<GameDto> games = model.getRemainingHomeGames();
    	request.setAttribute("games", games);

    	boolean isAdmin = false;
    	HttpSession session = request.getSession(false);
    	if (session != null && "admin".equals(session.getAttribute("role"))) {
    	    isAdmin = true;
    	}
    	request.setAttribute("isAdmin", isAdmin);

    	RequestDispatcher dispatcher = request.getRequestDispatcher("/schedule.jsp");
    	dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String opponent = request.getParameter("opponent");
            String stadium = request.getParameter("stadium");

            LocalDate date = LocalDate.parse(dateStr);
            LocalTime time = LocalTime.parse(timeStr);

            GameDto newGame = new GameDto(date, time, opponent, stadium);
            model.addGame(newGame);

        } else if ("delete".equals(action)) {
            int index = Integer.parseInt(request.getParameter("index"));
            model.removeGame(index);
        }

        response.sendRedirect(request.getContextPath() + "/schedule");
    }
}
