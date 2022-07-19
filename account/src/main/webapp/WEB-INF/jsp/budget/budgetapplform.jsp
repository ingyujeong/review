<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
  
  	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	
  	<!-- validate -->

<script type="text/javascript"
	src="${pageContext.request.contextPath}/assets/plugins/jquery.validate.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/assets/plugins/functionValidate.js"></script>
<style type="text/css">
input.error, text.error {
	border: 2px solid #FD7D86;
}

label.error {
	color: #FD7D86;
	font-weight: 400;
	font-size: 0.75em;
	margin-top: 7px;
	margin-left: 6px;
	margin-right: 6px;
}

.btnsize{
  		width: 80px;
		height:30px;
		font-size:0.8em;
		font-align:center;
		color:black;
  	}
  	.btnsize2{
  		width: 60px;
		height:30px;
		font-size:0.9em;
		color:black;
  	}
  	.modal-dialog.workplce{
  	 width: 100%; height: 100%; margin: 0; padding: 0;
  	}
  	
</style>
<script>
$(document).ready(function () {
	 $('input:button').hover(function() {
		 $(this).css("background-color","#D8D8D8");//버튼 hover이벤트 색상변경
		}, function(){
		$(this).css("background-color","");
	 });

	createAccountPeriod();
	$("#searchPeriod").click(showAccountPeriod);//버튼 누를시
	
	createWorkplace();
	$("#searchWorkplace").click(showWorkplace);//버튼 누를시
	
	createDepartment();//그리드생성 사업장,부서
	
    createParentBudget();//그리드생성 계정과목코드,계정과목
    createDetailBudget(); //그리드생성 ParentBudget눌렀을때의 계정과목코드,계정과목
    
    for(var i=1; i<=17; i++){
    	var input=document.querySelector("#c"+i);
    	input.disabled=true;
    }
    //input에 이벤트 달기
    for(var i=1; i<=12;i++){
    	var input=document.querySelector("#m"+i);	//td1번~12번
    	input.oninput=checkNum;//값을 넣을때 발생하는 이벤트
    	input.onchange=qRefresh;//값이 변경될시 발생하는 이벤트

    	input.disabled=true;
    }
    
    for(var i=1;i<=4;i++){
    	var q=document.querySelector("#q"+i);
		q.oninput=checkNum;
		q.onchange=checkNum;
		
		q.disabled=true;
    }
    
    var sum=document.querySelector("#sum");
    sum.disabled=true;
    
    var orgBudegtBtn=document.querySelector("#orgBudgetBtn");//버튼
    orgBudgetBtn.onclick=orgBudget;	//버튼누름
    
});

var dataSet={
	"deptCode":"",
	"workplaceCode":"",
	"accountInnerCode":"",
	"accountPeriodNo":"",
	"budgetingCode":"1",
	"m1Budget":"",
	"m2Budget":"",
	"m3Budget":"",
	"m4Budget":"",
	"m5Budget":"",
	"m6Budget":"",
	"m7Budget":"",
	"m8Budget":"",
	"m9Budget":"",
	"m10Budget":"",
	"m11Budget":"",
	"m12Budget":""
	};
	
	function orgBudget(){
		for(var i=1;i<=12;i++){
			var input=document.querySelector("#m"+i);//m1~m12
			var inputInt=input.value.split(",").join("");//보낸값이 담김 
			dataSet["m"+i+"Budget"]=parseInt(inputInt);//m1Budet1~12에 담은 값
			}
		
		$.ajax({
	        type: "POST",
	        url: "${pageContext.request.contextPath}/budget/budgetlist",
	        data: {
	            "budgetObj":JSON.stringify(dataSet)
	        },//dataSet정보
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {
	        	console.log(jsonObj);
	            alert("신청 완료");
	        }
	    });
	}

