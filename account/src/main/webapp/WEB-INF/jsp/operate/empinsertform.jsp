<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<!-- <link rel="stylesheet" href="css/bootstrap.min.css"> -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<title>사원 추가</title>

<script>
	$(document).ready(
			function() {
				$("#zipCodeList").click(zipCodeListFunc); //우편번호찾기
				$("#joinButton").click(joinFunc); //회원가입버튼
				/* serializeObject는 serializeArray를 사용하여 직접 구현 */
				jQuery.fn.serializeObject = function() { //form 데이터를 object로 바꿔주는 것을 도와줌 
					var obj = null;
					try {
						if (this[0].tagName
								&& this[0].tagName.toUpperCase() == "FORM") { //and 둘다 true
							var arr = this.serializeArray();
							if (arr) {
								obj = {};
								jQuery.each(arr, function() {
									obj[this.name] = this.value;
								});
							}
						}
					} catch (e) {
						alert(e.message);
					} finally {
					}
					return obj;
				}

			});

	function zipCodeListFunc() {
		new daum.Postcode({
			oncomplete : function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
				// 예제를 참고하여 다양한 활용법을 확인해 보세요.
				$("#zipCode").val(data.zonecode);
				$("#basicAddress").val(data.address);
				$("#detailAddress").val(data.buildingName);
			}
		}).open();
	}
	function joinFunc() {
		var userInfoBean = $("#userInfoBean").serializeObject();
				$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/batchemp",
					data : {
						"JoinEmployee" : JSON.stringify(userInfoBean)
					},
					dataType : "json",
					success : function(jsonObj) {
						if (jsonObj.errorCode == 1) {
							alert("사원 등록이 성공적으로 완료되었습니다");
							location.href = "${pageContext.request.contextPath}/operate/employeeForm"
						} else {
							alert("사원 등록이 실패하였습니다. 재 등록 부탁 드립니다.");
						}
					}
				});
	}
</script>
</head>
<body>
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<!-- 점보트론 -->
			<!-- 폼 태그를 비동기 방식으로 전송하기 위해 object로 변환해서 보낸다 -->
			<form method="post" id="userInfoBean">
				<div class="jumbotron" style="padding-top: 20px;">
					<!-- 로그인 정보를 숨기면서 전송post -->
					<h3 style="text-align: center;">사원추가</h3>
					<div class="form-group">
						<input type="text" class="form-control" id="empCode"
							placeholder="사원코드" name="empCode" maxlength="20"> <span
							class="error_next_box" id="idMsg" style="display: none"
							role="alert"></span>
					</div>
					<div class="form-group">
						<input type="password" class="form-control" id="userPw"
							name="userPw" placeholder="비밀번호" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="empName"
							placeholder="이름" name="empName" maxlength="20">
					</div>
					<div class="form-group">
						<select class="form-control" id="deptCode" name="deptCode">
						<option>부서를 선택해 주세요</option>
						<option value="DPT-01">총무부 (DPT-01)</option>
						<option value="DPT-02">영업부 (DPT-02)</option>
						<option value="DPT-03">생산부 (DPT-03)</option>
						<option value="DPT-04">구매부 (DPT-04)</option>
						<option value="DPT-05">인사부 (DPT-05)</option>
						<option value="DPT-06">홍보부 (DPT-06)</option>
						<option value="DPT-07">개발부 (DPT-07)</option>
						</select>
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-primary active"> <input
								type="radio" id="male" name="gender" autocomplete="off"
								value="male" checked>남자
							</label> <label class="btn btn-primary"> <input type="radio"
								id="female" name="gender" autocomplete="off" value="female">여자
							</label>
						</div>
					</div>
					<div class="form-group">
						<input type="text" class="form-control"
							name="socialSecurityNumber" placeholder="주민등록번호 (-없이 입력)"
							id="socialSecurityNumber" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" name="phoneNumber"
							placeholder="핸드폰번호" id="phoneNumber" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" name="email"
							placeholder="E-Mail" id="email" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="생년월일"
							id="birthdate" name="birthdate" maxlength="50">
					</div>
					<div class="form-group">
						<button type="button" class="btn btn-primary" id="zipCodeList"
							value="우편번호 찾기">우편번호 찾기</button>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="우편번호"
							id="zipCode" name="zipCode" maxlength="5">
					</div>
					<div class="form-group">
						<input type="text" class="form-control"
							placeholder="우편번호를 검색하여 넣어주세요" id="basicAddress"
							name="basicAddress" maxlength="50">
					</div>
					<div class="form-group">
						<input type="text" class="form-control"
							placeholder="상세주소 (나머지 주소를 입력하세요)" id="detailAddress"
							name="detailAddress" maxlength="50">
					</div>
					<input type="button" class="btn btn-primary form-control"
						id="joinButton" value="회원가입">
				</div>
			</form>
		</div>
	</div>
</body>
</html>
