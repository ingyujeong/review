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
  <title>합계시산표</title>
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
     }
     .ag-header-cell-label{
      justify-content: center;
   }
   .ag-header-group-cell-with-group {
        background-color: #D8D8D8;
   }
   .headerLine{
   	justify-content:space-between;
   	margin:0;
   	padding:0;
   }
   .settleStatusContainer{
   	margin-right:150px;
   }
   .leftBox{
   		width:1000px;
   		margin:0;
   		padding:0;
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
</style>
  <script>
  
  $(document).ready(function () {
     //버튼 이벤트
    $('input:button').hover(function() {
       $(this).css("background-color","#D8D8D8");
      }, function(){
      $(this).css("background-color","");
    });
     
   $("#set").click(doClosing);// 결산      
   $("#cancelSet").click(cancelClosing); // 결산취소
   $('#showpdf').click(createPdf);    
   $('#excel').click(createExcel);
   
   	createTotalTrialBalanceGrid();
    createAccountPeriod();
    
    showAccountPeriod();
    showTotalTrialBalanceGrid()
    
  });
   var selectedRow;
   var accountPeriodNo;
   
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
     
    var gridOptions;
      function createTotalTrialBalanceGrid() {
    	  console.log("createTotalTrialBalanceGrid() 실행");
        rowData=[];
        var columnDefs = [
           {
           headerName: '차변',
           headerClass: 'participant-group',
           marryChildren: true,
           children: [
             { headerName:'잔액', field: 'debitsSumBalance', colId: '차변' , width:150,valueFormatter:currencyFormatter },
             { headerName:'합계', field: 'debitsSum', colId: '차변' , width:150, valueFormatter:currencyFormatter },
           ]
           },
            {headerName: "과목", field: "accountName",width:150 , cellStyle : {"textAlign":"left" ,"whiteSpace":"pre"}},
           {
            headerName: '대변',
            headerClass: 'participant-group',
            marryChildren: true,
            children: [
            { headerName:'합계', field: 'creditsSum', colId: '대변' , width:150, valueFormatter:currencyFormatter},
            { headerName:'잔액', field: 'creditsSumBalance', colId: '대변' , width:150, valueFormatter:currencyFormatter},
            ]
          },
        ];        
        gridOptions = {
                 columnDefs: columnDefs,
                  defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
                  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                       event.api.sizeColumnsToFit();
                  },
                  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                        event.api.sizeColumnsToFit();
                  },
         }
        totalTrialBalanceGrid = document.querySelector('#totalTrialBalanceGrid');
         new agGrid.Grid(totalTrialBalanceGrid,gridOptions);
    }
      
      function showTotalTrialBalanceGrid(){
   	   console.log("showTotalTrialBalanceGrid() 실행")
          $.ajax({
                 method: "GET", 
                 dataType: "json", 
                 contentType: "application/json; charset=utf-8;",
                url: "${pageContext.request.contextPath}/settlement/totaltrialbalance/"+accountPeriodNo, //메서드가 없음
                data: {
                    "callResult" : "SEARCH"				// 회계결산현황 SEARCH(조회) 호출
                },
                dataType: "json",
                success: function (jsonObj) {
               	
                   gridOptions.api.setRowData(jsonObj.totalTrialBalance);
                   
                   if(jsonObj.accountingSettlementStatus[0].totalTrialBalance=="Y") // 회계결산현황 조회
                   	$("#settleStatusResult").text("결산");
                   else $("#settleStatusResult").text("미결산");
                },
                error:function(request,status,error){
               	 alert("code:"+request.status+"error"+error+"\n");
                }
            });
      }
      
   function createExcel() {
	   console.log("createExce");
       var dateData=[];
       gridOptions.api.forEachNode(function(rowNode, index) {
           dateData[index] = JSON.stringify(rowNode.data);
       })
       console.log(dateData[0]);
       $.ajax({
           type: "POST",
           url : "${pageContext.request.contextPath}/base/excel",
           data : {
               "sendData" : JSON.stringify(dateData)
           },
           dataType : "json",
           success : function(data) {
        	   console.log("createExce3");
           }
       });
   }
   function doClosing() { //결산승인
   	console.log("doClosing() 실행")
       var find = confirm("결산을 진행 하시겠습니까?");
       if(find) { //결산버튼 누르면
          gridOptions.api.setRowData([]); //로우데이터에 빈배열 추가
            $.ajax({
                url: "${pageContext.request.contextPath}/settlement/totaltrialbalance",
                method : 'POST',
                data: {
                   // "totalTrialBalanceData": JSON.stringify(totalTrialBalanceData),
                    "accountPeriodNo": accountPeriodNo,
                    "callPosition": "finddoClosing", //메서드
                    "callResult" : "Y"				// 회계결산현황 업데이트(Y) 및 호출
                },
                dataType: "json",
                success: function (jsonObj) {
               	 console.log("doClosing :" +jsonObj );
               	 
               	console.log("결산:"+jsonObj.accountingSettlementStatus[0].totalTrialBalance);
              	
					if(jsonObj.accountingSettlementStatus[0].totalTrialBalance=="Y"){
						alert("결산성공");
						$("#settleStatusResult").text("결산");	
					}else
						$("#settleStatusResult").text("미결산");

                   
                }
            });
            location.reload();
          showTotalTrialBalanceGrid();
       }
    }
    
   // 결산취소
   function cancelClosing() {
   	console.log("cancelClosing() 실행")
       var find = confirm("결산을 취소 하시겠습니까?");
       if(find) {
          gridOptions.api.setRowData([]);
            $.ajax({
                type: "GET",
                url: "${pageContext.request.contextPath}/settlement/totaltrialbalancecancle",
                data: {
                   // "totalTrialBalanceData": JSON.stringify(totalTrialBalanceData),
                   "accountPeriodNo": accountPeriodNo,
                   "callPosition": "cancelClosing",
                   "callResult" : "N"				// 회계결산현황 업데이트(N) 및 호출
                },
                dataType: "json",
                success: function (jsonObj) {
                   alert("결산취소성공");
                   console.log(jsonObj.errorMsg)
                   /*
                    $("#closing").jqGrid('setGridParam', {data: jsonObj.closing});       
                    $("#closing").trigger('reloadGrid');
                    */
                    //$("#settleStatusResult").text("취소");
                    //compareDebtorCredits();
                }
            });

          showTotalTrialBalanceGrid();
       }
    }
   
    
    // PDF로 보기
    function createPdf() {
          window.open("${pageContext.request.contextPath}/base/totaltrialbalancepdf");   
    }
   
    function createAccountPeriod(){
    	console.log("createAccountPeriod() 실행")
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
                      
                     accountPeriodNo = selectedRow["accountPeriodNo"];
                     console.log(accountPeriodNo);   
                     
                     showTotalTrialBalanceGrid();
                   }
          }
         accountGrid = document.querySelector('#accountYearGrid');
          new agGrid.Grid(accountGrid,gridOptions3);
     }
     
    function showAccountPeriod(){    
    	console.log("showAccountPeriod() 실행")
          $.ajax({
                 type: "GET",
                 url: "${pageContext.request.contextPath}/operate/accountperiodlist",
                 dataType: "json",
                 async:false,
                 success: function (jsonObj) {
                    console.log(jsonObj);
                     gridOptions3.api.setRowData(jsonObj);
                    gridOptions3.api.forEachNode(function (node, index) {
                         if (index = gridOptions3.api.getLastDisplayedRow()) {                        
                           $("#fiscalYear").val(node.data.fiscalYear);
                         accountPeriodNo = node.data.accountPeriodNo;
                         }                   
                     });           
                 }
             });           
       }
      
   
  </script>
  
    
  
