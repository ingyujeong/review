<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>

  <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
  <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
  <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
  
  <%--DatePicker--%>
 	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <title>메인</title>
<style>
  	.date{
  		width: 140px;
		height:30px;
		font-size:0.9em;
  	}
  	.btnsize{
  		width: 90px;
		height:30px;
		font-size:0.9em;
		font-align:center;
		color:black;
  	}
  	.btnsize2{
  		width: 60px;
		height:30px;
		font-size:0.9em;
		color:black;
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
		 $(this).css("background-color","#D8D8D8");
		}, function(){
		$(this).css("background-color","");
	 });
	  
		$("#search").click(showJournal);// 검색
		//$("#detailSearch").click();// 검색
		
		
	/* DatePicker  */
	$('#from').val(today.substring(0, 8) + '01');	// 오늘이 포함된 해당 달의 첫번째 날, 1월달이면 1월 1일로 세팅. 	2020-xx 총 7자리
	$('#to').val(today.substring(0, 10));			// 오늘 날짜의 년-월-일.
		
	createJournal();
	createJournalDetail();
  });
  	var selectedRow;
	/* 날짜 */
	var date = new Date();
	var year = date.getFullYear().toString();
	var month = (date.getMonth() + 1 > 9 ? date.getMonth()+1 : '0' + (date.getMonth() + 1)).toString(); // getMonth()는 0~9까지
	// 10월 이상이면 true
	var day = date.getDate() > 9 ? date.getDate() : '0' + date.getDate(); // getDate()는 1~31 까지 
	var today = year + "-" + month + "-" + day; 
	
 	//화폐 단위 설정
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
  	

	function createJournal(){
		rowData=[];
	  	var columnDefs = [
		      {headerName: "전표번호", field: "slipNo",sort:"desc",resizable:true,width:200},
		      {headerName: "분개번호", field: "journalNo",width:300},
		      {headerName: "구분", field: "balanceDivision", width:80},
		      {headerName: "계정과목", field: "accountName", width:100},
		      {headerName: "차변", field: "leftDebtorPrice",width:100, valueFormatter:currencyFormatter},
		      {headerName: "대변", field: "rightCreditsPrice",width:100, valueFormatter:currencyFormatter},
		      {headerName: "분개상세", field: "journalDetail",width:100, cellRenderer: cellRendererFunc},
		      {headerName: "거래처명", field: "customerName",width:100},
		  ];	  	
		  gridOptions = {
				      columnDefs: columnDefs,
				      rowSelection:'single', //row는 하나만 선택 가능
				      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
				      pagination:true, // 페이저
				      paginationPageSize:10, // 페이저에 보여줄 row의 수
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
		    		  }
		   }
		  	journalGrid = document.querySelector('#journalGrid');
			new agGrid.Grid(journalGrid,gridOptions);
	 }
	function showJournal(){
		 $.ajax({
             type: "GET",
             url: "${pageContext.request.contextPath}/posting/rangedjournallist",
             data: {
                 "fromDate": $("#from").val(),
                 "toDate": $("#to").val()
             },
             dataType: "json",
             success: function (jsonObj) {
            	
                 gridOptions.api.setRowData(jsonObj);
             }
         });
	}
	var gridOptions2;
	function createJournalDetail() {
		rowData=[];
	  	var columnDefs = [
		      {headerName: "항목", field: "accountControlName",resizable:true,width:100},
		      {headerName: "항목내용", field: "journalDescription",width:300},
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
		  	journalDetailGrid = document.querySelector('#journalDetailGrid');
		 	new agGrid.Grid(journalDetailGrid,gridOptions2);
    }
	
    function cellRendererFunc(params) {
        //console.log(params);
        //$("#accountGridModal").modal('show');
       return '<button onclick="showJournalDetail()">상세보기</button>';
        //return "<a href=\"javascript:void(0);\" onclick=\"showJournalDetail('" +params.data.journalNo + "')\">상세 보기</a>";
    }
    function showJournalDetail() {
    	$("#journalDetailGridModal").modal('show');
    	var journalNo= selectedRow["journalNo"];
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/posting/journaldetaillist",
            data: {
                "journalNo": journalNo
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
      <h4>분개장</h4>
      <hr>
      <div class="row">
       	<input id="from" type="date" class="date" required style="margin-left:12px;">
       	<input id="to" type="date" class="date" required>
		<input type="button" id="search" value="검색" class="btn btn-Light shadow-sm btnsize2" style="margin-left:5px;">
      </div> 
      <div align="center">
				<div id="journalGrid" class="ag-theme-balham"  style="height:500px;width:auto;fontSize:2em" ></div>
      </div>
            <div align="center" class="modal fade" id="journalDetailGridModal" tabindex="-1" role="dialog" aria-labelledby="accountGridLabel">
       		<div class="modal-dialog" role="document">
      			<div class="modal-content">
       			 <div class="modal-header">
          			<h5 class="modal-title" id="journalDetailGridLabel">분개상세</h5>
         			 <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            			<span aria-hidden="true">×</span>
         			 </button>
        		</div>
              <div class="modal-body">
				<div align="center" id="journalDetailGrid" class="ag-theme-balham"  style="width:400px;height:400px"></div>
				</div>
      		</div>
    	</div>
      </div>
</body>

</html>

