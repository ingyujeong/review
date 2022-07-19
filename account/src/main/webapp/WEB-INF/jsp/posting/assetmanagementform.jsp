<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>자산관리</title>
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

      		createAsset();        
      		assetList();
      		createAssetItem();
      
  		});
  
  		var selectedRow;
  		var assetListInfo;
  		var parents;
  		var dept;
  		var assetItemCode;
  	
		function createAsset(){
		  	var columnDefs = [
			      {headerName: "번호", field: "assetNumber", sort:"asc", width:100},
			      {headerName: "자산분류", field: "assetName",width:100}
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
		    		showAssetItem(selectedRow["assetCode"]);
		    	}
		   	}
		  	
		  	assetGrid = document.querySelector('#assetGrid');
			new agGrid.Grid(assetGrid,gridOptions);
	 	}
		
		function assetList(){
			$.ajax({
             	type: "GET",
             	url: "${pageContext.request.contextPath}/posting/assetlist",
             	data: {
             	},
             	dataType: "json",
             	success: function (jsonObj) {
            		console.log("		@자산목록 로드 성공");
            		console.log(jsonObj);
            		assetListInfo = jsonObj;
                	gridOptions.api.setRowData(assetListInfo);
                	createModal();
                	showModal();
             	}
         	});
		}
	
		function createAssetItem() {
		  	var columnDefs = [
		    	{headerName: "관리번호", field: "assetItemCode",width:30, sort:"asc"},
		    	{headerName: "자산명", field: "assetItemName", width:70}
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
	    			selectedRow=event.data;
	    			assetItemCode = selectedRow.assetItemCode;
	    			showAssetInfo(selectedRow);
	    			  
	    			$('#StorageBtn').removeAttr('disabled');
	    			$('#RemoveBtn').removeAttr('disabled');
	    			$('#assetRemove').removeAttr('disabled');
	    			$('#assetItemCode').removeAttr('readonly');
	    			$('#assetItemName').removeAttr('readonly');
	    			$('#parenrsBtn').removeAttr('disabled');
	    			$('#acquisitionDate').removeAttr('readonly');
	    			$('#acquisitionAmount').removeAttr('readonly');
	    			$('#deptBtn').removeAttr('disabled');
	    			$('#usefulLift').removeAttr('readonly');
	    		}	 
		   }
		 	
			assetItemGrid = document.querySelector('#assetItemGrid');
		 	new agGrid.Grid(assetItemGrid,gridOptions2);
		}
	
		function showAssetItem(assetCode) {
        	$.ajax({
            	type: "GET",
            	url: "${pageContext.request.contextPath}/posting/assetitemlist",
           		data: {
                	"assetCode": assetCode
            	},
            	dataType: "json",
            	success: function (jsonObj) {
            		console.log("		@자산아이템 로드 성공");
              		console.log(jsonObj);
                	gridOptions2.api.setRowData(jsonObj);
            	}
        	});
    	}
	
		function createModal(){
	  		var columnDefs = [
		    	{headerName: "계정과목", field: "assetCode", sort:"asc", width:30},
		    	{headerName: "계정과목명", field: "assetName", width:70}
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
	    			parents = event.data;
	    		}
	    	}
		 
		 	assetParentsList = document.querySelector('#assetParentsList');
         	new agGrid.Grid(assetParentsList,gridOptions3);
		 
		 	var columnDefs2 = [
				{headerName: "부서코드", field: "deptCode", sort:"asc", width:100},
				{headerName: "부서명", field: "deptName", width:100}
		  	];
		 	
			gridOptions4 = {
				columnDefs: columnDefs2,
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
	    			dept = event.data;
	    		}    		  
		   	}
		 
			assetDeptsList = document.querySelector('#assetDeptsList');
 			new agGrid.Grid(assetDeptsList,gridOptions4);
		}
	
		function showModal(){
			gridOptions3.api.setRowData(assetListInfo);
		
			$.ajax({
            	type: "GET",
            	url: "${pageContext.request.contextPath}/posting/deptlist",
            	data: {
            	},
            	dataType: "json",
            	success: function (jsonObj) {
            		gridOptions4.api.setRowData(jsonObj.DeptList);
            	}
        	});
		}
	
		function parentsRegistration(){
			$('#parentsCode').val(parents.assetCode);
			$('#parentsName').val(parents.assetName);
		}
	
		function deptRegistration(){
			$('#manageMentDept').val(dept.deptName);
		}
	
		function showAssetInfo(selectedRow){
			var accumulatedDepreciation = showAccumulatedDepreciation(selectedRow);
			$('#assetItemCode').val(selectedRow.assetItemCode);
			$('#assetItemName').val(selectedRow.assetItemName);
			$('#parentsCode').val(selectedRow.parentsCode);
			$('#parentsName').val(selectedRow.parentsName);
			$('#acquisitionDate').val(selectedRow.acquisitionDate);
			$('#acquisitionAmount').val(selectedRow.acquisitionAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));
			$('#manageMentDept').val(selectedRow.manageMentDeptName);
			$('#usefulLift').val(selectedRow.usefulLift);
			$('#deperciationRate').val(selectedRow.deperciationRate);
			$('#accumulatedDepreciation').val(accumulatedDepreciation.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));
			$('#residualValue').val((selectedRow.acquisitionAmount - accumulatedDepreciation).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));
		
		}
	
		function showAccumulatedDepreciation(selectedRow){
			var today = new Date();
			var acquisitionDate = new Date(selectedRow.acquisitionDate);
			var currDay = 24*60*60*1000 //시*분*초*밀리세컨
			var currYear = currDay*365
			var accumulatedDepreciation = Math.floor((selectedRow.acquisitionAmount/selectedRow.usefulLift) * Math.floor((today-acquisitionDate)/currYear));
			
			return accumulatedDepreciation;
		}
	
		function assetRegistration(){
			$('#assetItemCode').val('');
			$('#assetItemName').val('');
			$('#parentsCode').val('');
			$('#parentsName').val('');
			$('#acquisitionDate').val('');
			$('#acquisitionAmount').val('');
			$('#manageMentDept').val('');
			$('#usefulLift').val('');
			$('#accumulatedDepreciation').val('');
			$('#residualValue').val('');
			
			$('#StorageBtn').removeAttr('disabled');
			$('#assetItemCode').removeAttr('readonly');
			$('#assetItemName').removeAttr('readonly');
			$('#parenrsBtn').removeAttr('disabled');
			$('#acquisitionDate').removeAttr('readonly');
			$('#acquisitionAmount').removeAttr('readonly');
			$('#deptBtn').removeAttr('disabled');
			$('#usefulLift').removeAttr('readonly');
			
			assetItemCode = 'CREATE';
		}
		
		function assetStorage(){	
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/posting/assetstorage",
				data: {
					"previousAssetItemCode" : assetItemCode,
					"assetItemCode" : $('#assetItemCode').val(),
					"assetItemName" : $('#assetItemName').val(),
					"parentsCode" : $('#parentsCode').val(),
					"parentsName" : $('#parentsName').val(),
					"acquisitionDate" : $('#acquisitionDate').val(),
					"acquisitionAmount" : $('#acquisitionAmount').val(),
					"manageMentDept" : $('#manageMentDept').val(),
					"usefulLift" : $('#usefulLift').val()
				},
				dataType: "json",
				success: function (){
					$('#assetItemCode').val('');
					$('#assetItemName').val('');
					$('#parentsCode').val('');
					$('#parentsName').val('');
					$('#acquisitionDate').val('');
					$('#acquisitionAmount').val('');
					$('#manageMentDept').val('');
					$('#usefulLift').val('');
					$('#accumulatedDepreciation').val('');
					$('#residualValue').val('');
					
					$('#StorageBtn').attr('disabled',true);
					$('#RemoveBtn').attr('disabled',true);
					$('#assetItemCode').attr('readonly',true);
					$('#assetItemName').attr('readonly',true);
					$('#parenrsBtn').attr('disabled',true);
					$('#acquisitionDate').attr('readonly',true);
					$('#acquisitionAmount').attr('readonly',true);
					$('#deptBtn').attr('disabled',true);
					$('#usefulLift').attr('readonly',true);
					
					gridOptions2.api.setRowData('');
				}
			});	
		}
		
		function assetRemove(){
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/posting/assetremoval",
				data: {
					"assetItemCode" : assetItemCode
				},
				dataType: "json",
				success: function (jsonObj){
					$('#assetItemCode').val('');
					$('#assetItemName').val('');
					$('#parentsCode').val('');
					$('#parentsName').val('');
					$('#acquisitionDate').val('');
					$('#acquisitionAmount').val('');
					$('#manageMentDept').val('');
					$('#usefulLift').val('');
					$('#accumulatedDepreciation').val('');
					$('#residualValue').val('');
					
					$('#StorageBtn').attr('disabled',true);
					$('#RemoveBtn').attr('disabled',true);
					$('#assetRemove').attr('disabled',true);
					$('#assetItemCode').attr('readonly',true);
					$('#assetItemName').attr('readonly',true);
					$('#parenrsBtn').attr('disabled',true);
					$('#acquisitionDate').attr('readonly',true);
					$('#acquisitionAmount').attr('readonly',true);
					$('#deptBtn').attr('disabled',true);
					$('#usefulLift').attr('readonly',true);
					
					gridOptions2.api.setRowData('');
				},
				error : function(error){
					console.log($('#assetItemCode').val(''));
				}
			});	
		}
  </script>
