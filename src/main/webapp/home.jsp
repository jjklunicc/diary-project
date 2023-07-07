<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	// notice에서 최신 5개 추춣
	String sql1 = "select notice_no, notice_title, createdate from notice order by createdate desc limit 0, 5";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println("home query1 : " + stmt1);
	ResultSet rs1 = stmt1.executeQuery();
	
	//받아온 값 Notice Array List에 저장
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs1.next()){
		Notice n = new Notice();
		n.noticeNo = rs1.getInt("notice_no");
		n.noticeTitle = rs1.getString("notice_title");
		n.createdate = rs1.getString("createdate");
		noticeList.add(n);
	}
	
	// 오늘 일정 시간순으로
	String sql2 = "select schedule_no, schedule_date, schedule_time, substr(schedule_memo,1,10) memo from schedule where schedule_date = curdate() order by schedule_time asc";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println("home query2 : " + stmt2);
	ResultSet rs2 = stmt2.executeQuery();
	
	//받아온 값 Schedule Array List에 저장
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs2.next()){
		Schedule s = new Schedule();
		s = new Schedule();
		s.scheduleNo = rs2.getInt("schedule_no");
		s.scheduleDate = rs2.getString("schedule_date");
		s.scheduleTime = rs2.getString("schedule_time");
		s.scheduleMemo = rs2.getString("memo");
		scheduleList.add(s);
	}
	
	//년 월 일 값 각각 저장(redirection을 위해서)
	String y = "";
	int m = 0;
	String d = "";
	
	if(scheduleList.size() != 0){
		y = scheduleList.get(0).scheduleDate.substring(0, 4);
		m = Integer.parseInt(scheduleList.get(0).scheduleDate.substring(5, 7)) - 1;
		d = scheduleList.get(0).scheduleDate.substring(8);
	}
  %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Homepage</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">My Diary</div>
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
		<div class="inner-content">
			<h1 class="title">공지사항</h1>
			<div>
			   <div class="flex-box">
			      <h2 class="sub-title">공지제목</h2>
			      <h2 class="sub-title">게시일자</h2>
			   </div>
			   <%
			      for(Notice n : noticeList) {
			   %>
			   		<div class="list">
				   		<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">     
							<div class="flex-box">
								<div><%=n.noticeTitle%></div>
							    <div><%=n.createdate%></div>
							</div>
						</a>
			   		</div>
			   <%      
			      }
			   %>
			</div>
		</div>
		<div class="inner-content">
			<h1 class="title">오늘일정</h1>
			<div>
			   <div class="schedule-box">
			      <h2 class="sub-title">날짜</h2>
			      <h2 class="sub-title">시간</h2>
			      <h2 class="sub-title">메모</h2>
			   </div>
			   <%
			      for(Schedule s : scheduleList) {
			   %>
			      <a href="./scheduleListByDate.jsp?y=<%=y%>&m=<%=m%>&d=<%=d%>">
			         <div class="schedule-box">
				         <div><%=s.scheduleDate%></div>
				         <div><%=s.scheduleTime%></div>
				         <div><%=s.scheduleMemo%></div>
			         </div>
			      </a>
			   <%      
			      }
			   %>
			</div>
		</div>
		<div class="information">
			<h1 class="title">프로젝트 정보</h1>
			<ul>
				<li>제작기간 : 3주</li>
				<li>사용언어 : Java 17</li>
				<li>데이터베이스 : MariaDB 10.5</li>
				<li>기타 : HTML5, CSS3</li>
				<li>주요기능: 공지추가 / 수정 / 삭제, 공지목록 페이지별 확인,<br>
				일정추가 / 수정 / 삭제, 월별 일정확인(달력에), 일별 일정확인</li>
			</ul>
		</div>
	</div>
</body>
</html>