</head>

<body class="bg-gradient-primary">
      <h4>합계잔액시산표</h4>
      <hr>
      <div class="row headerLine">
      <div class="row leftBox">
       <div  class="col-sm-4 mb-3 mb-sm-0 input-group">
                     <label for="example-text-input" class="col-form-label">회계연도</label>
                    <input   style="margin-left: 5px" type="text" class="border-0 small form-control form-control-user periodBox" id="fiscalYear" placeholder="fiscalYear" disabled="disabled">

                  <div class="input-group-append">
                     <button class="btn btn-primary" type="button" data-toggle="modal"
                        data-target="#accountYearModal" id="searchPeriod">
                        <i class="fas fa-search fa-sm"></i>
                     </button>
                 </div>
      </div>
      <input type="button" id="set" value="결산" class="btn btn-Light shadow-sm btnsize3" style="margin-left:2px;">
      <input type="button" id="cancelSet" value="결산취소" class="btn btn-Light shadow-sm btnsize3" style="margin-left:2px;">
      <input type="button" id="showpdf" value="PDF" class="btn btn-Light shadow-sm btnsize3" style="margin-left:2px;">
      <input type="button" id="excel" value="EXCEL" class="btn btn-Light shadow-sm btnsize3" style="margin-left:2px;">
    
      </div>
      <div class="settleStatusContainer">결산상태 : <span id="settleStatusResult" >--</span></div>      
      </div> 
      <div align="center">
         <div id="totalTrialBalanceGrid" class="ag-theme-balham"  style="height:500px;width:auto;" ></div>
      </div>
      
      
<!--회계 기수 모달 -->
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
</body>

</html>