function createAccountPeriod(){//회계연도
	rowData=[];
  	var columnDefs = [
  		{headerName: "회계기수", hide:"true" ,field: "accountPeriodNo",sort:"asc", width:100
	      },
	      {headerName: "회계연도", field: "fiscalYear",sort:"asc", width:100
	      },
	      {headerName: "회계시작일", field: "periodStartDate",width:250},
	      {headerName: "회계종료일", field: "periodEndDate",width:250},
	  ];	  	
	  gridOptions3 = {
			      columnDefs: columnDefs,
			      rowSelection:'single', //row는 하나만 선택 가능
			      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
	 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
	        			event.api.sizeColumnsToFit();//사이즈 맞춰줌
	    		  },
	    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
	    		        event.api.sizeColumnsToFit(); //사이즈 맞춰줌
	    		  },
	    		  onRowClicked:function (event){//클릭시
	    			  console.log("Row선택");
	    			  selectedRow=event.data;//이벤트가 일어난 행의 정보
	    			  $("#fiscalYear").val(selectedRow["fiscalYear"]);//선택한 행의 연도
	    			  $("#accountYearModal").modal("hide");//모달창을 하이드시킴
	    			  checkElement();//호출
	    			  console.log("dataSet"+dataSet["accountPeriodNo"]);
	    			  console.log("selectedRow"+selectedRow["accountPeriodNo"]);
	    			  dataSet["accountPeriodNo"]=selectedRow["accountPeriodNo"];//내가 선택한 연도    			
	    		  }
	   }
	  accountGrid = document.querySelector('#accountYearGrid');
		new agGrid.Grid(accountGrid,gridOptions3);//ag그리드 생성
 }
 
 function showAccountPeriod(){//show로 이름이 정의되어있지만 값을 넣는것임
	 
	 $.ajax({
	        type: "GET",
	        url: "${pageContext.request.contextPath}/operate/accountperiodlist",
	        data: {
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {
	        	console.log(jsonObj);
	            gridOptions3.api.setRowData(jsonObj);//회계 연도에 값 넣음
	        }
	    });
	 
 }
 
 function createWorkplace(){
	 rowData=[];
	  	var columnDefs = [
	  		{headerName: "사업장코드", field: "workplaceCode",sort:"asc", width:200
		      },
		      {headerName: "사업장명", field: "workplaceName",width:250},
		  ];	  	
		  gridOptions4 = {
				      columnDefs: columnDefs,
				      rowSelection:'single', //row는 하나만 선택 가능
				      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
		 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
		        			event.api.sizeColumnsToFit();
		    		  },
		    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
		    		        event.api.sizeColumnsToFit();
		    		  },
		    		  onRowClicked:function (event){
		    			  console.log("Row선택");
		    			  console.log(event.data);
		    			  selectedRow=event.data;
		    			  showDepartment(selectedRow["workplaceCode"]);//내가 선택한 사업장 번호
		    			  console.log(selectedRow["workplaceName"]);
		    			  
		    		  }
		   }
		  workplaceGrid = document.querySelector('#workplaceGrid');
			new agGrid.Grid(workplaceGrid,gridOptions4);
 }
 
 /* ag-Grid 선택된 열의 레코드 반환하는 함수
 function getSelectedRows() {
	    var selectedNodes = gridOptions4.api.getSelectedNodes()
	    var selectedData = selectedNodes.map( function(node) { return node.data })
	    var selectedDataStringPresentation = selectedData.map( function(node) { return node.workplaceName })
	    alert('Selected nodes: ' + selectedDataStringPresentation);
	}
 */
 function createDepartment(){//사업장,부서그리드
	 rowData=[];
	  	var columnDefs = [
	  		{headerName: "사업장코드", hide:"true",field: "workplaceCode",sort:"asc", width:100
		      },
		      {headerName: "사업장명", hide:"true", field: "workplaceName",width:250},
	  		{headerName: "부서코드", field: "deptCode",sort:"asc", width:200
		      },
		      {headerName: "부서명", field: "deptName",width:250},
		  ];	  	
		  gridOptions5 = {
				      columnDefs: columnDefs,
				      rowSelection:'single', //row는 하나만 선택 가능
				      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
		 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
		        			event.api.sizeColumnsToFit();
		    		  },
		    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
		    		        event.api.sizeColumnsToFit();
		    		  },
		    		  onRowClicked:function (event){//행을 클릭시
		    			  console.log("여기");
		    			  console.log("Row선택");
		    			  console.log(event.data);
		    			  selectedRow=event.data;//선택한행 정보
		    			  $("#workplace").val(selectedRow["workplaceName"]);//선택한 사업장명
		    			  $("#dept").val(selectedRow["deptName"]);//선택한 부서명
		    			  $("#workplaceModal").modal("hide");//모달창 닫힘
		    			  checkElement();//회계연도,사업장,부서 모두 클릭 했는지 여부
		    			  console.log(selectedRow["deptName"])
		    			  dataSet["workplaceCode"]=selectedRow["workplaceCode"];//dataSet에 내가선택한 사업장이 담김
		    			  dataSet["deptCode"]=selectedRow["deptCode"];//dataset에 내가 선택한 부서번호가 담김
		    		  }
		   }
		  deptGrid = document.querySelector('#deptGrid');
			new agGrid.Grid(deptGrid,gridOptions5);//사업장그리드 생성
 }
 
 function showWorkplace(){
	 $.ajax({
	        type: "GET",
	        url: "${pageContext.request.contextPath}/operate/deptlist",
	        data: {
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {//brc-02-삼성중앙연구소,brc-01-삼성월스토리
	        	console.log(jsonObj);
	            gridOptions4.api.setRowData(jsonObj);//결과값을 행에 추가
	        }
	    });
 }

 function showDepartment(workplaceCode){//내가 선택한 사업장 코드
	 $.ajax({
	        type: "GET",
	        url: "${pageContext.request.contextPath}/operate/detaildeptlist",
	        data: {
	            "method": "findDetailDeptList",
	            "workplaceCode":workplaceCode,
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {//사업자코드에 맞는 사업소명,부서코드,부서명가져옴
	        	console.log(jsonObj);
	            gridOptions5.api.setRowData(jsonObj);//데이터를 행에추가
	        }
	    });
 }
 
function createParentBudget(){//좌측 그리드
	rowData=[];
  	var columnDefs = [
	      {headerName: "계정과목 코드", field: "accountInnerCode",sort:"asc", width:100
	      },
	      {headerName: "계정과목", field: "accountName",width:250},
	  ];	  	
	  gridOptions = {
			      columnDefs: columnDefs,
			      rowSelection:'single', //row는 하나만 선택 가능
			      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
	 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
	        			event.api.sizeColumnsToFit();
	    		  },
	    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
	    		        event.api.sizeColumnsToFit();
	    		  },
	    		  onRowClicked:function (event){//누를시
	    			  console.log("Row선택");
	    			  console.log(event.data);
	    			  selectedRow=event.data;
	    			  showDetailBudget(selectedRow["accountInnerCode"]);
	    		  }
	   }
	  accountGrid = document.querySelector('#parentBudgetGrid');
		new agGrid.Grid(accountGrid,gridOptions);
 }
 
