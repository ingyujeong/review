<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>거래처 등록/등록해제</title>


  	<script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
  	<link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
  	
  	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	
  	<!-- validate -->

<script type="text/javascript"
	src="${pageContext.request.contextPath}/assets/plugins/jquery.validate.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/assets/plugins/functionValidate.js"></script>

<script>
	var ApprovalStatusGrid = "#ApprovalStatusGrid"; //미등록 거래처 그리드
	var accountRegisteredGrid = "#accountRegisteredGrid"; //등록 거래처 그리드
	var status = null;
	var approval = "등록";
	var unApproval = "미등록";

	$(document).ready(
			function() {
				createApprovalStatusGrid(); //거래처 그리드 생성
				
				showApprovalStatusList(); // 거래처 리스트 보여주기
				
				$("#AddWorkplace").click(function(){ // 거래처 등록
					//location.href="${pageContext.request.contextPath}/company/WorkplaceInserForm.html";
					$("#codeModal").modal('show');
				});
				
                $("#deleteWorkplace").click(deleteWorkplace);            //  거래처 삭제
				$("#refresh").click(function() { // 새로고침
					showApprovalStatusList();
				});
				
				
				$("#Release").click( //해제
						function() {
							var getSelectedSell = [];
							getSelectedSell = $(accountRegisteredGrid).jqGrid(
									'getGridParam', 'selarrrow');
							status = unApproval
							updateApprovalStatus(getSelectedSell);
						})

				$("#Approval").click( //승인
						function() {
							var getSelectedSell = [];
							getSelectedSell = $(ApprovalStatusGrid)
									.jqGrid('getGridParam', 'selarrrow');
							status = approval
							updateApprovalStatus(getSelectedSell);
						});

				
				
				$(AddWorkplace).click(workplaceAdd); //사업장추가 
				$("#valss input").focus(validate);

				createParentBusinessGrid(); //업태그리드
				createDetailBusinessGrid(); //업태소분류그리드getWorkplaceCode

				//버튼이벤트
				$(searchBusiness).click(function() { //업태 대분류 검색 버튼
					showParentBusiness();
				});

				$("#addCheck").click(function() { //사용하기 버튼 이벤트
					$(workplaceCode).val(codeCheck);
					$("#companyCodeModal").modal("hide");
					$("#seccondSearch").val("");
				});
			});
    var rowData;
    var gridOptions; //ApprovalStatusGrid 옵션
    var approvalStatusGrid;
    var selectedRow;
    
	function createApprovalStatusGrid() { //미등록 거래처 그리드 생성
		rowData = [];
        var columnDefs = [
            { headerName: "사업장 코드", field: "workplaceCode", width: 100 },
            { headerName: "거래처 코드", field: "companyCode", width: 100 },
            { headerName: "사업장명", field: "workplaceName", width: 100 },
            { headerName: "대표자명", field: "workplaceCeoName", width: 100 },
            { headerName: "업태", field: "businessConditions", width: 100 },
            { headerName: "사업자등록번호", field: "businessLicense", width: 100 },
            { headerName: "법인등록번호", field: "corporationLicence", width: 100 },
            { headerName: "사업장전화번호", field: "workplaceTelNumber", hide: true },
            { headerName: "승인상태", field: "approvalStatus", width: 100 },
        ];

        gridOptions = {
            columnDefs: columnDefs,
            rowSelection: 'single', //row는 하나만 선택 가능
            defaultColDef: { editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
            pagination: true, // 페이저
            paginationPageSize: 10, // 페이저에 보여줄 row의 수
            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                event.api.sizeColumnsToFit();
            },
            onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                event.api.sizeColumnsToFit();
            },
            onRowClicked: function (event) {
            	selectedRow = event.data;
            	showWorkplace(selectedRow)
            },
            onCellEditingStarted: function (event) {
                console.log("slip편집시작");
            },
            onCellEditingStopped: function (event) {
                console.log('slip편집종료');
                
            }
        };
        approvalStatusGrid = document.querySelector('#approvalStatusGrid');
        new agGrid.Grid(approvalStatusGrid, gridOptions);
	}
	
	function showApprovalStatusList() { // 거래처리스트 불러오기
		gridOptions.api.setRowData([]);
		$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/allworkorkplacelist",
					data : {
					},
					dataType : "json",
					success : function(jsonObj) {
						var  approvalStatusList= []; // 승인 리스트
						 console.log(jsonObj);
                             gridOptions.api.setRowData(jsonObj);
					}
				});
	}

	function updateApprovalStatus(getSelectedSell) {
		$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/approvalstatusmodification",
					data : {
						"codes" : JSON.stringify(getSelectedSell),
						"status" : status
					},
					dataType : "json",
					success : function(jsonObj) {
						showApprovalStatusList();
					}
				});
	}
	
	// 거래처삭제
	function eliminationWorkplace(getSelectedSell) {
		$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/workplaceremoval",
					data : {
						"codes" : JSON.stringify(getSelectedSell)
					},
					dataType : "json",
					success : function(jsonObj) {
						showApprovalStatusList();
					}
				});
		}
	// 거래처 보기
    function showWorkplace(workplaceCode) { //slip rowid 선택한 전표행이다

        //gridOptions2.api.setPinnedBottomRowData();  

       
            $.ajax({
                type: "POST",
                async: false,
                url: "${pageContext.request.contextPath}/operate/workplace",
                data: {
                    "workplaceCode": workplaceCode
                },
                dataType: "json",
                success: function (jsonObj) {
				$('#workplaceCode').val(jsonObj)
				
                }
            });
			//	거래처 등록 Modal
				var searchWorkplaceCode = "#searchWorkplaceCode"; //사업장코드 조회
	var searchBusiness = "#searchBusiness"; //업태대분류 조회 버튼 	
	var AddWorkplace = "#AddWorkplace"; //사업장 추가

	var parentBusinessGrid = "#parentBusinessGrid" // 업태그리드
	var detailBusinessGrid = "#detailBusinessGrid" //업태소분류그리드

	var workplaceCode = "#workplaceCode"; //사업장조회 인풋 아이디	
	var codeCheck; //코드조회 변수
	var emptyWorkplaceBean;

	var status = "";
	$(document).ready(function() {



	});

	function getWorkplaceCode(code) {
		if (code.type == "click") { // onclick 이벤트이므로 type == click
			codeCheck = $(workplaceCode).val();
			status = "first";
		}

		if (code.type == "button") {
			codeCheck = $("#seccondSearch").val();
			status = "seccond";
		} 

		$("#seccondModal").attr("hidden", false);
		$("#addCheck").attr("type", "button");

		$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/workplace",
					data : {
						workplaceCode : codeCheck
					},
					dataType : "json",
					success : function(jsonObj) {
						var workplaceCode = jsonObj.workplaceBean;

						var getChecking = workplaceCode != null ? "사업장 중복 있습니다 , 다시 조회하세요."
								: codeCheck.length != 4 || isNaN(codeCheck) ? "사업장 코드는 숫자로만 구성된 4자리로 입력 부탁드립니다"
										: "사업장 등록이 가능합니다";
						// JSON 결과가 NULL이 아닐경우 중복 / 숫자 4자리가 아닐 경우 경고 / 모두다 아니면 등록 가능
						$("#codeCheck").html(getChecking); // modal 창 하단에 결과메세지 띄움
						
						if (workplaceCode != null || codeCheck.length != 4
								|| isNaN(codeCheck)) {
							$("#addCheck").attr("type", "hidden"); // 조건이 맞지 않을 경우 버튼을 숨긴다
							emptyWorkplaceBean = null;

						} else if (workplaceCode == null
								|| codeCheck.length == 4 || isNaN(codeCheck)) {
							$("#seccondModal").attr("hidden", true);       // 코드 입력 텍스트창 숨김
							emptyWorkplaceBean = jsonObj.emptyWorkplaceBean; 
							if (status == "first")
								$("#codeCheck").html(
										"사업장코드" + codeCheck + "    "
												+ getChecking);

							else if (status == "seccond")
								$("#codeCheck").html(
										"사업장코드" + codeCheck + "    "
												+ getChecking);
						}   // 사업장코드 0000 사업장 등록이 가능합니다.

					}
				});
	}

	//사업장추가
	function workplaceAdd() {
		var workplaceAddItems = emptyWorkplaceBean;

		for ( var index in workplaceAddItems) {
			if (index == "workplaceCode")
				workplaceAddItems[index] = "BRC-" + $("#" + index + "").val(); // code에 BEC- 추가
			else
				workplaceAddItems[index] = $("#" + index + "").val();
		}

		$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/registerworkplace",
					data : {
						workplaceAddItems : JSON.stringify(workplaceAddItems),
					},
					dataType : "json",
					success : function(jsonObj) {
						if (jsonObj.errorCode == 0) {
							alert("회사등록이 성공적으로 완료되었습니다");
							location.href = "${pageContext.request.contextPath}/hello"
						}
						if (jsonObj.errorCode < 0)
							alert("회사등록에 실패 되었습니다 사업장조회는 필수입니다.");
					}
				});
	}

	function createParentBusinessGrid() { //업태 그리드

		rowData=[];
	  	var columnDefs = [
		      {headerName: "업태대분류", field: "businessName",resizable:true,width:100},
		      {headerName: "업태코드", field: "classificationCode", hide : true},
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
		    			  showDetailBusinessGrid(selectedRow["classificationCode"]);
		    		  }
		   }
		 parentBusinessGrid = document.querySelector('#parentBusinessGrid');
		 	new agGrid.Grid(parentBusinessGrid,gridOptions);
	}

	function showParentBusiness() { //업태리스트
		
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/operate/businesslist",
			data : {
			},
			dataType : "json",
			success : function(jsonObj) {
					 
				gridOptions.api.setRowData(jsonObj.businessList);

			}
		});
	}

	function createDetailBusinessGrid() { 	//업태소분류
		

		rowData=[];
	  	var columnDefs = [
		      {headerName: "업태소분류", field: "detailBusinessName",resizable:true,width:100},
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
		    			  $("#businessConditions").val(selectedRow2["detailBusinessName"]);
		    			  $("#businessModal").modal("hide");
		    		  }
		   }
		 	detailBusinessGrid = document.querySelector('#detailBusinessGrid');
		 	new agGrid.Grid(detailBusinessGrid,gridOptions2);
	}

	function showDetailBusinessGrid(businessCode) { //업태소분류리스트
		$.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/operate/detailbusiness",
			data : {
				"businessCode" : businessCode
			},
			dataType : "json",
			success : function(jsonObj) {
					gridOptions2.api.setRowData(jsonObj.detailBusinessList);
			}
		});
	}
            
    }
