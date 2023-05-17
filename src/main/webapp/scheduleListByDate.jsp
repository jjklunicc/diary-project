<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// y, m, d 값이 null or "" => scheduleList.jsp로 redirection
	if(request.getParameter("y") == null
	|| request.getParameter("m") == null
	|| request.getParameter("d") == null
	|| request.getParameter("y").equals("")
	|| request.getParameter("m").equals("")
	|| request.getParameter("d").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int y = Integer.parseInt(request.getParameter("y"));
	// 자바 API 12월 = 11, 마리아 DB에서는 12월 = 12 => +1 처리
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println("scheduleListByDate y : " + y);
	System.out.println("scheduleListByDate m : " + m);
	System.out.println("scheduleListByDate d : " + d);
	
	//date에 value로 쓰일 문자열을 만들기 위해 월, 일 두자리수로 포맷
	String strM = m + "";
	if(m < 10){
		strM = "0" + strM;
	}
	String strD = d + "";
	if(d < 10){
		strD = "0" + strD;
	}
	
	//date에 value로 쓰일 문자열
	String targetDate = y + "-" + strM + "-" + strD;
	
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//targetDate에 해당하는 스케줄 데이터를 시간순으로 가져옴
	String sql = "select schedule_no, schedule_date, schedule_time, schedule_color, schedule_memo, createdate, updatedate from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, targetDate);
	System.out.println("scheduleListByDate query : " + stmt);
	
	//rs에 데이터 담기
	ResultSet rs = stmt.executeQuery();
	
	//rs에 있는 데이터 Schedule Array List로
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("schedule_no");
		s.scheduleDate = rs.getString("schedule_date");
		s.scheduleTime = rs.getString("schedule_time");
		s.scheduleColor = rs.getString("schedule_color");
		s.scheduleMemo = rs.getString("schedule_memo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Schedule List By Date</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Schedule List By Date - <%=y%>년 <%=m%>월 <%=d%>일</div>
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
	<div class="full-content">
		<form action="./insertScheduleAction.jsp" method="post" >
			<h2 class="title">일정추가</h2>
			<table class="multi-input-table">
				<tr>
					<th>날짜</th>
					<td><input type="date" value="<%=targetDate %>" readonly name="scheduleDate"></td>
					<th>라벨색상</th> 
					<td><input type="color" name="scheduleColor" vlaue="#000000"></td>
				</tr>
				<tr>
					<th>시간</th>
					<td><input type="time" name="scheduleTime"></td>
					<th>비밀번호</th>
					<td><input type="password" name="schedulePw"></input></td>
				</tr>
				
				<tr>
					<th>일정내용</th>
					<td colspan="3"><textarea name="scheduleMemo" cols="80" rows="3"></textarea></td>                      
				</tr>
				<tr>
					<td colspan="4">
						<button type="submit">스케줄 입력</button>
					</td>  
				</tr>
			</table>
		</form>
		
		<h2 class="title">일정목록</h2>
		<div class="scroll-table-wrapper">
			<table class="horizontal-table">
				<tr>
					<th>시간</th>
					<th>일정내용</th>
					<th>작성일자</th>
					<th>수정일자</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
				<%
					for(Schedule s : scheduleList){
				%>
						<tr>
							<td><input type="time" value="<%=s.scheduleTime%>"></td>
							<td><textarea cols="70" rows="3"><%=s.scheduleMemo%></textarea></td>
							<td><%=s.createdate%></td>
							<td><%=s.updatedate%></td>
							<td>
								<a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">
									<img src="./images/update.png" title="수정" class="icon" />
								</a>
							</td>
							<td>
								<a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">
									<img src="./images/delete.png" title="삭제" class="icon" />
								</a>
							</td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
	</div>
	</div>
</body>
</html>