function createDetailBudget() {
	rowData=[];
  	var columnDefs = [
	      {headerName: "계정과목 코드", field: "accountInnerCode",width:100},
	      {headerName: "계정과목", field: "accountName", width:250},
	  ];	  	
	 gridOptions2 = {
			      columnDefs: columnDefs,
			      rowSelection:'single', //row는 하나만 선택 가능
			      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
	 			  onGridReady: function (event)	{// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
	        			event.api.sizeColumnsToFit();
	    		  },
	    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
	    		        event.api.sizeColumnsToFit();
	    		  },
	    		  onRowClicked:function (event){	//행을 클릭시
	    			  console.log("Row선택");
	    			  selectedRow=event.data;	//클릭한행의 데이터를 selectRow에 담음
	    			
	    			  dataSet["accountInnerCode"]=selectedRow["accountInnerCode"];//dataSet의 accountInnerCode가 내가 선택한 행의 값으로 변경

	    			  showOrganizedBudget();//출력되는 td행에 관함
	    		  }
	   }
	 accountDetailGrid = document.querySelector('#detailBudgetGrid');//id를 찾아 변수에담음
	 	new agGrid.Grid(accountDetailGrid,gridOptions2);//그리드생성
}

function showOrganizedBudget(){
	console.log(dataSet);
	
	console.log(JSON.stringify(dataSet));
	
	$.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/budget/budgetappl",
        data: {
            "budgetObj":JSON.stringify(dataSet)
        },//선택한 행의 데이터에서 부서번호 사업장코드 계정코드, 기수 전송
        dataType: "json",
        async:false,
        success: function (jsonObj){
        	
        	if(jsonObj.errorCode==-1){//에러코드일시 
        		for(var i=1;i<=12;i++){
        			var input=document.querySelector("#m"+i);//m1~12
            		input.value=0;//넣는값 0
            		if(i%3==0){
            			var q=document.querySelector("#q"+i/3);
            			q.value=0;//분기값 0
            		}
        		}
        	}
        	
        	console.log(jsonObj);
        	//console.log(jsonObj.budgetBean);
        	//console.log(jsonObj.budgetBean.m1Budget);
        	//var json=JSON.parse(jsonObj.budgetBean);
        	//성공시
        	var num=0;
        	for(var i=1; i<=12;i++){//td개수만큼 for문
        		var input=document.querySelector("#m"+i);//m1~m12
        		input.disabled=false;//비활성화를 활성화로 변경
        		if(jsonObj.budgetBean["m"+i+"Budget"]||jsonObj.budgetBean["m"+i+"Budget"]==0){//받아온값 있거나 0일시
        			var value=jsonObj.budgetBean["m"+i+"Budget"]+"";//numToMoney 함수 적용하기
        			input.value=numToMoney(value);//빈값 ""을 보내줌"
        			num+=jsonObj.budgetBean["m"+i+"Budget"];//num=1~12
        				
        			if(i%3==0){
        				var q=document.querySelector("#q"+i/3);
        				q.disabled=false;
        				q.value=numToMoney(num+"");
        				num=0;

        				var sum=document.querySelector("#sum");
            			sum.disabled=false;
            			var n1=eval(q1.value);
            			var n2=eval(q2.value);
            			var n3=eval(q3.value);
            			var n4=eval(q4.value);
            			
            			sum.value=n1+n2+n3+n4;
        			}	        		
        		}        		
        	}
        }
    });
}