</script>
</head>
<body>
	<div class="col-12 card">
		<div class="d-flex justify-content-between align-items-center">
			<h4 class="col-sm-6 mt-5">
				<font style="vertical-align: inherit;">거래처 관리</font>
			</h4>

		</div>
		<div class="card-body">
			<div class="row">
				<div class="col-sm-6 ml-0">

					<button type="button" id="Approval"
						class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
						style="width: 90px;">승인</button>
					<button type="button" id="Release"
						class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
						style="width: 90px;">해제</button>
						
				</div>
				<div class="col-sm-6 ml-6" align="right">
					<button type="button" id="refresh"
						class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
						style="width: 110px;">새로고침</button>
					<button type="button" id="AddWorkplace"
						class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
						style="width: 110px;">거래처등록</button>
					<button type="button" id="deleteWorkplace"
						class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
						style="width: 110px;">거래처삭제</button>
				</div>
			</div>
     		<div align="center">
                <div id="approvalStatusGrid" class="ag-theme-balham" style="height:350px;width:auto;"></div>
            </div>
		</div>
	</div>


 <div  class="modal fade" id="codeModal" tabindex="-1" role="dialog"
                aria-labelledby="codeLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="codeLabel">거래처 등록</h5>
                            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                     
                        <div class="modal-body">
                        
                              <form class="user" id="infoForm" method="post">
               
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">사업장코드</label>
                    <input type="text" class="form-control form-control-user" id="workplaceCode" name="workplaceCode" placeholder="workplaceCode">
                  </div>
                  <div class="col-sm-6" style="margin-top:43px; margin-left:-12px;">
                  	<button class="btn btn-primary" type="button" data-toggle="modal"  data-target="#companyCodeModal" id="searchWorkplaceCode">
                  		<i class="fas fa-search fa-sm"></i>
                  	</button>
                  </div>
                </div>
               
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">거래처코드</label>
                    <input type="text" class="form-control form-control-user" id="companyCode" name="companyCode" placeholder="companyCode">
                  </div>
                  <div class="col-sm-6">
                  	<label for="example-text-input" class="col-form-label">사업장명</label>
                    <input type="text" class="form-control form-control-user" id="workplaceName" name="workplaceName" placeholder="workplaceName">
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">사업자등록번호</label>
                    <input type="text" class="form-control form-control-user" id="businessLicense" name="businessLicense" placeholder="businessLicense">
                  </div>
                  <div class="col-sm-6">
                  	<label for="example-text-input" class="col-form-label">법인등록번호</label>
                    <input type="text" class="form-control form-control-user" id="corporationLicence"name="corporationLicence"
								placeholder="corporationLicence" >
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">대표자명</label>
                    <input type="text" class="form-control form-control-user" id="workplaceCeoName" name="workplaceCeoName" placeholder="ceoName">
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">업태</label>
                    <input type="text" class="form-control form-control-user" id="businessConditions" placeholder="businessConditions" disabled="disabled">
                  </div>
                  <div class="col-sm-6" style="margin-top:43px; margin-left:-12px;">
                  	<button class="btn btn-primary" type="button" data-toggle="modal"
                  		data-target="#businessModal" id="searchBusiness">
                  		<i class="fas fa-search fa-sm"></i>
                  	</button>
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">사업장전화번호</label>
                    <input type="text" class="form-control form-control-user" id="workplaceTelNumber" name="workplaceTelNumber"	placeholder="workplaceTelNumber">
                  </div>
                  <div class="col-sm-6">
                  	<label for="example-text-input" class="col-form-label">사업장팩스번호</label>
                    <input type="password" class="form-control form-control-user" id="workplaceFaxNumber" name="workplaceFaxNumber" placeholder="workplaceFaxNumber">
                  </div>
                </div>
                
                <div class="form-group row">
                  <div class="col-sm-6 mb-3 mb-sm-0">
                  	<label for="example-text-input" class="col-form-label">사업장주소</label>
                    <input type="text" class="form-control form-control-user" id="workplaceBasicAddress" name="workplaceBasicAddress"	placeholder="workplaceAdress">
                  </div>
                  <div class="col-sm-6">
                  	<label for="example-text-input" class="col-form-label">거래처등록유무</label>
                    <input type="text" class="form-control form-control-user" id="approvalStatus" value="미등록" placeholder="approvalStatus" disabled="disabled">
                  </div>
                </div>
                <hr>
                <input type="submit" class="btn btn-user btn-block btn-primary" id="AddWorkplace" value = "등록">
                <input type="reset" class="btn btn-user btn-block btn-danger " id="reset" value = "취소">
              </form>
                            </div>
                        </div>
                    </div>
                </div>

