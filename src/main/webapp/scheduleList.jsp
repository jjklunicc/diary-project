<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월값으로
	if(request.getParameter("targetYear") == null 
	      || (request.getParameter("targetMonth") == null)) {
	   Calendar c = Calendar.getInstance();
	   targetYear = c.get(Calendar.YEAR);
	   targetMonth = c.get(Calendar.MONTH);
	}else {
	   targetYear = Integer.parseInt(request.getParameter("targetYear"));
	   targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	System.out.println(targetYear + "<--scheduleList param targetYear");
	System.out.println(targetMonth + "<--scheduleList param targetMonth");
	
	// 오늘 날짜
	
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	// targetMonth 1일의 요일
	Calendar firstDay = Calendar.getInstance();   //2023 04 24
	firstDay.set(Calendar.YEAR, targetYear); 
	firstDay.set(Calendar.MONTH, targetMonth); 
	firstDay.set(Calendar.DATE, 1); //2023 04 01
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 2023 04 01 몇번쨰 요일인지, 일요일 1, 토요일 7
	
	// 년23, 월12 입력시 Calendear API가 24년 1월로 변경
	// 년23, 월1 입력시 Calendear API가 22년 12월로 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	// 1일앞의 공백칸의 수
	int startBlank = firstYoil - 1;
	
	// targetMonth 마지막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	
	// 전체 TD의 7의 나머지값은 0
	// 마지막날짜 뒤 공백칸의 수
	int endBlank = 0;
	if((startBlank+lastDate) % 7 != 0){
	   endBlank = 7 - (startBlank+lastDate)%7;
	}
	
	// 전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	
	//이전 달의 마지막 날짜 구하기
	Calendar beforeDate = Calendar.getInstance();   //2023 04 24
	beforeDate.set(Calendar.YEAR, targetYear); 
	beforeDate.set(Calendar.MONTH, targetMonth - 1); 
	beforeDate.set(Calendar.DATE, 1); //2023 04 01
	int beforeMonthLast = beforeDate.getActualMaximum(Calendar.DATE);
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//targetYear의 targetMonth의 스케줄 정보들을 날짜순으로 가져옴
	PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by day(schedule_date) asc");
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1);
	System.out.println("scheduleList qeury : " + stmt);
	ResultSet rs = stmt.executeQuery();
	
	//가져온 데이터를 Schedule Array List에 저장
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Schedule List</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Schedule List</div>
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
			<div class="flex-box">
				<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">
					<img src="./images/arrow-left.png" title="이전" class="icon">
				</a>
				<h1><%=targetYear%>년 <%=targetMonth+1%>월</h1>
				<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">
					<img src="./images/arrow-right.png" title="다음" class="icon">
				</a>
			</div>
			<table class="full-content table-border">
				<tr>
					<%
						for(int i = 0; i < totalTD; i += 1){
							int num = i-startBlank+1;
							
							if(i != 0 && i%7 == 0){
					%>
								</tr><tr>
					<%
							}
							String colorClass = "";
							if(num > 0 && num <= lastDate){
								//오늘 날짜이면
								if(today.get(Calendar.YEAR) == targetYear
									&& today.get(Calendar.MONTH) == targetMonth
									&& today.get(Calendar.DATE) == num){
									colorClass = "today";
								}
								if(i % 7 == 6){
									colorClass += " saturday";
								}
								if(i % 7 == 0){
									colorClass += " sunday";
								}
					%>
								<td class="<%=colorClass%> schedule-wrapper" >
									<!-- 날짜 -->
									<div>
										<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
									</div>
									<!-- 일정 -->
									<div class="schedule">
										<%
											for(Schedule s : scheduleList){
												if(num == Integer.parseInt(s.scheduleDate)){
										%>
													<div style="color:<%=s.scheduleColor%>">
														<%=s.scheduleMemo%>
													</div>
										<%
												}
											}
										%>
									</div>
								</td>
					<%
								
							}if(num <= 0){
									colorClass += "empty-day";
					%>
									<td class="<%=colorClass %>">
										<%=beforeMonthLast + num %>
									</td>
					<%			
							}
							if(num > lastDate){
								colorClass += "empty-day";
					%>
								<td class="<%=colorClass %>">
									<%=num - lastDate%>
								</td>
					<%			
							}
						}
					%>
				</tr>
			</table>
		</div>
		
	</div>
	
</body>
</html>