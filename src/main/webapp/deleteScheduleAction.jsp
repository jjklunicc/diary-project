<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//scheduleNo 유효성 검사, 없으면 scheduleList로 redirection
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	//값 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println("deleteScheduleAction scheduleNo : " + scheduleNo);
	
	//schedulePw 유효성 검사, 없으면 deleteScheduleForm으로
	if(request.getParameter("schedulePw") == null
	|| request.getParameter("schedulePw").equals("")){
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=schedulePw is required");
		return;
	}
	//값 저장
	String schedulePw = request.getParameter("schedulePw");
	System.out.println("deleteScheduleAction schedulePw : " + schedulePw);
	
	//DB에 쿼리 전송 - 날짜값 가져오기(redirection을 위해)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//schedule_no가 scheduleNo인 녀석의 날짜를 가져오겠다
	String sql = "select schedule_date from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println("deleteScheduleAction query : " + stmt);
	
	//결과값 rs에 저장
	ResultSet rs = stmt.executeQuery();
	String scheduleDate = null;
	if(rs.next()){
		scheduleDate = rs.getString("schedule_date");
	}
	System.out.println("deleteScheduleAction scheduleDate : " + scheduleDate);
	
	//년 월 일 값 각각 저장
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	
	//DB에 쿼리 전송 - 삭제 수행(schedule_no가 scheduleNo이고 schedule_pw가 schedulePw인거)
	String sql2 = "delete from schedule where schedule_no = ? and schedule_pw = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, scheduleNo);
	stmt2.setString(2, schedulePw);
	System.out.println("deleteScheduleAction query2 : " + stmt2);
	
	//결과값 저장 => 영향받은 행의 수
	int row = stmt2.executeUpdate();
	
	//schedulePw가 틀렸을 때
	if(row == 0){
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=schedulePw is incorrect");
	}else{
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	}
	
	
%>