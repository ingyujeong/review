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
	
	  table {
        width: 100%;
        background-color: #D8D8D8;
      }

</style>
  <script>
  $(document).ready(function () {
		
	  createTotalTrialBalanceGrid();
		$("#search").click(showTotalTrialBalance);
		$("#set").click(doClosing);// 결산
		$("#PDF").click(createPdf);
		
		 /* DatePicker  */
        $('#from').val(today.substring(0, 8) + '01');
     	// 오늘이 포함된 해당 달의 첫번째 날, 1월달이면 1월 1일로 세팅.    2020-xx 총 7자리
        $('#to').val(today.substring(0, 10));         // 오늘 날짜의 년-월-일.
	});
  /* 날짜 */
  var date = new Date();
  var year = date.getFullYear().toString();
  var month = (date.getMonth() + 1 > 9 ? date.getMonth() + 1 : '0' + (date.getMonth() + 1)).toString(); // getMonth()는 0~9까지
  // 10월 이상이면 true
  var day = date.getDate() > 9 ? date.getDate() : '0' + date.getDate(); // getDate()는 1~31 까지 
  var today = year + "-" + month + "-" + day;
  
  
  function createTotalTrialBalanceGrid(){
		rowData=[];
		var columnDefs = [
		      {headerName: "차변",
		    	  children:[
		    		  {headerName: "잔액",field: "leftBalance", width:200},
		    		  {headerName: "합계",field: "sumLeftDebtorPrice",width:200},
		    	  ],},
			      {headerName: "과목",field: "accountName",width:200 },
		    	  {headerName: "대변",
			    	  children:[
			    		  {headerName: "합계",field: "sumRightCreditsPrice", width:200},
			    		  {headerName: "잔액",field: "rightBalance",width:200},
			    	  ],},
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
		    		  }
		   }
		  totalTrialBalanceGrid = document.querySelector('#totalTrialBalanceGrid');
			new agGrid.Grid(totalTrialBalanceGrid,gridOptions);
			gridOptions.api.setRowData([]);
	 }
  
  function showTotalTrialBalance(){
		$.ajax({// ajax 안쓰고 데이터 받아오기 수정해보자!!
			url: "${pageContext.request.contextPath}/settlement/imtotaltrialbalance",
			data: {	//항상 ajax에서 data는 url로 request.setParameter(데이터:내용)임을 잊지말자 
					"from": $("#from").val(), /* ~부터 */
					"to": $("#to").val(), /* ~까지 */
			},
			dataType: "json", 
			async: false, //비동기방식설정
			success: function (jsonObj) { //arraylist 받아옴 $$$---------------------
				var array=jsonObj["totalTrialBalance"];
				var total=array.pop();
				console.log(array);
				
				gridOptions.api.setRowData(array);
				var td1=document.querySelector("#td1");
				var td2=document.querySelector("#td2");
				var td3=document.querySelector("#td3");
				var td4=document.querySelector("#td4");
				
				console.log(total);
				
				console.log(total["leftBalance"]);
				console.log(total["rightBalance"]);
				console.log(total["sumRightCreditsPrice"]);
				console.log(total["sumLeftDebtorPrice"]);
				
				td1.innerText=total["leftBalance"];
				td4.innerText=total["rightBalance"];
				td3.innerText=total["sumRightCreditsPrice"];
				td2.innerText=total["sumLeftDebtorPrice"];
				
				
			}
		});
  }

  function doClosing() {
      var find = confirm("결산을 진행 하시겠습니까?");
      if(find) {
      //	gridOptions.api.setRowData([]);
           $.ajax({
               type: "GET",
               url: "${pageContext.request.contextPath}/settlement/totaltrialbalance",
               data: {
                  // "totalTrialBalanceData": JSON.stringify(totalTrialBalanceData),
                  "toDate": $("#todate").val(),
                   "callPosition": "doClosing"
               },
               dataType: "json",
               success: function (jsonObj) {
                  alert("결산성공");
                  /*
                   $("#closing").jqGrid('setGridParam', {data: jsonObj.closing});       
                   $("#closing").trigger('reloadGrid');
                   */
                   //gridOptions.api.setRowData(jsonObj.closing);
                  //compareDebtorCredits();
               }
           });

           showTotalTrialBalance();
      }
   }
  
  function createPdf(){
	  window.open("${pageContext.request.contextPath}/base/imtotaltrialbalancepdf&from="+$("#from").val()+"&to="+$("#to").val());   
  }
  </script>
</head>

<body class="bg-gradient-primary">
      <h4>합계잔액시산표</h4>
      <hr>
      <div class="row">
       	<input id="from" type="date" class="date" required style="margin-left:12px;">
       	<input id="to" type="date" class="date" required>
		<input type="button" id="search" value="조회" class="btn btn-Light shadow-sm btnsize2" style="margin-left:5px;">
		<input type="button" id="set" value="결산" class="btn btn-Light shadow-sm btnsize2" style="margin-left:2px;">
		<input type="button" id="PDF" value="PDF" class="btn btn-Light shadow-sm btnsize2" style="margin-left:5px;">
      </div> 
      <div align="center">
			<div id="totalTrialBalanceGrid" class="ag-theme-balham"  style="height:400px;width:auto;" ></div>
      </div>
      <div align="center" style="width:100%;">
      <table border="1">
      <tr><td align="center" id="td1" width=20%></td><td align="center" id="td2" width=20%></td><td width=20% align="center">합계</td><td align="center" id="td3" width=20%></td><td align="center" id="td4" width=20%></td></tr>
      </table>
      </div>
</body>

</html>

