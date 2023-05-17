<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 현재 페이지
	int currentPage = 1;
	// 유효성 검사
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage);
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행번호
	int startRow = (currentPage - 1) * rowPerPage;
	
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// 공지 리스트 최근에 만들어진 순으로 rowPerPage개 만큼
	PreparedStatement stmt = conn.prepareStatement("select notice_no, notice_title, createdate from notice order by createdate desc limit ?, ?");
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	System.out.println(stmt);
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	
	//결과를 Notice ArrayList에 담아줌
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("notice_no");
		n.noticeTitle = rs.getString("notice_title");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	// 공지 항목 전체 개수를 구함
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0;
	if(rs2.next()){
		totalRow = rs2.getInt("count(*)");
	}
	//마지막 페이지를 구함
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage++;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Notice List</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Notice List</div>
		<nav>
			<a href="./insertNoticeForm.jsp" >
				<img src="./images/add.png" title="공지추가" class="icon" />
			</a>
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
				<h2 class="sub-title">공지제목</h2>
			    <h2 class="sub-title">게시일자</h2>
			</div>
			<%
			   for(Notice n: noticeList) {
			%>
				<div class="list">
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">     
					<div class="flex-box">
						<div><%=n.noticeTitle%></div>
					    <div><%=n.createdate.substring(0, 10)%></div>
					</div>
					</a>
				</div>
			<%      
			   }
			%>
			<div class="pagination">
				<div>
					<%
						if(currentPage > 1){
					%>
							<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>">
								<img src="./images/arrow-left.png" title="이전" class="icon">
							</a>
					<%
						}
					%>
				</div>
				<div><strong><%= currentPage %></strong></div>
				<div>
					<%
						if(currentPage < lastPage){
					%>
							<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>">
								<img src="./images/arrow-right.png" title="다음" class="icon">
							</a>
					<%
						}
					%>
				</div>	
			</div>
		</div>
	</div>
</body>
</html>