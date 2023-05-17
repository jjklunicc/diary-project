<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	//scheduleNo 유효성 검사
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	//값 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println("updateScheduleAction scheduleNo : " + scheduleNo);
	
	//나머지 유효성 검사
	String msg = null;
	if(request.getParameter("scheduleDate") == null
	|| request.getParameter("scheduleDate").equals("")){
		msg = "scheduleDate is required";
	}else if(request.getParameter("scheduleTime") == null
	|| request.getParameter("scheduleTime").equals("")){
		msg = "scheduleTime is required";
	}else if(request.getParameter("scheduleColor") == null
	|| request.getParameter("scheduleColor").equals("")){
		msg = "scheduleColor is required";
	}else if(request.getParameter("scheduleMemo") == null
	|| request.getParameter("scheduleMemo").equals("")){
		msg = "scheduleMemo is required";
	}else if(request.getParameter("schedulePw") == null
	|| request.getParameter("schedulePw").equals("")){
		msg = "schedulePw is required";
	}
	
	//하나라도 비어있으면 updateScheduleForm으로 redirection
	if(msg != null){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=" + msg);
		return;	
	}
	
	//값 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	System.out.println("updateScheduleAction scheduleDate : " + scheduleDate);
	System.out.println("updateScheduleAction scheduleTime : " + scheduleTime);
	System.out.println("updateScheduleAction scheduleColor : " + scheduleColor);
	System.out.println("updateScheduleAction scheduleMemo : " + scheduleMemo);
	System.out.println("updateScheduleAction schedulePw : " + schedulePw);
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//scheduleNo와 schedulePw가 schedule_no와 schedule_pw랑 일치하는 녀석의 데이터를 바꿔주겠다
	String sql = "update schedule set schedule_date = ?, schedule_time = ?, schedule_color = ?, schedule_memo = ?, updatedate=now() where schedule_no = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	
	System.out.println("updateScheduleAction query : " + stmt);
	
	//년 월 일 값 각각 저장(redirection을 위해서)
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	
	//결과 상태 저장 => 영향을 받은 행의 수
	int row = stmt.executeUpdate();
	System.out.println("updateScheduleAction row : " + row);
	
	//schedulePw가 틀린경우
	if(row == 0){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg = schedulePw is incorrect");
	}else{
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	}
		
		
%>