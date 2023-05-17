<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//post방식 인코딩 처리
	request.setCharacterEncoding("utf-8"); 

	// validation(요청 파라미터값 유효성 검사)
	String msg = null;
	
	if(request.getParameter("noticeTitle") == null 
	|| request.getParameter("noticeTitle").equals("")){
		msg = "noticeTitle is required";
	}else if(request.getParameter("noticeContent") == null 
	|| request.getParameter("noticeContent").equals("")){
		msg = "noticeContent is required";
	}else if(request.getParameter("noticeWriter") == null 
	|| request.getParameter("noticeWriter").equals("")){
		msg = "noticeWriter is required";
	}else if(request.getParameter("noticePw") == null 
	|| request.getParameter("noticePw").equals("")){
		msg = "noticePw is required";
	}
	
	//하나라도 빈 값이 있다면 redirection
	if(msg != null){
		response.sendRedirect("./insertNoticeForm.jsp?msg=" + msg);
		return;
	}
	
	//받아온 값 저장
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
   
	System.out.println("insertNoticeAction noticeTitle : " + noticeTitle);
	System.out.println("insertNoticeAction noticeContent : " + noticeContent);
	System.out.println("insertNoticeAction noticeWriter : " + noticeWriter);
	System.out.println("insertNoticeAction noticePw : " + noticePw);

   	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	//받아온 값들을 insert 하겠다.
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	System.out.println("insertNoticeAction query : " + stmt);

	int row = stmt.executeUpdate(); 
	System.out.println("insertNoticeAction row : " + row);
	
	//추가된 공지를 보여주기 위해 공지리스트로 redirection
	response.sendRedirect("./noticeList.jsp");
%>