//숫자를 돈 형식으로 바꿔주는 함수
function numToMoney(value){//10000
    
    var length=value.length;//길이
    var valueArray=value.split("");//빈공간 ""을 기준으로 잘라서 배열에 넣음->모든숫자가 다 잘림 100-> 1/0/0
    var strBuffer=[];//빈배열
    for(var i in valueArray){//배열이 가지고 있는 인덱스만큼 가져오겠다
        if((i-3)%3==0&&i!=0) strBuffer.unshift(",");//세글자마다,이붙음
        strBuffer.unshift(value[length-1-i]);//배열 앞에 요소추가
    }
    console.log(strBuffer);
value=strBuffer.join("");//자른값이 붙어짐
return value;
}



function checkElement(){//회계연도,사업장,부서가 다입력되어있을시 왼쪽 그리드를 호출하는 로직
	if($("#fiscalYear").val()&&$("#workplace").val()&&$("#dept").val())
		showParentBudget();//왼쪽 그리드
}

function showParentBudget(){//왼쪽 그리드 값 할당
	
	$.ajax({
        type: "GET",
        url: "${pageContext.request.contextPath}/operate/parentbudgetlist",
        data: {
        },
        dataType: "json",
        async:false,
        success: function (jsonObj) {
        	console.log(jsonObj);
            gridOptions.api.setRowData(jsonObj);//왼쪽 그리드에 값 넣음
        }
    });	
}

function showDetailBudget(code){//우측 그리드	좌측 그리드에서 선택한행의 accountInnerCode(계정과목코드) 정보를 가져옴
	console.log(code);
	
	$.ajax({
        type: "GET",
        url: "${pageContext.request.contextPath}/operate/detailbudgetlist",
        data: {
            "code": code
        },
        dataType: "json",
        async:false,
        success: function (jsonObj) {//ex 0501	0501-0600 0501 원재료비/ 값 받아와서 계정과목 코드와 계정과목만 씀
        	console.log(jsonObj);
            gridOptions2.api.setRowData(jsonObj); //데이터 삽입
        }
    });	
}


function qRefresh(){
	var num=0;
    for(var i=1; i<=12;i++){
    	var input=document.querySelector("#m"+i);//m1~m12
    	num+=parseInt(input.value.split(",").join(""));//인풋의 밸류값이, 즉 3글자마다 잘린것에대해 숫자로 바꿈
    	if(i%3==0){//i에 3을나눠서 0일떄 즉 3,6,9,12일시
			var q=document.querySelector("#q"+i/3);//분기1,2,3,4
			q.value=numToMoney(num+"");//돈형식으로 만들어주는 함수에 전송
			num=0;
		}
    }
}