<div align="center" class="modal fade" id="businessModal" tabindex="-1"
		role="dialog" aria-labelledby="businessLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="businessLabel">업태</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
			<hr>
			<div class="modal-body" >
				<div style="float: left; width: 50%;">
					<div align="center">
						<div id="parentBusinessGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
				<div style="float: left; width: 50%;">
					<div align="center">
						<div id="detailBusinessGrid" class="ag-theme-balham"
							style="height: 400px; width: auto;"></div>
					</div>
				</div>
				</div>
			</div>
		</div>
	</div>
	
	<div align="center" class="modal fade" id="companyCodeModal" tabindex="-2"
		role="dialog" aria-labelledby="companyCodeLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="companyCodeLabel">사업장코드확인</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<hr>
				<div class="modal-body" >
						<div style="float: left;">
							<input type="text" id="seccondSearch"
								class="form-control form-control-user" maxlength="4">
						</div>
						<div style="float: left;">
							<button class="btn btn-primary" type="button"
								onclick="getWorkplaceCode(this)">
								<i class="fas fa-search fa-sm"></i>
							</button>
						</div>
				 <div class="modal-footer" >
				 	<div id="codeCheck">
				 	</div>
					<input class="btn btn-secondary btn-icon-split" type="button" id="addCheck" value="사용하기">
					<table id="companyCodeGrid"></table>
        		</div>
				</div>
			</div>
		</div>
	</div>

               




</body>
</html>