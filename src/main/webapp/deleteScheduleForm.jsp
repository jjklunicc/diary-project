<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//scheduleNo가 없으면 scheduleList로
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	//값저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println("deleteScheduleForm scheduleNo : " + scheduleNo);
		
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Delete Schedule</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Delete Schedule</div>
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
		<form action="./deleteScheduleAction.jsp" method="post" class="full-content">
			<table class="full-table">
				<tr>
					<th>스케줄번호</th>
					<td><input type="text" name="scheduleNo" value=<%=scheduleNo %> readonly></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="schedulePw"></td>
				</tr>
				<tr>
					<td>
						<button type="submit">삭제하기</button>
					</td>
				</tr>
			</table>
		</form>
	</div>	
</body>
</html>