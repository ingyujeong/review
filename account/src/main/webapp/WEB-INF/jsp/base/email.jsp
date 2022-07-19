<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>이메일 보내기</h2>
<!-- post방식으로 자료를 컨트롤러로 보냄 -->
<script>


function sendMail() {
	$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/base/send.do",
				data : {
					"senderName" : $("senderName").val(),
					"receiveMail" : $("#receiveMail").val(),
					"subject"     : $("#subject").val(),
					"message"     : $("#message").val()
				},
				dataType : "json",
				success : function(jsonObj) {
					  alert("이메일 전송 성공!");
				}
		});
}
</script>
발신자 이름 : <input id="senderName" value="${sessionScope.empCode}" readonly><br>
발신자 이메일 : <input id="senderMail" value="seoulit50@gmail.com" readonly><br> <!-- 비밀번호 써야해서 seoulit50@gmail.com에서 보내도록 해놓음 -->
수신자 이메일 : <input id="receiveMail"><br>
제목 : <input id="subject"><br>
내용 : <textarea rows="5" cols="80" id="message"></textarea>
<br>
<input type="button" value="전송" id="send" onclick="sendMail()">
<span style="color:red;">${message}</span>
 
</body>
</html>
