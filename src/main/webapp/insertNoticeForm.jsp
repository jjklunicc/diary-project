<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert Notice Form</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Insert Notice Form</div>
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
		<form action="./insertNoticeAction.jsp" method="post" class="full-content">
			<table class="full-table">
				<tr>
					<th>공지제목</th>
					<td>
						<input type="text" name="noticeTitle" class="form-control">
					</td>
				</tr>
				<tr>
					<th>공지내용</th>
					<td>
						<textarea rows="5" cols="80" name="noticeContent" class="form-control"></textarea>
					</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>
						<input type="text" name="noticeWriter" class="form-control">
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="noticePw" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit">입력</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>