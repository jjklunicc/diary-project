<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//scheduleNo가 없으면 scheduleList로
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	//값 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println("updateScheduleForm scheduleNo : " + scheduleNo);
	
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//scheduleNo에 해당하는 데이터를 가져오겠다.
	String sql = "select schedule_no, schedule_date, schedule_time, schedule_color, schedule_memo from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println("updateScheduleForm query : " + stmt);
	
	//rs에 데이터를 담아줌
	ResultSet rs = stmt.executeQuery();
	
	//rs에 있는 값 Schedule에 담아줌
	Schedule s = new Schedule();
	if(rs.next()){
		s.scheduleNo = rs.getInt("schedule_no");
		s.scheduleDate = rs.getString("schedule_date");
		s.scheduleTime = rs.getString("schedule_time");
		s.scheduleColor = rs.getString("schedule_color");
		s.scheduleMemo = rs.getString("schedule_memo");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Update Schedule</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Update Schedule</div>
		<nav>
			<a href="./home.jsp" >
				<img src="./images/home.png" title="홈으로" class="icon" />
			</a>
			<a href="./noticeList.jsp">	
				<img src="./images/notice.png" title="공지리스트" class="icon"/>
			</a>
			<a href="./scheduleList.jsp">
				<img src="./images/schedule.png" title="일정리스트" class="icon"/>
			</a>
		</nav>
	</header>
	<div class="content">
		<form action="./updateScheduleAction.jsp" method="post" class="full-content">
			<table class="full-table">
				<tr>
					<th>일정번호</th>
					<td><input type="text" value=<%=s.scheduleNo%> readonly name="scheduleNo">
				</tr>
				<tr>
					<th>날짜</th>
					<td><input type="date" value="<%=s.scheduleDate%>" name="scheduleDate"></td>
				</tr>
				<tr>
					<th>시간</th>
					<td><input type="time" value="<%=s.scheduleTime%>" name="scheduleTime"></td>
				</tr>
				<tr>
					<th>라벨색상</th> 
					<td><input type="color" value="<%=s.scheduleColor%>" name="scheduleColor"></td>
				</tr>
				<tr>
					<th>일정내용</th>
					<td><textarea name="scheduleMemo" cols="80" rows="3" ><%=s.scheduleMemo%></textarea></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="schedulePw"></input></td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit">스케줄 수정</button>			
					</td>
				</tr>
			</table>
		</form>
	</div>
	
</body>
</html>