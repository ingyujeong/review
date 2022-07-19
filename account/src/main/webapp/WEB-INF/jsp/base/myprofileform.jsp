<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title> 내정보관리</title>
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    <style>  
   .bg2 {
    	background-image:
    		 url("${pageContext.request.contextPath}/assets/img/다운로드.JPG"); 
    	background-size: cover;}
    	</style>
    <script>
  
       
           $(document).ready(function(){
                // input file에 change 이벤트 부여
                
                const inputImage = document.getElementById("selectProfileImage")
                inputImage.addEventListener("change", e => {
                   
                    readImage(e.target)
                });

              $("#reset").click(reset); //취소버튼 클릭시 reset함수 호출
              
              
             $.ajax({
                type: "GET",
                    url: "${pageContext.request.contextPath}/operate/employee",
                    data: {
                        "empCode": "${empCode}"
                    },
                    dataType: "json",
                    success: function(obj){
                    	employee = obj;
                        console.log("DB에서 employee 정보 호출 성공");
                        setInfo(obj);
                    }
                });
            
        });
           function setInfo(employee){ //폼태그에 데이터 셋팅
        	   		console.log("DB에서 받아온 직원 정보");
                    console.log(employee);
                  $("#empName").val(employee.empName);
                  $("#empCode").val(employee.empCode);
                  $("#eMail").val(employee.eMail);
                  $("#userPw").val(employee.userPw);
                  $("#phoneNumber").val(employee.phoneNumber);
                  $("#socialSecurityNumber").val(employee.socialSecurityNumber);
                  $("#zipCode").val(employee.zipCode);
                  $("#basicAddress").val(employee.basicAddress);
                  $("#detailAddress").val(employee.detailAddress);
                  $("#deptCode").val(employee.deptCode);
                  
                  if(employee.image == "")
                     $("#preview-image").attr('src',"https://bfor0312.s3.ap-northeast-2.amazonaws.com/Account71-3rd/profileImage/profile.png")
                  else 
                     $("#preview-image").attr('src',employee.image);
           }
           console.log("DB 정보 현재 페이지에 로드 완료");
           
           $(function(){
              $('#UpdateEmployee').on('click',function(){
                 updateFile();
              })
           })
           
           function updateFile(){ //저장 버튼클릭시 실행되는 로직(회원정보수정)
				console.log("updateFile");
           
				var employee = new Object();           
           
				employee.empName = $("#empName").val();
                  employee.empCode = $("#empCode").val();
                  employee.eMail = $("#eMail").val();
                  employee.userPw = $("#userPw").val();
                  employee.phoneNumber = $("#phoneNumber").val();
                  employee.socialSecurityNumber = $("#socialSecurityNumber").val();
                  employee.zipCode = $("#zipCode").val();
                  employee.basicAddress = $("#basicAddress").val();
                  employee.detailAddress = $("#detailAddress").val();
                  employee.deptCode = $("#deptCode").val();
                  
                  var jsonData = JSON.stringify(employee);
           
           var form = new FormData();
           
           var form = $('#infoForm')[0];
           var s3FileUrl;
              

         
           var formData = new FormData(form);
           formData.append('empCode', employee.empCode);
              

              
              console.log(formData);
              

              
             for (var pair of formData.entries()) {
                  console.log(pair[0]+ ', ' + pair[1]); 
              }
              
              $.ajax({
                  url: "${pageContext.request.contextPath}/base/profileimage",
                  type: "post",
                  data: formData,
                  enctype: 'multipart/form-data',
                  dataType: "json",
                  processData:false,
                  contentType:false,
                  async: false,
                  cache:false,
                  timeout: 600000,
                  success: function(json){
                	  s3FileUrl = json.s3FileUrl;
                     console.log("파일 업로드 성공");
                     console.log(json);
                     console.log("업로드 된 경로 : "+ s3FileUrl);
                 },
                  error:function(err){
                     console.log("에러 : ",err);
                  }
              });  

             $.ajax({
                     url: "${pageContext.request.contextPath}/operate/batchempinfo",
                     type: "post",
                     data: {
                         "employeeInfo": jsonData,
                         "imageUrl" : s3FileUrl
                     },
                     dataType: "json",
                     success: function(){
                     alert("수정되었습니다");
                       
                    }
                 });  
           }
            
           
            function zipCodeListFunc() { //우편번호검색 함수
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
            
             function reset(){ //취소버튼 누르면 페이지가 리로드 된다.
                location.reload();
             }
             
             function inputPhoneNumber(obj) { //하이픈이 자동으로 생기게 하는 함수, 숫자값만 입력되는 기능 추가해야함 
                
                   var number = obj.value.replace(/[^0-9]/g, "");
                   var phone = "";


                   if(number.length < 4) {
                       return number;
                   } else if(number.length < 7) {
                       phone += number.substr(0, 3);
                       phone += "-";
                       phone += number.substr(3);
                   } else if(number.length < 11) {
                       phone += number.substr(0, 3);
                       phone += "-";
                       phone += number.substr(3, 3);
                       phone += "-";
                       phone += number.substr(6);
                   } else {
                       phone += number.substr(0, 3);
                       phone += "-";
                       phone += number.substr(3, 4);
                       phone += "-";
                       phone += number.substr(7);
                   }
                   obj.value = phone;
             }
   

           function uploadImage() {
             $("input#selectProfileImage").click();
            } 
           
           function readImage(input) {
                
                // 인풋 태그에 파일이 있는 경우
                 if(input.files && input.files[0]) {
                    // 이미지 파일인지 검사 (생략)
                    // FileReader 인스턴스 생성
                    const reader = new FileReader()
                    // 이미지가 로드가 된 경우
                    reader.onload = e => {
                        document.getElementById("preview-image").src = e.target.result;
                    }
                    // reader가 이미지 읽도록 하기
                 
                    reader.readAsDataURL(input.files[0])
                } 
            }   


    </script>
</head>

<body class="bg-gradient-primary">
   <div class="container" style="width:auto;height:300px" >

    <div class="card o-hidden border-0 shadow-lg my-5" >
      <div class="card-body p-0">
        <!-- Nested Row within Card Body -->
        <div class="row">
         <div class="col-lg-5 d-none d-lg-block bg2"></div>
         <!--  <div class="col-lg-5 d-none d-lg-block bg-register-image"></div> -->
          <div class="col-lg-7">
            <div class="p-5">
               <form   class="user" id="infoForm" method="post" >
					<input id="selectProfileImage" name="selectProfileImage" type="file"
                                        style="display: none;">
                   <div class="form-group row">
                   
                       <div class="col-sm-6 mb-3 mb-sm-0">
                           <label for="Name">프로필 사진</label>
                           		<i class="fa fa-upload" aria-hidden="true"></i>
                           <div id="profileImageArea">
                               <div class="row imageControl">
                                   <div class="image-container">
                                       <img style="width: 250px; padding:10px;" id="preview-image"
                                        src="${pageContext.request.contextPath}/assets/img/다운로드.JPG" >
                                   </div>

                                   <div class="col-6">                     
                                     <button id="selectProfileButton" name="selectProfileImage" class="btn btn-primary" type="button"  onclick=uploadImage()> <!-- onclick=uploadImage() -->
                                           <i class="fa fa-upload" aria-hidden="true"></i>
                                       </button>
                                   </div>
                                   <div class="col-6">
                                   </div>
                               </div>
                               <!-- <input type="text" class="form-control form-control-user" id="empName" readonly> -->
                           </div>
                       </div>
                   </div>

                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                     <label for="Name">이름</label>
                    <input type="text" class="form-control form-control-user" id="empName" readonly>
                  </div>
                  <div class="col-sm-6">
                     <label for="JuminNum">주민번호</label>
                    <input type="text" class="form-control form-control-user" id="socialSecurityNumber" readonly>
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                     <label for="Code">코드</label>
                    <input type="text" class="form-control form-control-user" id="empCode" readonly>
                  </div>
                  <div class="col-sm-6">
                     <label for="Password">비밀번호</label>
                    <input type="password" class="form-control form-control-user" id="userPw" >
                  </div>
                </div>
                
                <div class="form-group">
                   <label for="Email">이메일</label>
                  <input type="text" class="form-control form-control-user" id="eMail" placeholder="입력된 정보가 없습니다">
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                     <label for="zipCode" class="col-form-label">우편번호</label>
                    <input type="text" class="form-control form-control-user" id="zipCode" readonly>
                  </div>
                  <div class="col-sm-6" style="margin-top:43px; margin-left:-12px;">
                     <button class="btn btn-primary" type="button" onclick="zipCodeListFunc()">
                        <i class="fas fa-search fa-sm"></i>
                     </button>
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                     <label for="basicAddress">기본주소</label>
                    <input type="text" class="form-control form-control-user" id="basicAddress" readonly>
                  </div>
                  <div class="col-sm-6">
                     <label for="detailAddress">상세주소</label>
                    <input type="text" class="form-control form-control-user" id="detailAddress" >
                  </div>
                  <div class="col-sm-6 e;" style="display:none">
                     <label for="deptCode">부서코드</label>
                    <input type="text" class="form-control form-control-user" id="deptCode" >
                  </div>
                </div>
                <hr>
                <button tyepe="button" class="btn btn-user btn-block btn-primary" id="UpdateEmployee" >
               저장      
                </button>
                <button class="btn btn-user btn-block btn-danger " id="reset">
                     취소
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
</body>

</html>