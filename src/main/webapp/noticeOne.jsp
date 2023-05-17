<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// noticeNo값이 없으면 noticeList로 redirection
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");	
		return;
	}

	//값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println("noticeOne noticeNo : " + noticeNo);
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//noticeNo에 해당하는 공지의 데이터를 가져옴
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// stmt의 1번째 ?를 noticeNo로 바꾸겠다.
	stmt.setInt(1, noticeNo);
	System.out.println("noticeOne query : " + stmt);
	
	//실행한 결과 rs에 담음
	ResultSet rs = stmt.executeQuery();
	
	//Notice에 결과 옮겨줌.
	Notice n = null;
	if(rs.next()){
		n = new Notice();
		n.noticeNo = rs.getInt("notice_no");
		n.noticeTitle = rs.getString("notice_title");
		n.noticeContent = rs.getString("notice_content");
		n.noticeWriter = rs.getString("notice_writer");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Notice Detail</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Notice Detail</div>
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
			<table class="full-table">
				<tr>
					<th>공지번호</th>
					<td><input type="text" class="form-control" value=<%=n.noticeNo%> readonly></td>
				</tr>
				<tr>
					<th>공지제목</th>
					<td><input type="text" class="form-control" value=<%=n.noticeTitle%> readonly></td>
				</tr>
				<tr>
					<th>공지내용</th>
					<td><textarea rows="5" cols="80" class="form-control" readonly><%=n.noticeContent%></textarea></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><input type="text" class="form-control" value=<%=n.noticeWriter%> readonly></td>
				</tr>
				<tr>
					<th>작성일자</th>
					<td><input type="text" class="form-control" value=<%=n.createdate%> readonly></td>
				</tr>
				<tr>
					<th>수정일자</th>
					<td><input type="text" class="form-control" value=<%=n.updatedate%> readonly></td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="button">
							<a href="./updateNoticeForm.jsp?noticeNo=<%=n.noticeNo%>">
								수정
							</a>
						</div>
						<div class="button">
							<a href="./deleteNoticeForm.jsp?noticeNo=<%=n.noticeNo%>">
								삭제
							</a>
						</div>
					
					</td>
				</tr>
			</table>
		</div>	
	</div>
</body>
</html>