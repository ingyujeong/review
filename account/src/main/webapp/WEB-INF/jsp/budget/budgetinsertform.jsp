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
		 $(this).css("background-color","#D8D8D8");
		}, function(){
		$(this).css("background-color","");
	 });
	
	createAccountPeriod();
	$("#searchPeriod").click(showAccountPeriod);
	
	createWorkplace();
	$("#searchWorkplace").click(showWorkplace);
	
	$("#copy").click(showCopy);
	
	createDepartment();
	
    createParentBudget();
    createDetailBudget(); 
    
    //input에 이벤트 달기
    for(var i=1; i<=12;i++){
    	var input2=document.querySelector("#am"+i);
    	input2.disabled=true;
    	
    	var input=document.querySelector("#m"+i);
    	input.oninput=checkNum;
    	input.onchange=qRefresh;
    	input.disabled=true;
    }
    for(var i=1;i<=4;i++){
    	var aq=document.querySelector("#aq"+i);
		aq.disabled=true;
		
    	var q=document.querySelector("#q"+i);
		q.disabled=true;
		
    }
    for(var i=1;i<=1;i++){
    	var msum=document.querySelector("#msum");
    	msum.disabled=true;
    }
    
    for(var i=1;i<=4;i++){
    	var q=document.querySelector("#q"+i);
    	console.log(q)
		q.oninput=checkNum;
		q.onchange=checkNum;
		
    }
    
    var orgBudegtBtn=document.querySelector("#orgBudgetBtn");
    orgBudgetBtn.onclick=orgBudget;	
    
});

