<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// date값 유효성 검사	
	if(request.getParameter("scheduleDate") == null
	|| request.getParameter("scheduleDate").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	String scheduleDate = request.getParameter("scheduleDate");
	System.out.println("insetScheduleAction scheduleDate : " + scheduleDate);
	
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	
	System.out.println("insertScheduleAction y : " + y);
	System.out.println("insertScheduleAction m : " + m);
	System.out.println("insertScheduleAction d : " + d);
	
	// 나머지 값 유효성 검사
	String msg = null;
	if(request.getParameter("scheduleTime") == null
		|| request.getParameter("scheduleTime").equals("")){
		msg = "scheduleTime is required";
	} else if(request.getParameter("scheduleColor") == null
		|| request.getParameter("scheduleColor").equals("")){
		msg = "scheduleColor is required";
	}else if(request.getParameter("scheduleMemo") == null
		|| request.getParameter("scheduleMemo").equals("")){
		msg = "scheduleMemo is required";
	}else if(request.getParameter("schedulePw") == null
			|| request.getParameter("schedulePw").equals("")){
			msg = "schedulePw is required";
		}
	if(msg != null){
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d + "&msg=" + msg);
		return;
	}
	
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	
	System.out.println("insetScheduleAction scheduleTime : " + scheduleTime);
	System.out.println("insetScheduleAction scheduleColor : " + scheduleColor);
	System.out.println("insetScheduleAction scheduleMemo : " + scheduleMemo);
	
	
	
	// DB에 쿼리 전달
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_color, schedule_memo, createdate, updatedate, schedule_pw) values(?, ?, ?, ?, now(), now(), ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setString(5, schedulePw);

	System.out.println("insertScheduleAction query : " + stmt);
	
	int row = stmt.executeUpdate();
	
	System.out.println("insertScheduleAction row : " + row);

	response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	
%>
