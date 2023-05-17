<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
	// noticeNo가 없으면 noticeList로 redirection
	if(request.getParameter("noticeNo") == null
	|| request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	//값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println("deleteNoticeAction noticeNo : " + noticeNo);
	
	//나머지 유효성 검사
	if(request.getParameter("noticePw") == null
	|| request.getParameter("noticePw").equals("")){
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=noticePw is required");
		return;
	}
	
	//값 저장
	String noticePw = request.getParameter("noticePw");
	System.out.println("deleteNoticeAction noticePw : " + noticePw);
	
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	//noticeNo와 noticePW가 notice_no와 notice_pw와 같은 항목을 삭제해라
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println("deleteNoticeAction query : " + stmt);
	
	//결과 값 저장 => 영향을 받은 행의 수
	int row = stmt.executeUpdate();
	System.out.println("deleteNoticeAction row : " + row);
	
	//row == 0 => 비밀번호가 틀린경우
	if(row == 0){
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=noticePw is incorrect");
	}else{
		response.sendRedirect("./noticeList.jsp");
	}	
	
%>