<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//noticeNo가 없으면 noticeList로 redirection
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	//값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println("deleteNoticeForm noticeNo : " + noticeNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Delete Notice</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<!-- 메인메뉴 -->
	<header>
		<div class="homepage-title">Delete Notice</div>
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
		<form action="./deleteNoticeAction.jsp" method="post" class="full-content">
			<table class="full-table">
				<tr>
					<th>공지번호</th>
					<!-- 안보이게 만들고 싶을 땐 type hidden으로 -->
					<!-- 수정 불가해야 하니 readonly속성 -->
					<td><input type="text" name="noticeNo" value=<%=noticeNo %> readonly></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="noticePw"></td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit">삭제</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>