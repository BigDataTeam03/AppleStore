<%@ page import="com.javaproject.util.CookieManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
	<%
	/*--------------------------------------------------------------
	* Description 	: Login 화면
			Detail	: Client view page
				1. form action -> 
				2. cookieName
				3. validationForm <function script> 
	    		  	
	* Author 		: PDG, LS, Diana
	* Date 			: 2024.02.05
	* ---------------------------Update---------------------------		
	* <<2024.02.09>> by PDG
	    1. 로고 디자인 추가. 
	    2. 가운데 정렬하고 css 파일 만듬. 
	    3. 버튼 클릭하지 않고 엔터만 처도 들어가게 만듬. 
	    4. MVC 가아니라 JS format 으로 다시세팅함. 
	    
	   <<2024.02.10>> by PDG
	    1. 공지사항 layer pop up 기능 추가함. 
	    2. 쿠키를 이용한 로그인 방식으로 수정함. 
	    3. 세션을 활용한 로그인 기억 기능 추가
	    
	    <<2024.02.11> by pdg
	    1. 로그인 체크 디비연동하여 수정함. 
	    2. 로그인 하면 top 에서 뭔가 사용자 정보를 보여주면 좋을거같은데?
	    
	    <<2024.02.12> by pdg
	    1. admin 은 아이디 저장 되지만 일반유저는 아이디 저장 안되는 문제 해결함. 
	    2. 아무것도 없는 입력란으로 로그인 버튼 눌렀을 때 validation 하는 기능 
	    3. 회원 가입 버튼 누르면 페이지가 안뜨는 문제 해결 
	    
	    <<2024.02.19>> by pdg 
	    1. 로그인  첫번에만 환영합니다 메세지가 나오도록 => 쿠키 이용.
	    <<2024.02.23> by pdg
	    1. 로그인 Process Jsp 가 아니라 controller 에서 비교하도록 코드 수정 (spring)

	--------------------------------------------------------------*/
		// Layer pop up 띄울지 여부
		String popupMode = "on"; // 
		
		// Cookie 설정
		Cookie[] cookies = request.getCookies();
		if (cookies != null){
			for (Cookie c : cookies){
				String cookieName = c.getName(); 		// 1. 쿠키 이름 가져오기 
				String cookieValue = c.getValue();		// 2. 쿠키 값 가져오기
				if (cookieName.equals("PopupClose")){ 	// 3. 오늘하루 안보기가 변수 확인 
					popupMode = cookieValue; 			// 4. popup mode 가 on 일경우 Popup 이 켜짐
				}//If end
			}//For end
		}//If end
		
		String loginId = CookieManager.readCookie(request,"loginId"); // loginId 라는 쿠키를 불러
		String cookieCheck = "";
		if (!loginId.equals("")){ //loginId 가 있을경우
			cookieCheck = "checked"; //checked 
		}//If end
	%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Apple King</title>
    <link rel="stylesheet" href="resources/css/login.css" />
    <style>
		div#popup{
			position : absolute; top:20px; left:20px; color:black;
			width:300px ; height : 189px; background-color :#96c0bc;
		}
		.container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
		.form-container {
        text-align: center;
        width: 300px; /* 폼 너비를 조절*/
    }
    </style>
</head>
<body>
	<%
		// 1. POP UP 창에 대한 코드 
		if (popupMode.equals("on")){ // pop up 창을 켜야할경우 (on) popup 동작
	%>
			<!-- html region -->
			<div id ="popup">
				<h2 align ="center">공지사항  </h2>
				<p align ="center"> 안녕하세요 Apple king 입니다. <br>
					새해를 맞아 모든 고객에게 사과나무를 심어드립니다.</p>
				
				<div id ="checkpopup" align = "left" >
					<form name = "popFrm">
						<input type="checkbox" id ="inactiveToday" value ="1" />
							하루(1분) 동안 열지 않음. 
						<input type = "button" value = "닫기" id = "closeBtn"/>
					</form>
				</div>
			</div>
	<%
		} //If end
	%>
	<% 
	// 2. login 상태 확인  
	if (session.getAttribute("userId") == null){ // 처음에 loginId session 에 값이 없을 경우!
	%>
	<div class= "container">
	  	<div>
	    	<h1><img src="resources/image/logo.png"></h1>
	  	</div>
	  	<div class="form-container">
	  		<%//-----------------------Form Action(validationForm =>LoginProcess.jsp) --------- //%>
	    	<form 	class ="form-container"
	    			name="loginForm" 
	    			action="loginProcess" 
	    			method="post"
	    			onsubmit ="return validationForm(this);"> 
	        	<div>
	        		<!--  login error 메세지  -->
	        		<span style ="color: red; font-size: 0.9em;">
					<%= request.getAttribute("LoginErrMsg") ==null?"": request.getAttribute("LoginErrMsg")%>
					</span>		
	        		<!--  ID 입력란 -->
	            	<input type="text" 
	                   size="25" 
	                   class="form-control" 
	                   name="userId"
	                   placeholder="아이디"
	                   value ="<%= loginId %>"
	                   required />
	                   <br>
	                <input
	                   style=" vertical-align: top;margin-right: 5px;"
	                   type="checkbox" 
	                   name ="save_check"
	                   value ="Y" <%=cookieCheck %> >
	                   <span style="vertical-align: top;
	                   				margin-right: 173px;
	                   				color: blue;">아이디저장</span>
	                    
	        	</div>
	        	<div>
	        		<!--  PW 입력란 -->
	            	<input 
	            	   type="password"
	                   size="25"
	                   class="form-control"
	                   name="userPw" 
	                   placeholder="비밀번호"
	                   required>
	        	</div>
	        	<div>
	            	<!-- 로그인  버튼 -->
	            	<input 
		            	type ="submit" 
		            	size ="40" 
		            	id="loginBtn" 
		            	value ="Log In"
		            	style="width: 100%; background-color: #33CC33; color: white;
	            		  	   font-size: 18px;	">
	            	<div><br></div>
	        	</div>
	    	</form>
	    	<div>
	    		<br>
	    	</div>
	    	<form class  = "form-container"
	    		  action = "signUpStart.do" 
	    		  method = "post">
	    		<div>
	            	<!-- 회원가입 버튼 -->
	            	<button 
	            		id="signupBtn"
	            		style="width: 100%; background-color: #6633CC; color: white;
	            		font-size: 18px;"
	            	>회원가입</button>
	       		</div>
	       	</form>
       	</div>
	</div>
    <%
	} else { // loginId session 에 값이 있는경우 ( 이미 로그인되어있다. )
    %>
    	<%=session.getAttribute("userId")%> 님 로그인된 상태입니다.<br/>
    	<a href= "Logout.jsp">[로그아웃]</a>
    	<a href= "cGoHome.do">[메인으로 가기]</a>
    	
	<%
	}
	%>
	<script>
	//ID PW validation Fuction 
	function validationForm(form){
		let userId = form.userId.value.trim();
		let userPw = form.userPw.value.trim();
		if (userId ===""){
			alert("아이디를 입력하세요")
			form.userId.focus()
			return false
		}
		if (userPw ===""){
			alter("패스워드를 입력하세요.")
			form.userPw.focus()
			return false
		}
		return true
	}
	</script>
     <!-- login 정규식 및 버튼 JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="resources/js/login.js"></script> 

</body>
</html>
