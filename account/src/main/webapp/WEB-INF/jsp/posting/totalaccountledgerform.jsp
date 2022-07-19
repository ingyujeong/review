<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>총계정원장</title>

  	<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
  	
  	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	<style>
  	  	.date{
  		width: 140px;
		height:30px;
		font-size:0.9em;
  	}
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
		  //버튼 이벤트
		 $('input:button').hover(function() {
			 $(this).css("background-color","pink");
			}, function(){
			$(this).css("background-color","");
		 });
		  
		  
   });
			
	var date = new Date();
	var year = date.getFullYear().toString();
	var month = (date.getMonth() + 1 > 9 ? date.getMonth() : '0' + (date.getMonth() + 1)).toString(); // getMonth()는 0~9까지
	// 10월 이상이면 true
	var day = date.getDate() > 9 ? date.getDate() : '0' + date.getDate(); // getDate()는 1~31 까지 
	var today = year + "-" + month + "-" + day; 
   
   $(document).ready(function () {
	$("#search").click( () => showCashJournalGrid(selectedRow2["accountInnerCode"]) );// 검색
   $('#from').val(today.substring(0, 8) + '01');	
	$('#to').val(today.substring(0, 10));
	 });
	function currencyFormatter(params) {
    	return '￦' + formatNumber(params.value);
  	}
	
  	function formatNumber(number) {
  	    // this puts commas into the number eg 1000 goes to 1,000,
  	    // i pulled this from stack overflow, i have no idea how it works
  	    	return Math.floor(number)
  	      		.toString()
  	      		.replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
  	  	}  
   
  $(document).ready(function () {

      createAccount();        
      showAccount();
      createAccountDetail(); 
      createCashJournalGrid();
  });
  var selectedRow;
  var selectedRow2;
	function createAccount(){
		rowData=[];
	  	var columnDefs = [
		      {headerName: "계정과목 코드", field: "accountInnerCode",sort:"asc", width:200
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
	    			  	  $("#search").attr('disabled','disabled');
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
		      {headerName: "계정과목 코드", field: "accountInnerCode",width:200},
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
		    			  console.log(event.data);
		    			  selectedRow2=event.data;
		    			  showAccountDetail(selectedRow2["accountInnerCode"]);
		    			  $("#search").removeAttr('disabled');
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
            	if(jsonObj.length!=0)
                gridOptions2.api.setRowData(jsonObj);
            	else
            	showCashJournalGrid(selectedRow2["accountInnerCode"]);
            }
        });
    }
    
 	 function createCashJournalGrid() {
		rowData=[];
	  	var columnDefs = [
		      {headerName: "monthReportingDate", field: "",resizable:true,width:70, hide:true, valueFormatter:currencyFormatter},
		      {headerName: "일자", field: "monthReportingDate",width:80},
		      {headerName: "적요", field: "expenseReport", width:80},
		      {headerName: "입금", field: "deposit",width:100, valueFormatter:currencyFormatter},
		      {headerName: "출금", field: "withdrawal",width:100, valueFormatter:currencyFormatter },
		      {headerName: "잔액", field: "balance",width:100, valueFormatter:currencyFormatter},
		  ];	  	
		  gridOptions3 = {
				      columnDefs: columnDefs,
				      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
		 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
		        			event.api.sizeColumnsToFit();
		    		  },
		    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
		    		        event.api.sizeColumnsToFit();
		    		  },
		   }
		  	cashJournalGrid = document.querySelector('#cashJournalGrid');
			new agGrid.Grid(cashJournalGrid,gridOptions3);
	 }
 	function showCashJournalGrid(account){
		 $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/posting/ledgerbyaccount",
            data: {
                "year": $("#year").val(),
                "account": account
            },
            dataType: "json",
            success: function (jsonObj) {
                gridOptions3.api.setRowData(jsonObj);
            },
            error : function(){
               alert("오류발생");
            }

        });
	}
  </script>
</head>
<body class="bg-gradient-primary">
      <h4>총계정원장</h4>
      <hr>
       <div class="row" style=" padding-left:25px">
       	<select id="year"  class="form-control" style="width: 15%;">
       	<script>
       		for(i=2010;i<2050;i++){
       	       document.write("<option>"+i+"</option>");
       		}
       		$("#year").val(year);
       	</script>
       	</select>
		<input type="button" id="search" value="조회" class="btn btn-Light shadow-sm btnsize2" style="margin-left:5px;" disabled="disabled">
      </div> 
      
      <table>
      <tr>
      <td>
      <div style="float: left; width: 50%; padding:10px; position: relative ">
      	<div align="left">
				<div id="accountGrid" class="ag-theme-balham"  style="height:300px;width:300px;" ></div>
      	</div>
      </div>
      </td>
      <td rowspan="2">
      
       <div style="float: center; width: 50%; height: 500 px; padding:10px; rowspan:2; ">
      <div align="center">
			<div id="cashJournalGrid" class="ag-theme-balham"  style="height:625px;width:900px;" ></div>
		</div>
      </div>
      </td>
      </tr>
      <tr>
      <td>
      <div style="float: left; width: 50%; height: 500 px; padding:10px; position: relative ">
       	<div align="left">
				<div id="accountDetailGrid" class="ag-theme-balham" style="height:300px;width:300px;"></div>
      	</div>
      </div>
      </td>
      </tr>
      </table>

 
</body>
</html>