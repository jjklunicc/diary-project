<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 인코딩 설정
	request.setCharacterEncoding("utf-8");

	//noticeNo가 없으면 noticeList로 보내버림
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	// 유효성 검사
	String msg = null;
	if(request.getParameter("noticeTitle") == null
	|| request.getParameter("noticeTitle").equals("")){
		msg = "noticeTitle is required";
	}else if(request.getParameter("noticeContent") == null
	|| request.getParameter("noticeContent").equals("")){
		msg = "noticeContent is required";
	}else if(request.getParameter("noticePw") == null
	|| request.getParameter("noticePw").equals("")){
		msg = "noticePw is required";
	}
	
	//유효성 검사에 하나라도 걸리면
	if(msg != null){
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo=" + request.getParameter("noticeNo") + "&msg=" + msg);
		return;
	}

	// 전달받은 값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	System.out.println("noticeNo : " + noticeNo + ", noticePw : " + noticePw + ", noticeTitle : " + noticeTitle + ", noticeContent : " + noticeContent);
	
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// DB에 update문 전송
	String sql2 = "update notice set notice_title = ?, notice_content = ?, updatedate = now() where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, noticeTitle);
	stmt2.setString(2, noticeContent);
	stmt2.setInt(3, noticeNo);
	stmt2.setString(4, noticePw);
	System.out.println("query : " + stmt2);
	
	// 결과 확인후 처리
	int row = stmt2.executeUpdate();
	System.out.println("row : " + row);
	
	if(row == 0){
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=incorrect noticePw");
	}else if(row == 1){
		response.sendRedirect("./noticeOne.jsp?noticeNo=" + noticeNo);
	}else{
		System.out.println("error row값 : " + row);
	}
	
	
%>