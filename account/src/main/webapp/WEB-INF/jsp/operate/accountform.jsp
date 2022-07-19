<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>계정과목</title>

  	<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
  	
  	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	<style>
  	.ag-header-cell-label{
      justify-content: center;
	}/*글자 밑에 있는거 중앙으로  */
					.ag-row .ag-cell {
							  display: flex;
							  justify-content: center !important; /* align horizontal */
							  align-items: center !important; 
							  }
				
					.ag-theme-balham .ag-cell, .ag-icon .ag-icon-tree-closed::before {
						line-height:15px !important;

					}
			 		.ag-group-contracted{
						height:15px !important;

					} 
					.ag-theme-balham .ag-icon-previous:before {
						    content: "\f125" !important;
						                                      }
					.ag-theme-balham .ag-icon-next:before {
						    content: "\f11f" !important;
						                                      }
					.ag-theme-balham .ag-icon-first:before {
						    content: "\f115" !important;
						                                      }
					.ag-theme-balham .ag-icon-last:before {
						    content: "\f118" !important;
						                                      }
  	</style>
   <script>
  $(document).ready(function () {

      createAccount();        
      showAccount();
      createAccountDetail(); 
  });
  var selectedRow;
	function createAccount(){
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
		    			  showAccountDetail(selectedRow["accountInnerCode"]);
		    		  }
		   }
		  accountGrid = document.querySelector('#accountGrid');
			new agGrid.Grid(accountGrid,gridOptions);
	 }
	function showAccount(){
		 $.ajax({
             type: "GET",
             url: "${pageContext.request.contextPath}/operate/parentaccountlist",
             data: {
             },
             dataType: "json",
             success: function (jsonObj) {
                 gridOptions.api.setRowData(jsonObj);
             }
         });
	}
	
	var lastSelectedAccountDetail;
	
	function createAccountDetail() {
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
		    		  }		    
		   }
		 accountDetailGrid = document.querySelector('#accountDetailGrid');
		 	new agGrid.Grid(accountDetailGrid,gridOptions2);
    }
	
    function showAccountDetail(code) {
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/operate/detailaccountlist",
            data: {
                "code": code
            },
            dataType: "json",
            success: function (jsonObj) {
                gridOptions2.api.setRowData(jsonObj);
            }
        });
    }
  </script>
</head>
<body class="bg-gradient-primary">
      <h4>계정과목</h4>
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