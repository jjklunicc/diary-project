<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	//유효성 검사
	if(request.getParameter("noticeNo") == null
	|| request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./storeList.jsp");
		return;
	}

	//전달받은 값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println("updateNoticeForm noticeNo : " + noticeNo);
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//noticeNo에 해당하는 데이터를 가져오겠다.
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate, notice_pw from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// stmt의 1번째 ?를 noticeNo로 바꾸겠다.
	stmt.setInt(1, noticeNo);
	System.out.println("updateNoticeForm query : " + stmt);
	
	//불러온 값 rs에 저장
	ResultSet rs = stmt.executeQuery();
	
	//rs에 있는 값 Notice에 저장
	Notice n = new Notice();
	if(rs.next()){
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
	<title>Update Notice</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Update Notice</div>
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
		<form action="./updateNoticeAction.jsp" method="post" class="full-content">
			<table class="full-table">
				<tr>
					<th>공지번호</th>
					<td>
						<input type="number" name="noticeNo" value=<%=n.noticeNo%> readonly>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="noticePw">
					</td>
				</tr>
				<tr>
					<th>공지제목</th>
					<td>
						<input type="text" name="noticeTitle" value=<%=n.noticeTitle%>>
					</td>
				</tr>
				<tr>
					<th>공지내용</th>
					<td>
						<textarea rows="5" cols="80" name="noticeContent">
							<%=n.noticeContent%>
						</textarea>
					</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>
						<input type="text" value=<%=n.noticeWriter%> readonly>
					</td>
				</tr>
				<tr>
					<th>작성일자</th>
					<td>
						<input type="text" value=<%=n.createdate%> readonly>
					</td>
				</tr>
				<tr>
					<th>수정일자</th>
					<td>
						<input type="text" value=<%=n.updatedate%> readonly>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit">수정</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
	
</body>
</html>