var dataSet={
	"deptCode":"",
	"workplaceCode":"",
	"accountInnerCode":"",
	"accountPeriodNo":"",
	"budgetingCode":"2",
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
	
var ApplBudget={
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
	
   function showCopy(){
    	for(var i=1; i<=12;i++){
    		var input1=document.querySelector("#am"+i);
    		var input2=document.querySelector("#m"+i);
    		input2.value=input1.value;
    	}
    	for(var i=1; i<=3; i++){
    		var input1=document.querySelector("#aq"+i);
    		var input2=document.querySelector("#q"+i);
    		input2.value=input1.value;
    	}
    		var input1=document.querySelector("#sum");
			var input2=document.querySelector("#msum");
			input2.value=input1.value;
    }
	
	function orgBudget(){
		for(var i=1;i<=12;i++){
			var input=document.querySelector("#m"+i);
			var inputInt=input.value.split(",").join("");
			dataSet["m"+i+"Budget"]=parseInt(inputInt);
			//dataSet["m"+i+"Budget"]=parseInt(input.value);
			}
		console.log(dataSet);
		
		$.ajax({
	        type: "POST",
	        url: "${pageContext.request.contextPath}/budget/budgetlist",
	        data: {
	            "budgetObj":JSON.stringify(dataSet)
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {
	        	console.log(jsonObj);
	            
	            var result=document.querySelector("#result");
	            //result.value="편성 완료";
	            alert("편성 완료");
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
	        			event.api.sizeColumnsToFit();
	    		  },
	    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
	    		        event.api.sizeColumnsToFit();
	    		  },
	    		  onRowClicked:function (event){
	    			  console.log("Row선택");
	    			  console.log(event.data);
	    			  selectedRow=event.data;
	    			  $("#fiscalYear").val(selectedRow["fiscalYear"]);
	    			  $("#accountYearModal").modal("hide");
	    			  checkElement();
	    			  console.log(selectedRow["accountPeriodNo"])
	    			  dataSet["accountPeriodNo"]=selectedRow["accountPeriodNo"];	    		
	    			  ApplBudget["accountPeriodNo"]=selectedRow["accountPeriodNo"];
	    		  }
	   }
	  accountGrid = document.querySelector('#accountYearGrid');
		new agGrid.Grid(accountGrid,gridOptions3);
 }
 
 function showAccountPeriod(){
	 
	 $.ajax({
	        type: "GET",
	        url: "${pageContext.request.contextPath}/operate/accountperiodlist",
	        data: {
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {
	        	console.log(jsonObj);
	            gridOptions3.api.setRowData(jsonObj);
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
		    			  showDepartment(selectedRow["workplaceCode"]);
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
 function createDepartment(){
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
		    		  onRowClicked:function (event){
		    			  console.log("Row선택");
		    			  console.log(event.data);
		    			  selectedRow=event.data;
		    			  $("#workplace").val(selectedRow["workplaceName"]);
		    			  $("#dept").val(selectedRow["deptName"]);
		    			  $("#workplaceModal").modal("hide");
		    			  checkElement();
		    			  console.log(selectedRow["deptName"])
		    			  dataSet["workplaceCode"]=selectedRow["workplaceCode"];
		    			  dataSet["deptCode"]=selectedRow["deptCode"];
		    			  ApplBudget["workplaceCode"]=selectedRow["workplaceCode"];
		    			  ApplBudget["deptCode"]=selectedRow["deptCode"];
		    		  }
		   }
		  deptGrid = document.querySelector('#deptGrid');
			new agGrid.Grid(deptGrid,gridOptions5);
 }
 
 function showWorkplace(){
	 $.ajax({
	        type: "GET",
	        url: "${pageContext.request.contextPath}/operate/deptlist",
	        data: {
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {
	        	console.log(jsonObj);
	            gridOptions4.api.setRowData(jsonObj);
	        }
	    });
 }

 function showDepartment(workplaceCode){
	 $.ajax({
	        type: "GET",
	        url: "${pageContext.request.contextPath}/operate/detaildeptlist",
	        data: {
	            "workplaceCode":workplaceCode,
	        },
	        dataType: "json",
	        async:false,
	        success: function (jsonObj) {
	        	console.log(jsonObj);
	            gridOptions5.api.setRowData(jsonObj);
	        }
	    });
 }
 
function createParentBudget(){
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
	    		  onRowClicked:function (event){
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
	 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
	        			event.api.sizeColumnsToFit();
	    		  },
	    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
	    		        event.api.sizeColumnsToFit();
	    		  },
	    		  onRowClicked:function (event){
	    			  console.log("Row선택");
	    			  selectedRow=event.data;
	    			
	    			  dataSet["accountInnerCode"]=selectedRow["accountInnerCode"];
	    			  ApplBudget["accountInnerCode"]=selectedRow["accountInnerCode"];
	    			  
	    			  showAppliedBudget();
	    			  showOrganizedBudget();
	    		  }
	   }
	 accountDetailGrid = document.querySelector('#detailBudgetGrid');
	 	new agGrid.Grid(accountDetailGrid,gridOptions2);
}

function showParentBudget(){
	
	$.ajax({
        type: "GET",
        url: "${pageContext.request.contextPath}/operate/parentbudgetlist",
        data: {
        },
        dataType: "json",
        async:false,
        success: function (jsonObj) {
        	console.log(jsonObj);
            gridOptions.api.setRowData(jsonObj);
        }
    });
	
}

function showDetailBudget(code){
	console.log(code);
	
	$.ajax({
        type: "GET",
        url: "${pageContext.request.contextPath}/operate/detailbudgetlist",
        data: {
            "code": code
        },
        dataType: "json",
        async:false,
        success: function (jsonObj) {
        	console.log(jsonObj);
            gridOptions2.api.setRowData(jsonObj);
        }
    });
	
}

function checkElement(){
	if($("#fiscalYear").val()&&$("#workplace").val()&&$("#dept").val())
		showParentBudget();
}

function showOrganizedBudget(){

	$.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/budget/budget",
        data: {
            "budgetObj":JSON.stringify(dataSet)
        },
        dataType: "json",
        async:false,
        success: function (jsonObj) {
        	
        	if(jsonObj.errorCode==-1){
        		for(var i=1;i<=12;i++){
        			var input=document.querySelector("#m"+i);
            		input.value=0;
            		if(i%3==0){
            			var q=document.querySelector("#q"+i/3);
            			q.value=0;
            		}
        		}
        	}
        	
        	console.log(jsonObj);
        	//console.log(jsonObj.budgetBean);
        	//console.log(jsonObj.budgetBean.m1Budget);
        	//var json=JSON.parse(jsonObj.budgetBean);
        	
        	var num=0;
        	for(var i=1; i<=12;i++){
        		var input=document.querySelector("#m"+i);
        		input.disabled=false;
        		if(jsonObj["m"+i+"Budget"]||jsonObj["m"+i+"Budget"]==0){
        			var value=jsonObj["m"+i+"Budget"]+"";//numToMoney 함수 적용하기
        			input.value=numToMoney(value);
        			num+=jsonObj["m"+i+"Budget"];
    				
        			if(i%3==0){
        				var q=document.querySelector("#q"+i/3);
        				q.disabled=false;
        				q.value=numToMoney(num+"");
        				num=0;
            			var msum=document.querySelector("#msum");
            			msum.disabled=false;
            			var n1=eval(q1.value);
            			var n2=eval(q2.value);
            			var n3=eval(q3.value);
            			var n4=eval(q4.value);
    					msum.value=n1+n2+n3+n4;
        			}
        		}
        		
        	}
        }
    });
}


function showAppliedBudget(){

	$.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/budget/budgetappl",
        data: {
            "budgetObj":JSON.stringify(ApplBudget)
        },
        dataType: "json",
        async:false,
        success: function (jsonObj) {
        	
        	if(jsonObj.errorCode==-1){
        		for(var i=1;i<=12;i++){
        			var input=document.querySelector("#am"+i);
            		input.value=0;
            		if(i%3==0){
            			var q=document.querySelector("#aq"+i/3);
            			q.value=0;
            		}
        		}
        	}
        	
        	console.log(jsonObj);
        	//console.log(jsonObj.budgetBean);
        	//console.log(jsonObj.budgetBean.m1Budget);
        	//var json=JSON.parse(jsonObj.budgetBean);
        	
        	var num=0;
        	for(var i=1; i<=12;i++){
        		var input=document.querySelector("#am"+i);
        		if(jsonObj)
        			if(jsonObj["m"+i+"Budget"]||jsonObj["m"+i+"Budget"]==0){
        		var value=jsonObj["m"+i+"Budget"]+"";//numToMoney 함수 적용하기
        		input.value=numToMoney(value);
        		num+=jsonObj["m"+i+"Budget"];
        		if(i%3==0){
        			var q=document.querySelector("#aq"+i/3);
        			q.value=numToMoney(num+"");
        			num=0;
					if(q.value!=0){
	            		var total=document.querySelector("#sum");
	            		total.value+=q.value;
					}
        		}	
        		
        		}
        		
        	}
        }
    });
}

function qRefresh(){
	var num=0;
    for(var i=1; i<=12;i++){
    	var input=document.querySelector("#m"+i);
    	num+=parseInt(input.value.split(",").join(""));
    	if(i%3==0){
			var q=document.querySelector("#q"+i/3);
			q.value=numToMoney(num+"");
			num=0;
		}
    }
}

function checkNum(){
	console.log("AAAAAAAAAAAAA");
	this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1').replace(/(^0+)/, "");
    var length=this.value.length;
    var value=this.value.split("");
    console.log(value);
    var strBuffer=[];
    for(var i in value){
        if((i-3)%3==0&&i!=0) strBuffer.unshift(",");
        strBuffer.unshift(value[length-1-i]);
    }
this.value=strBuffer.join("");
console.log("checkNum: "+this.value);
	        }
	    
	    
//숫자를 돈 형식으로 바꿔주는 함수
function numToMoney(value){
    
    var length=value.length;
    var valueArray=value.split("");
    var strBuffer=[];
    for(var i in valueArray){
        if((i-3)%3==0&&i!=0) strBuffer.unshift(",");
        strBuffer.unshift(value[length-1-i]);
    }
    console.log(strBuffer);
value=strBuffer.join("");
return value;
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
<title>예산 편성</title>
</head>
<body>
      <h4>예산 편성</h4>
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
         <h4 style="width:100%;">신청 예산</h4>
      <div class="row" align="left" style="width:100%; padding:10px;">
      <small>
      <table>
      <tr><td>월</td><td>금액</td><td>월</td><td>금액</td><td>월</td><td>금액</td><td>분기</td><td>금액</td></tr>
      <tr><td>01</td><td><input id="am1" type="text"></td><td>02</td><td><input id="am2" type="text"></td><td>03</td><td><input id="am3" type="text"></td><td>1분기</td><td><input id="aq1" type="text" readonly></td></tr>
      <tr><td>04</td><td><input id="am4" type="text"></td><td>05</td><td><input id="am5" type="text"></td><td>06</td><td><input id="am6" type="text"></td><td>2분기</td><td><input id="aq2" type="text" readonly></td></tr>
      <tr><td>07</td><td><input id="am7" type="text"></td><td>08</td><td><input id="am8" type="text"></td><td>09</td><td><input id="am9" type="text"></td><td>3분기</td><td><input id="aq3" type="text" readonly></td></tr>
      <tr><td>10</td><td><input id="am10" type="text"></td><td>11</td><td><input id="am11" type="text"></td><td>12</td><td><input id="am12" type="text"></td><td>4분기</td><td><input id="aq4" type="text" readonly></td></tr>
      <tr><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td><td>합계</td><td><input id="sum" type="text" disabled="true" readonly></td></tr>
      </table>
      </small>
      </div>
	  <br>
      <button id="copy" class="btn btn-Light shadow-sm btnsize" >자료복사</button>
      
         
      
      <div style="width:100%;"><hr></div>
      <h4>편성 예산</h4>
      <div class="row" align="left" style="width:100%; padding:10px;">
      <small>
      <table>
      <tr><td>월</td><td>금액</td><td>월</td><td>금액</td><td>월</td><td>금액</td><td>분기</td><td>금액</td></tr>
      <tr><td>01</td><td><input id="m1" type="text"></td><td>02</td><td><input id="m2" type="text"></td><td>03</td><td><input id="m3" type="text"></td><td>1분기</td><td><input id="q1" type="text" readonly></td></tr>
      <tr><td>04</td><td><input id="m4" type="text"></td><td>05</td><td><input id="m5" type="text"></td><td>06</td><td><input id="m6" type="text"></td><td>2분기</td><td><input id="q2" type="text" readonly></td></tr>
      <tr><td>07</td><td><input id="m7" type="text"></td><td>08</td><td><input id="m8" type="text"></td><td>09</td><td><input id="m9" type="text"></td><td>3분기</td><td><input id="q3" type="text" readonly></td></tr>
      <tr><td>10</td><td><input id="m10" type="text"></td><td>11</td><td><input id="m11" type="text"></td><td>12</td><td><input id="m12" type="text"></td><td>4분기</td><td><input id="q4" type="text" readonly></td></tr>
      <tr><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td><td>합계</td><td><input type="text" id="msum" readonly></td></tr>
      </table>
      </small>
      </div>
      
      <div class="row" style="padding:10px;">
      <input type="button" id="orgBudgetBtn" value="예산편성" class="btn btn-Light shadow-sm btnsize" style="margin-left:5px;">
      <span id="result"></span>
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