</head>
<body class="bg-gradient-primary">
      <h4 style="display:inline;">자산관리</h4>
      <hr>
      <div>
	      <input type=button onclick="assetRegistration()" class="btn btn-Light shadow-sm btnsize2" value="등록"> 
		  <input type=button onclick="assetStorage()" class="btn btn-Light shadow-sm btnsize2" id="StorageBtn" value="저장" disabled>
	      <input type=button onclick="assetRemove()" class="btn btn-Light shadow-sm btnsize2" id="RemoveBtn" value="삭제" disabled>
	      <label style="padding-left:230px">자산정보</label>
      </div>
      
      <table>
      	<tr>
      		<td>
      			<div style="float: left; width: 50%; position: relative ">
      				<div align="center">
						<div id="assetGrid" class="ag-theme-balham"  style="height:300px;width:400px;" ></div>
      				</div>
      			</div>
      		</td>
      		<td rowspan="2">
      			<div style="float: center; width: 50%; height: 500 px; padding:10px; rowspan:2; ">
      				<div style="height:625px;width:800px; border:1px solid #aaa">
						<div class="p-5">
                			<div class="form-group row">
                  				<div class="col-sm-6 mb-3 mb-sm-0">
                     				<label for="assetItemCode">관리번호</label>
                    				<input type="text" class="form-control form-control-user" id="assetItemCode" readonly>
                  				</div>
                  				<div class="col-sm-6">
                     				<label for="assetItemName">자산명</label>
                    				<input type="text" class="form-control form-control-user" id="assetItemName" readonly>
                  				</div>
                			</div>
                			<div class="form-group row">
                  				<div class="col-sm-6 mb-3 mb-sm-0">
                     				<label for="parentsCode">계정과목</label>
                    				<input type="text" class="form-control form-control-user" id="parentsCode" readonly>
                  				</div>
                  				<div class="col-xs-2" style="margin-top:31px; margin-right:10px;">
                     				<button class="btn btn-primary" type="button" data-toggle="modal" data-target="#parentsModalGrid" id="parenrsBtn" disabled>
                        				<i class="fas fa-search fa-sm"></i>
                     				</button>
                  				</div>
                  				<div class="col-sm-5">
                     				<label for="parentsName">계정과목명</label>
                    				<input type="text" class="form-control form-control-user" id="parentsName" readonly>
                  				</div>
                			</div>
                			<div class="form-group row">
                  				<div class="col-sm-6 mb-3 mb-sm-0">
                     				<label for="acquisitionDate">취득일자</label>
                    				<input type="text" class="form-control form-control-user" id="acquisitionDate" readonly>
                  				</div>
                  				<div class="col-sm-6">
                     				<label for="acquisitionAmount">취득금액</label>
                    				<input type="text" class="form-control form-control-user" id="acquisitionAmount" readonly>
                  				</div>
                			</div>
                			<div class="form-group row">
                  				<div class="col-sm-6 mb-3 mb-sm-0">
                     				<label for="manageMentDept">관리부서</label>
                    				<input type="text" class="form-control form-control-user" id="manageMentDept" readonly>
                  				</div>
                  				<div class="col-xs-2" style="margin-top:31px; margin-right:10px;">
                  					<button class="btn btn-primary" type="button" data-toggle="modal" data-target="#deptModalGrid" id="deptBtn" disabled>
                        				<i class="fas fa-search fa-sm"></i>
                     				</button>
                  				</div>
                			</div>
                			<div class="form-group row">
                  				<div class="col-sm-6 mb-3 mb-sm-0">
                     				<label for="usefulLift">내용연수</label>
                    				<input type="text" class="form-control form-control-user" id="usefulLift" readonly>
                  				</div>
                			</div>
                			<div class="form-group row">
                  				<div class="col-sm-6 mb-3 mb-sm-0">
                     				<label for="accumulatedDepreciation">감가상각누계액</label>
                    				<input type="text" class="form-control form-control-user" id="accumulatedDepreciation" readonly>
                  				</div>
                  				<div class="col-sm-6">
                     				<label for="residualValue">잔존가치</label>
                    				<input type="text" class="form-control form-control-user" id="residualValue" readonly>
                  				</div>
                			</div>
            			</div>
					</div>
      			</div>
      		</td>
      </tr>
      <tr>
      	<td>
      		<div style="float: left; width: 50%; height: 500 px; position: relative ">
       			<div align="center">
					<div id="assetItemGrid" class="ag-theme-balham" style="height:300px;width:400px;"></div>
      			</div>
      		</div>
      	</td>
      </tr>
    </table>

        
    <div class="modal fade" id="parentsModalGrid" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  		<div class="modal-dialog">
    		<div class="modal-content">
	      		<div class="modal-header">
	        		<h4 class="modal-title" id="myModalLabel">계정과목</h4>
	      		</div>
	      		<div class="modal-body">
	      			<div align="center" id="assetParentsList" class="ag-theme-balham" style="height:300px;width:400px;"></div>
	      		</div>
	      		<div class="modal-footer">
	        		<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
	        		<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="parentsRegistration()">선택</button>
	      		</div>
	    	</div>
		</div>
	</div>
	
	<div class="modal fade" id="deptModalGrid" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  		<div class="modal-dialog">
    		<div class="modal-content">
	      		<div class="modal-header">
	        		<h4 class="modal-title" id="myModalLabel">관리부서</h4>
	      		</div>
	      		<div class="modal-body">
	      			<div align="center" id="assetDeptsList" class="ag-theme-balham" style="height:300px;width:400px;"></div>
	      		</div>
	      		<div class="modal-footer">
	        		<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
	        		<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="deptRegistration()">선택</button>
	      		</div>
	    	</div>
		</div>
	</div>
</body>
</html>