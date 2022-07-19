<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>권한그룹설정</title>

  	<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
  	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
  	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	<style>
  	.ag-header-cell-label{
      justify-content: center;
	}
	.swal-wide{
    width:500px;
	}
  	</style>
   <script>
  $(document).ready(function () {

      createEmp();        
      showEmpList();
      createAuthorityGroup();
      //showAuthorityList();
      
  });
  var selectedRow;
	function createEmp(){
		rowData=[];
	  	var columnDefs = [
		      {headerName: "사원번호", field: "empCode",sort:"asc", width:100
		      },
		      {headerName: "사원", field: "empName",width:100},
		      {headerName: "부서코드", field: "deptCode",width:100}
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
		    			  showAuthorityDetail(selectedRow["deptCode"]);
		    		  }
		   }
		  accountGrid = document.querySelector('#accountGrid');
			new agGrid.Grid(accountGrid,gridOptions);
	 }
	function showEmpList(){
		 $.ajax({
             type: "GET",
             url: "${pageContext.request.contextPath}/operate/employeeListall",
             data: {
             },
             dataType: "json",
             success: function (jsonObj) {
            	 console.log("		@직원리스트 로드 성공");
            	 console.log(jsonObj);
                 gridOptions.api.setRowData(jsonObj);
             }
         });
	}
	
	function createAuthorityGroup() {
		rowData=[];
	  	var columnDefs = [
	  		{width:10, checkboxSelection: true},
		      {headerName: "권한그룹명", field: "menuCode",width:100},
		      {headerName: "권한그룹코드", field: "menuName", width:100, hide: "true"},
		      {headerName: "현재 권한여부", field: "authorityGroup", width:100, cellRenderer: function (params) {
		            if (params.value==1) {
		                return params.value =  "🔵" ;
		            }
		            return "❌" ;
		        }}

		  ];  	
		 gridOptions2 = {
				      columnDefs: columnDefs,
				      rowSelection: 'multiple', //체크박스 다중선택
				      //rowSelection:'single', //row는 하나만 선택 가능
				      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
		 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
		        			event.api.sizeColumnsToFit();
		    		  },
		    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
		    		        event.api.sizeColumnsToFit();
		    		  },
		    		  onRowClicked:function (event){
		    			  console.log(event.data);
		    			  
		    		  }
		    		  
		   }
		 accountDetailGrid = document.querySelector('#accountDetailGrid');
		 	new agGrid.Grid(accountDetailGrid,gridOptions2);
    }
	
	function showAuthorityDetail(deptCode) {
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/operate/authorityemp",
            data: {
                "deptCode": deptCode
            },
            dataType: "json",
            success: function (jsonObj) {
            	console.log("		@권한리스트 로드 성공");
              	console.log(jsonObj);
                gridOptions2.api.setRowData(jsonObj);
            }
        });
    }
	
	function changeAuthority(){
		var selectedDept = gridOptions.api.getSelectedRows();
		var authorityList = gridOptions2.api.getSelectedRows();
		console.log(selectedDept[0].deptCode);
		//console.log("수정전" + JSON.stringify(authorityList));
		authorityList.forEach(function(obj){ obj.authorityGroup == 1 ? obj.authorityGroup=0 : obj.authorityGroup=1 });
		console.log("@@@@@@ 수정후" + JSON.stringify({ "list" : authorityList}));
		Swal.fire({
			  title: '권한을 수정하시겠습니까?',
			  text: "다시 한번 확인해주세요.",
			  icon: 'warning',
			  customClass: 'swal-wide',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '수정',
			  cancelButtonText: '취소'
			}).then((result) => {
			  if (result.value) {
	              //"수정" 버튼을 눌렀을 때 작업할 내용을 이곳에 넣어주면 된다.
	              $.ajax({
			           type: "GET",
			           url: "${pageContext.request.contextPath}/operate/authoritygroupmodification",
			           data: {
			               "dept" : selectedDept[0].deptCode,
			               "authority" : JSON.stringify(authorityList)
			           },
			           dataType: "json",
			           success: function (jsonObj) {
			           }
			       });
				  location.reload();
			  }
			})
	}
	function addAuthorityGroup(){
		var groupCode=null;
		var addAuthority=$("#addAuthority").val();
		console.log(addAuthority);
		$.ajax({
			type: "GET",
			url: "${pageContext.request.contextPath}/operate/authoritygroupcode",
			async: false,
			data: {
			},
			dataType: "json",
			success: function (jsonObj){groupCode=jsonObj.findAuthorityGroupCode[0].menuName;
	}
});	
		var code=groupCode.substring(2);
		var nextCode=parseInt(code)+1
		var nextGroupCode="GR0"+nextCode;
		console.log(nextGroupCode);		

		Swal.fire({
			  title: '권한그룹을 추가하시겠습니까?',
			  text: "다시 한번 확인해주세요.",
			  icon: 'warning',
			  customClass: 'swal-wide',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '추가',
			  cancelButtonText: '취소'
			}).then((result) => {
			  if (result.value){
		 $.ajax({
	           type: "GET",
	           url: "${pageContext.request.contextPath}/operate/additionauthoritygroup",
			   async: false,
	           data: {
				   "nextGroupCode": nextGroupCode,
	               "addAuthority" : addAuthority
	           },
	           dataType: "json",
	           success: function (jsonObj) {
	           }
	       });
		 location.reload();	
			  }
		})
}
	function removeAuthority(){
		var authorityList = gridOptions2.api.getSelectedRows();
		console.log(authorityList[0].menuName);
		Swal.fire({
			  title: '권한그룹을 삭제하시겠습니까?',
			  text: "다시 한번 확인해주세요.",
			  icon: 'warning',
			  customClass: 'swal-wide',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '삭제',
			  cancelButtonText: '취소'
			}).then((result) => {
			  if (result.value){
		 $.ajax({
	           type: "GET",
	           url: "${pageContext.request.contextPath}/operate/authoritygroupremoval",
			   async: false,
	           data: {
				   "groupCode" : authorityList[0].menuName
	           },
	           dataType: "json",
	           success: function (jsonObj) {
	           }
	       });
		 location.reload();	
			  }
		})		
	}
	
	
	/* function showAuthorityList(){
		 $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/personnel/authority.do",
            data: {
                "method": "findAuthorityList",
            },
            dataType: "json",
            success: function (jsonObj) {
           	 console.log("		@권한리스트 로드 성공");
           	 console.log(jsonObj);
                gridOptions2.api.setRowData(jsonObj.authorityList);
            }
        });
	} */
	
  </script>
</head>
<body class="bg-gradient-primary">
      <h4 style="display:inline;">권한관리</h4>
      
      <input style="float:right;" type=button onclick="changeAuthority()" value="그룹수정"> 
	  <input style="float:right;" type=button onclick="removeAuthority()" value="그룹삭제">
      <input style="float:right;" type=button onclick="addAuthorityGroup()" value="그룹추가">
      <input style="float:right;" id="addAuthority" type=text value="">     
      <hr>
      <div style="float: left; width: 50%; padding:10px;">
      	<div align="center">
				<div id="accountGrid" class="ag-theme-balham"  style="height:450px;width:auto;" ></div>
      	</div>
      </div>
      <div style="float: left; width: 50%; height: 500 px; padding:10px;">
       	<div align="center">
				<div id="accountDetailGrid" class="ag-theme-balham" style="height:450px;width:auto;"></div>
      	</div>
      </div>
</body>
</html>