function checkNum(){
	this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1').replace(/(^0+)/, "");
    var length=this.value.length;
    var value=this.value.split("");
    console.log(value);
    var strBuffer=[];
    for(var i in value){
        if((i-3)%3==0&&i!=0) strBuffer.unshift(",");
        strBuffer.unshift(value[length-1-i]);//
    }
this.value=strBuffer.join("");
console.log("checkNum: "+this.value);
	        }
	    
	    

	        
	        /*
function checkMonetaryFormat(){
	strBuffer=[];
	var i=Math.floor(this.value.length);
	if(i=>1){
		for(i*3<)
	}
}
	        */
</script>
<title>예산 신청</title>
</head>
<body>
      <h4>예산 신청</h4>
      <hr>
      <div class="row">
                  <div  class="col-sm-4 mb-3 mb-sm-0 input-group">
                  	<label for="example-text-input" class="col-form-label">회계연도</label>
                    <input   style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user" id="fiscalYear" placeholder="fiscalYear" disabled="disabled">

                  <div class="input-group-append">
                  	<button class="btn btn-primary" type="button" data-toggle="modal"
                  		data-target="#accountYearModal" id="searchPeriod">
                  		<i class="fas fa-search fa-sm"></i>
                  	</button>
                  </div>
                </div>

                  <div class="col-sm-4 mb-3 mb-sm-0 input-group">
                  	<label for="example-text-input" class="col-form-label">사업장</label>
                    <input style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user" id="workplace" placeholder="workplace" disabled="disabled">

                  <div class="input-group-append">
                  	<button title="사업장, 부서 검색" class="btn btn-primary" type="button" data-toggle="modal"
                  		data-target="#workplaceModal" id="searchWorkplace">
                  		<i class="fas fa-search fa-sm"></i>
                  	</button>
                  </div>
                </div>
                <div class="col-sm-3 mb-3 mb-sm-0 input-group">
                  	<label for="example-text-input" class="col-form-label">부서</label>
                    <input style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user" id="dept" placeholder="부서명" disabled="disabled">

<!--  부서 검색 버튼
                  <div class="input-group-append">
                  	<button class="btn btn-primary" type="button" data-toggle="modal"
                  		data-target="#deptModal" id="searchDept">
                  		<i class="fas fa-search fa-sm"></i>
                  	</button>
                  </div>
                </div>
                
-->
</div>
                <hr>
                <!-- 
<table style="width:100%;">
 <tr>
  <td>
   <div align="left" style="padding:10px;">
    <div align="center">
	 <div id="parentBudgetGrid" class="ag-theme-balham"  style="height:250px;width:auto;" ></div>
    </div>
   </div>
  </td>
  <td>
   <div align="right" style="padding:10px;">
    <div align="center">
	 <div id="detailBudgetGrid" class="ag-theme-balham" style="height:250px;width:auto;"></div>
    </div>
   </div>
  </td>
 </tr>
</table>
 -->
 <div style="width:100%;"><hr></div>
<hr><br>
   <div align="center" style="float:left; width:40%;">
    <div align="center">
	 <div id="parentBudgetGrid" class="ag-theme-balham"  style="margin-right:10px;height:250px;width:auto%;" ></div>
    </div>
   </div>

   <div align="center" style="float:right; width:40%;">
    <div align="center">
	 <div id="detailBudgetGrid" class="ag-theme-balham" style="height:250px;width:auto%;"></div>
    </div>
   </div>

      <div style="width:100%;"><hr></div>
      <h6>&nbsp;&nbsp;&nbsp;전기 예산 신청</h6>
      <div class="row" align="left" style="width:100%; padding:10px;">
      <small>
      <table>
      <tr><td>월</td><td>금액</td><td>월</td><td>금액</td><td>월</td><td>금액</td><td>분기</td><td>금액</td></tr>
      <tr><td>01</td><td><input id="c1" type="text"></td><td>02</td><td><input id="c2" type="text"></td><td>03</td><td><input id="c3" type="text"></td><td>1분기</td><td><input id="c13" type="text" readonly></td></tr>
      <tr><td>04</td><td><input id="c4" type="text"></td><td>05</td><td><input id="c5" type="text"></td><td>06</td><td><input id="c6" type="text"></td><td>2분기</td><td><input id="c14" type="text" readonly></td></tr>
      <tr><td>07</td><td><input id="c7" type="text"></td><td>08</td><td><input id="c8" type="text"></td><td>09</td><td><input id="c9" type="text"></td><td>3분기</td><td><input id="c15" type="text" readonly></td></tr>
      <tr><td>10</td><td><input id="c10" type="text"></td><td>11</td><td><input id="c11" type="text"></td><td>12</td><td><input id="c12" type="text"></td><td>4분기</td><td><input id="c16" type="text" readonly></td></tr>
      <tr><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td><td>합계</td><td><input id="c17" type="text"></td></tr> 
      </table>
      </small>
      </div>
	
	
      <h6>&nbsp;&nbsp;&nbsp;당기 예산 신청</h6>
      <div class="row" align="left" style="width:100%; padding:10px;">
      <small>
      <table>
      <tr><td>월</td><td>금액</td><td>월</td><td>금액</td><td>월</td><td>금액</td><td>분기</td><td>금액</td></tr>
      <tr><td>01</td><td><input id="m1" type="text"></td><td>02</td><td><input id="m2" type="text"></td><td>03</td><td><input id="m3" type="text"></td><td>1분기</td><td><input id="q1" type="text" readonly></td></tr>
      <tr><td>04</td><td><input id="m4" type="text"></td><td>05</td><td><input id="m5" type="text"></td><td>06</td><td><input id="m6" type="text"></td><td>2분기</td><td><input id="q2" type="text" readonly></td></tr>
      <tr><td>07</td><td><input id="m7" type="text"></td><td>08</td><td><input id="m8" type="text"></td><td>09</td><td><input id="m9" type="text"></td><td>3분기</td><td><input id="q3" type="text" readonly></td></tr>
      <tr><td>10</td><td><input id="m10" type="text"></td><td>11</td><td><input id="m11" type="text"></td><td>12</td><td><input id="m12" type="text"></td><td>4분기</td><td><input id="q4" type="text" readonly></td></tr>
      <tr><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td><td>합계</td><td><input id="sum" type="text"></td></tr>  
      </table>
      </small>
      </div>
      
      <div class="row" style="padding:10px;">
      <input type="button" id="orgBudgetBtn" value="예산신청" class="btn btn-Light shadow-sm btnsize" style="margin-left:5px;">
      </div>
      <div class="row" style="padding:10px;">
      <input type="button" value="새로고침" onClick="window.location.reload()" class="btn btn-Light shadow-sm btnsize" style="margin-left:5px;">
      </div>
      
      	<div align="center" class="modal fade" id="accountYearModal" tabindex="-1"
		role="dialog" aria-labelledby="accountLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="accountYearModal">회계연도</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<hr>
			<div class="modal-body" >
				<div style="float: center; width: 100%;">
					<div align="center">
						<div id="accountYearGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
	
	<div align="left" class="modal fade" id="workplaceModal" tabindex="-1"
		role="dialog" aria-labelledby="workplaceLabel">
	<div class="modal-dialog" role="document">
			<div class="modal-content" align="left" style="width:600px; height:100%;"> <!-- 모달 크기 조절 -->
				<div class="modal-header">
					<h5 class="modal-title" id="workplaceModal">사업장, 부서</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<hr>
			<div class="modal-body" >
				<div style="float: left; width: 50%;">
					<div align="center">
						<div id="workplaceGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
				<div style="float: left; width: 50%;">
					<div align="center">
						<div id="deptGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
	
	<div align="center" class="modal fade" id="deptModal" tabindex="-1"
		role="dialog" aria-labelledby="deptLabel">
	<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="deptModal">부서</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<hr>
			<div class="modal-body" >
				<div style="float: left; width: 50%;">
					<div align="center">
						<div id="parentDeptGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
				<div style="float: left; width: 50%;">
					<div align="center">
						<div id="detailDeptGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>
