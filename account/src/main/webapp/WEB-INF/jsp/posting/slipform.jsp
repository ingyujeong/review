<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    .date {
                        width: 140px;
                        height: 30px;
                        font-size: 0.9em;
                    }

                    .btnsize {
                        width: 100px;
                        height: 30px;
                        font-size: 0.8em;
                        font-align: center;
                        color: black;
                    }

                    .btnsize2 {
                        width: 60px;
                        height: 30px;
                        font-size: 0.9em;
                        color: black;
                    }
                    .ag-header-cell-label { /* 이것도 셀 정렬 기능인데 클래스를 부르지 않아서 안쓰는듯 */
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
                        $('input:button').hover(function () { // hover가 2개의 인자값이 있으면 첫번째 인자값은 마우스올렸을때 ,두번째는 땟을때 실행
                            $(this).css("background-color", "pink");
                        },
                        function () {
                            $(this).css("background-color", "");
                        });

                        $("#search").click(searchSlip);         // (전표)검색
                        $("#addSlip").click(addslipRow);            // 전표추가
                        $("#deleteSlip").click(deleteSlip);      // 전표삭제 - 전표, 분개, 분개상세
                        $("#addJournal").click(addJournalRow);      // 분개추가
                        $("#deleteJournal").click(deleteJournal);   // 분개삭제, 화영이가 구현
                        $("#showPDF").click(createPdf); // pdf보기
                        $("#confirm").click(confirmSlip);         // 결재 버튼
                        $("#Accountbtn").click(searchAccount); // 모달에서의 계정 검색 버튼
                        $("#saveSlip").click(saveSlip); // 전표저장
                        $("#accountCode").keydown(function(key) {
                            if (key.keyCode == 13) {
                                         searchAccount();
                            }
                        })
                        $("#searchCodebtn").click(searchCode); // 모달에서의 부서 검색 버튼 


                        /* DatePicker  */
                        $('#from').val(today.substring(0, 8) + '01');
                     	// 오늘이 포함된 해당 달의 첫번째 날, 1월달이면 1월 1일로 세팅.    2020-xx 총 7자리
                        $('#to').val(today.substring(0, 10));         // 오늘 날짜의 년-월-일.
                        
                        createSlip();
                        createJournal();
                        createjournalDetailGrid();
                        createCodeGrid();
                        showSlipGrid();
                        createAccountGrid();
                        showAccount();
                        createCustomerCodeGrid();
                        createAccountDetailGrid()
                        showAccountDetail('0101-0145') //처음 보이는 값이 당좌자산 첫번째껄로 보이게 해놓음, 두 사람에게 설명해줘야 야 함
                        
                    });
                    window.addEventListener("keydown", (key) => {
                    	if(key.keyCode==113){
                    		addslipRow();
                    	}
                    	else if(key.keyCode==114){
                    		saveSlip();
                    	}
                    	else if(key.keyCode==115){
                    		confirmSlip();
                    	}
                    })


                    var NEW_SLIP_NO = "NEW"; // 전표 이름.
                    var NEW_JOURNAL_PREFIX = NEW_SLIP_NO + "JOURNAL"; // 분개 앞에 오는 이름
                    var REQUIRE_ACCEPT_SLIP = "작성중";

                    //그리드 선택자 
                    var slipGrid = "#slipGrid";
                    var journalGrid = "#journalGrid";
                    var journalDetailGrid;
                    var accountGrid = "#accountGrid";
                    var customerCodeModalGrid = "#customerCodeModalGrid";

                    // 로그정보
                    var deptCode = "${sessionScope.deptCode}";
                    var accountPeriodNo = "${sessionScope.periodNo}";
                    var empName = "${sessionScope.empName}";
                    var empCode = "${sessionScope.empCode}";
					
                    console.log(deptCode+"/"+accountPeriodNo+"/"+empName);
                    //화폐 단위 원으로 설정 \100,000,000
                    function currencyFormatter(params) {
                    	console.log("currencyFormatter(params) 실행");
                        return '￦' + formatNumber(params.value);
                    }

                    function formatNumber(number) {
                    	console.log("formatNumber(number) 실행");
                        // this puts commas into the number eg 1000 goes to 1,000,
                        // i pulled this from stack overflow, i have no idea how it works
                        return  Math.floor(number)
                            .toString()
                            .replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');

                         //Math.floor(Number(number).toLocaleString()) 
                    }
 
         
                    
                    /* Event function 안에서 사용할 변수들 */
                    var selectedSlipRow;
                    var lastSelectedSlip;
                    var lastSelectedJournal;
                    var lastSelectedJournalDetail;
                    var selectedJournalRow;
                    var editRow;

                    /* 날짜 */
                    var date = new Date();
                    var year = date.getFullYear().toString();
                    //var month = (date.getMonth() + 1 > 9 ? date.getMonth() + 1 : '0' + (date.getMonth() + 1)).toString(); // getMonth()는 0~9까지
                    var month = ("0" + (date.getMonth()+1)  ).slice(-2);
 	
                    //var day = date.getDate() > 9 ? date.getDate() : '0' + date.getDate(); // getDate()는 1~31 까지
                    var day = ("00"+date.getDate()).slice(-2)
                    var today =year + "-" + month + "-" + day;
 



                    // Map 내의 객체들 Disabled/Enabled
                    function enableElement(obj) {
                        console.log("enableElement(obj) 실행+전표클릭이벤트마지막이였따");
    
                        for (var key in obj)
                    
                            $(key).prop("disabled", !obj[key]);  //obj[key]부분은 true false밖에 올수없다. 
                    }

  
                    // PDF로 보기
                    function createPdf() {
                    	console.log("createPdf() 실행");
                        window.open("${pageContext.request.contextPath}/base/report.html?method=FinancialPosition&slipNo=" + selectedSlipRow.slipNo);

                    }



                    // slipGrid 
                    var rowData;
                    var gridOptions; //slipGrid 옵션
                    var slipGrid;

                    // slipGrid 생성
                    function createSlip() {
                    	console.log("createSlip() 실행12312312312");
                        rowData = [];
                        var columnDefs = [
                            { headerName: "전표번호", field: "slipNo", sort: "desc", resizable: true, width: 100},
                            { headerName: "기수", field: "accountPeriodNo", resizable: true,width: 70 },
                            { headerName: "부서코드", field: "deptCode", resizable: true,width: 80 },
                            { headerName: "부서", field: "deptName", resizable: true,hide: true },
                            { headerName: "구분", field: "slipType", editable: true, cellEditor: "agSelectCellEditor", cellEditorParams: { values: ["결산", "대체"] }, width: 70 },
                            { headerName: "적요", field: "expenseReport", editable: true, resizable: true },
                            { headerName: "승인상태", field: "slipStatus", resizable: true,width: 100 },
                            { headerName: "상태", field: "status", resizable: true,hide: true },
                            { headerName: "작성자코드", field: "reportingEmpCode", resizable: true,width: 100 },
                            { headerName: "작성자", field: "reportingEmpName", resizable: true,hide: true },
                            { headerName: "작성일", field: "reportingDate", resizable: true,width: 100 },
                            { headerName: "직급", field: "positionCode", resizable: true,hide: true }
                        ];

                        gridOptions = {
                            columnDefs: columnDefs,
                            rowSelection: 'single', //row는 하나만 선택 가능
                            defaultColDef: { editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
                        	pagination: true, // 페이저
                            paginationPageSize: 10, // 페이저에 보여줄 row의 수
                            stopEditingWhenGridLosesFocus: true, // 그리드가 포커스를 잃으면 편집 중지
                            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                            	event.api.sizeColumnsToFit(); // 그리드의 사이즈를 자동으로정리 (처음 틀었을때 양쪽 폭맞춰주는거같음)
                            },
                            onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리  (화면 비율바꿧을때 양쪽폭 맞춰주는거같음)
                                event.api.sizeColumnsToFit();
                            },
                            onRowClicked: function (event) {
                                console.log("sliprow선택+@@@@@@@@@@@@@@@@");
                                selectedSlipRow = event.data;
                                console.log(selectedSlipRow);//?????????????????????
                
                                showJournalGrid(event.data["slipNo"]);
                             
                                
                                if (selectedSlipRow.slipStatus != '승인완료') {
                                    enableElement({
                                        "#deleteSlip": true,
                                        "#addJournal": true,
                                        "#deleteJournal": true,
                                        "#confirm": true
                                    });
                                } else {
                                    enableElement({
                                        "#deleteSlip": false,
                                        "#addJournal": false,
                                        "#deleteJournal": false,
                                        "#confirm": false
                                    })
                                };

								
                            },
                    
                        };
                        slipGrid = document.querySelector('#slipGrid');
                        new agGrid.Grid(slipGrid, gridOptions);
                        enableElement({
                            "#addSlip": true,
                            "#deleteSlip": false,
                            "#addJournal": false,
                            "#deleteJournal": false,
                            "#showPDF": false,//수정
                        });
              

                       gridOptions.api.setRowData([]);  // 왜 빈값으로 할당하지 ?(dong)
                    }


                    // 전표 추가 버튼 이벤트 
                    function addslipRow() {
                    	console.log("addslipRow() 실행 전표추가눌렀따");
                    	$.ajax({ 
                    		type: "GET",
                            url: "${pageContext.request.contextPath}/posting/accountingsettlementstatus",
                            data: {
                                "accountPeriodNo": accountPeriodNo,
                                "callResult": "SEARCH"			/////// 회계결산현황 조회(SEARCH) 및 호출                   
                            },
                            dataType: "json",
                            success: function (jsonObj) {
                            	console.log(accountPeriodNo); //6, "search"
                            	addslipShow();
                               console.log(jsonObj.accountingSettlementStatus);
                                
                            }
                    	});
                    }
                    
                    // 전표 빈 양식
                    function addslipShow() {
                    	console.log("addslipShow() 실행+2번째로 실행했따");
                    	comfirm = false; //comfirm --> 확인창 안뜨게
                        rowData = [];
                        slipObj = {
                            "slipNo": NEW_SLIP_NO,
                            "accountPeriodNo": accountPeriodNo,
                            "slipType": "결산",	// sliptye의 결산 삭제시 위의 event.data['slipType'] 동작
                            "slipStatus": REQUIRE_ACCEPT_SLIP,
                            "deptCode": deptCode,
                            "reportingEmpCode": empCode,
                            "reportingEmpName": empName,
                            "reportingDate": today,
                        };

                        enableElement({ "#addSlip": false });  // 버튼 비활성화 - 전표추가버튼 비활성화

  
                            var newObject = $.extend(true, {}, slipObj); //slipObj에 값이 전부 입력되면 newObject에 담긴다
                            rowData.push(newObject); //rowData 집어넣는다
                            gridOptions.api.applyTransaction({ add: rowData });  // 행데이터를 업데이트, add/remove에 대한 목록이 있는 트랜잭션 객체를 전달

                    }


                    // 전표 삭제 이벤트
                    function deleteSlip() {
                    	console.log("deleteSlip() 실행");
                        console.log("selectedSlipRow.slipNo :" +selectedSlipRow.slipNo);
                       
                        //var selectedRows = gridOptions.api.getSelectedRows(); //내가 선택한 값을 selectRows에 담는다 (수정)
                   		if( selectedSlipRow['slipStatus']=="승인요청" || selectedSlipRow['slipStatus']=="승인완료" ){
                            alert("전표 작성중이 아닙니다.\n현재상태 : "+selectedSlipRow['slipStatus']);
                  		}
                   		else{
                   	
                   		 	if(confirmDelete()){
	                        $.ajax({
	                            type: "GET",
	                            url: "${pageContext.request.contextPath}/posting/slipremoval",
	                            data: {
	                                "slipNo": selectedSlipRow.slipNo
	                            },

	                            success: function () {
	                                console.log("data 전달 성공")
	                                var isNewSlip = (selectedSlipRow.slipNo == NEW_SLIP_NO); // 삭제한다음에 전표추가가 안되서 수정함 (dong)
	                                enableElement({
	                                    "#addSlip": true,
	                                    "#deleteSlip": false,
	                                    "#addJournal": false,
	                                    "#deleteJournal": false,
	                                    "#createPdf": false,
	                                });
	                            
	                                    gridOptions.api.applyTransaction({ remove: [selectedSlipRow] });  //선택된 전표 삭제 (choi)
	                             
	                            }
	                        });
                   		}}
                    }
                    function confirmDelete()//삭제 메세지
                    {
                        msg = "삭제하시겠습니까?";
                        if (confirm(msg)!=0) {
                             return true;
                        } else {
                           return false;
            			}
                    }
                    
                    // 분개삭제 (수정함)
                    function deleteJournal() { 

                        if(selectedJournalRow==null || selectedSlipRow.slipNo == NEW_SLIP_NO){
		                     if(selectedJournalRow==null){
		                        alert("삭제할 분개를 선택해주세요.");
		                              console.log("selectedJournalRow",selectedJournalRow);
		                     }else{
		                    	 alert("NEW 차변,대변은 삭제할 수 없습니다");
		                     }
		                 
                        }else{
                           $.ajax({
                                type: "GET",
                                url: "${pageContext.request.contextPath}/posting/journalremoval",
                                data: {
                                    "journalNo": selectedJournalRow["journalNo"]
                                },
                                success: function () {
                                    console.log("deleteJournal성공");

                                    enableElement({
                                        "#addSlip": true,
                                        "#deleteSlip": true,
                                        "#addJournal": true,
                                        "#deleteJournal": true,
                                        "#createPdf": false,
                                    });
                                    //selectedRows.forEach(function (selectedRow, index) { //forEach 배열의 반복문 
                                        gridOptions2.api.applyTransaction({ remove: [selectedJournalRow] }); // db에 저장된 분개 삭제  (choi)
                                    //});
                                }
                            });
                           //showJournalGrid(selectedSlipRow.slipNo);  // 호출안해도 될것같은데ㅔ; ? (dong)
                        }
                    }
                    
                    // journalslip 
                    var rowData2;
                    var gridOptions2 //jouranlGrid 옵션
                    var journalGrid;
                    var selectedJournalRow;
                    //Journal 생성 
                    function createJournal() {
                    	console.log("createJournal() 실행");
                        rowData2 = [];
                        gridOptions2 = {
                            columnDefs: [
                                {
                                    headerName: "분개번호", field: "journalNo",
                                    cellRenderer: 'agGroupCellRenderer',  // Style & Drop Down 
                                    sort: "asc", resizable: true, onCellDoubleClicked: cellDouble
                                },
                                {
                                    headerName: "구분", field: "balanceDivision", editable: true,
                                    cellEditor: "agSelectCellEditor",
                                    cellEditorParams: { values: ["차변", "대변"] }
                                },
                                {
                                    headerName: "계정코드", field: "accountCode"
                                    , editable: true
                                },
                                {
                                    headerName: "계정과목", field: "accountName",
                                    onCellClicked: function open() {
                                        $("#accountGridModal").modal('show');
                                        searchAccount();
                                    }
                                },
                                {
                                    headerName: "차변", field: "leftDebtorPrice",
                                    editable: params =>{
                                    	if(params.data.balanceDivision === '대변' ) return false
                                    	else return true
                                    },
                                    valueFormatter: currencyFormatter		// 통화 값에 대한 로캘별 서식 지정 및 파싱을 제공
                                },
                                {
                                    headerName: "대변", field: "rightCreditsPrice",
                                    editable: params =>{
                                    	if(params.data.balanceDivision === '차변' ) return false
                                    	else return true
                                    },
                                    valueFormatter: currencyFormatter
                                },
                                //수정중
                                { headerName: "거래처", field: "customerName", 
                                	onCellClicked: function open() {
                                        $("#customerCodeModalGrid").modal('show');
                                        searchCustomerCodeList();
                                    }	
                                
                                },
                                { headerName: "거래처", field: "customerName", hide: true },
                                { headerName: "상태", field: "status" }
                            ],
                            masterDetail: true,
                            enableCellChangeFlash: true,
                            detailCellRendererParams: {
                                detailGridOptions: {
                                    rowSelection: 'single',
                                    enableRangeSelection: true,		// 끌어서 선택옵션
                                    pagination: true, 
                                    paginationAutoPageSize: true, //지정된 사이즈내에서 최대한 많은 행을 표시
                                    columnDefs: [
                                        { headerName: "분개번호", field: "journalNo", hide: true },
                                        { headerName: "계정 설정 속성", field: "accountControlType", width: 150, sortable: true },
                                        { headerName: "분개 상세 번호", field: "journalDetailNo", width: 150, sortable: true },
                                        { headerName: "-", field: "status", width: 100, hide: true },
                                        { headerName: "-", field: "journalDescriptionCode", width: 100, hide: true },
                                        { headerName: "분개 상세 항목", field: "accountControlName", width: 150, },
                                        { headerName: "분개 상세 내용", field: "journalDescription", width: 250, cellRenderer: cellRenderer },
                                    ],
                                    defaultColDef: {
                                        sortable: true,		
                                        flex: 1,			//  flex로 열 크기를 조정하면 해당 열에 대해 flex가 자동으로 비활성화
                                    },
                                    getRowNodeId: function (data) {
                                    	console.log("getRowNOdeId 실행");
                                        // use 'account' as the row ID
                                        console.log("getRowNodeId: " + data.journalDetailNo);
                                        return data.journalDetailNo;
                                    },
                                    onRowClicked: function (event) {  // 상위 테이블에 있는 상세보기버튼으로도 실행됨.(dong)
                                    	console.log("onRowClicked 실행!!!!!!!!!!!!!!!!!");
                                        selectedJournalDetail = event.data;
                                        selectedJournalRow = event.data;
                                       	
                                    },
                                    onCellDoubleClicked: function (event) {
                                    	console.log("onCellDoubleClicked 실행");
                                        var journalNo = event.data["journalNo"];
                                        var detailGridApi = gridOptions2.api.getDetailGridInfo('detail_' + event.data["journalNo"]);
                                        console.log(detailGridApi);

                                        if (event.data["accountControlType"] == "SEARCH") {
                                            $("#codeModal").modal('show');
                                            detailGridApi.api.applyTransaction([selectedJournalDetail["journalDescription"] = searchCode()]);

                                            return;
                                        }
                                        else if (event.data["accountControlType"] == "SELECT") {
                                            // var detailGrid=gridOptions.api.getDetailGridInfo('detail_'+event.data.journalDetailNo);
                                            detailGridApi.api.applyTransaction([selectedJournalDetail["journalDescription"] = selectBank()]);

                                            return;
                                        }
                                        else if (event.data["accountControlType"] == "TEXT") {
                                            var str = prompt('상세내용을 입력해주세요', '');
                                            console.log('detail_' + event.data.journalDetailNo);
                                            //var detailGrid=gridOptions2.api.getDetailGridInfo('detail_'+event.data.journalDetailNo);
                                            detailGridApi.api.applyTransaction([selectedJournalDetail["journalDescription"] = str]);
                                            saveJournalDetailRow();

                                            return;
                                        }
                                        else {
                                            //var detailGrid=gridOptions2.api.getDetailGridInfo('detail_'+event.data.journalDetailNo);
                                            detailGridApi.api.applyTransaction([selectedJournalDetail["journalDescription"] = selectCal()]);

                                            return;
                                        }

                                    }
                                },

                                getDetailRowData: function (params) {  
                                	console.log("getDetailRowData 실행");
                                    console.log(params.data.journalDetailList);
                                    params.successCallback(params.data.journalDetailList); // detail table 에 값 할당
                                },
                                template: function (params) {
                                    return (
                                        '<div style="height: 100%; background-color: #EDF6FF; padding: 20px; box-sizing: border-box;">' +
                                        '  <div style="height: 10%; padding: 2px; font-weight: bold;">분개상세</div>' +
                                        '  <div ref="eDetailGrid" style="height: 90%;"></div>' +
                                        '</div>'
                                    );
                                },
                            },
                            getRowNodeId: function (data) {
                            	console.log("getRowNodeId 실행");
                                // use 'account' as the row ID
                                console.log("getRowNodeId: " + data.journalNo);
                                return data.journalNo;
                            },
                            enterMovesDownAfterEdit: true,  
                            rowSelection: 'single',
                            stopEditingWhenGridLosesFocus: true,
                            onGridReady: function (event) {
                                event.api.sizeColumnsToFit();
                            },
                            onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                                event.api.sizeColumnsToFit();
                            },
                            
                            onCellEditingStopped: function (event) {
                            	//gridOptions2.api.tabToNextCell();
                            	
                          		console.log("onCellEditingStopped 실행");
                                console.log(event);
                                
                                if(event.colDef.field=='leftDebtorPrice'||event.colDef.field=='rightCreditsPrice'){
                                	computeJournalTotal();  // 바뀐행이 이 차변,대변이면 실행하도록 수정(dong)
   								
                                };
								if(event.colDef.field=='accountCode'){// 항상 실행되던거 accouncode 수정될때만 실행되도록 수정(dong)  
                                	$.ajax({
                                    	type: "GET",
                                    	url: "${pageContext.request.contextPath}/operate/accountcontrollist",
                                    	data: {
                                        	accountCode: event.data["accountCode"] // 계정코드
                                    	},
                                    	dataType: "json",
                                    	async: false,
                                    	success: function (jsonObj) {
                                    		//jsonObj에는 account_control_code , account_control_name , account_control_type , account_control_description 만 가지고옴
                                        	jsonObj.forEach(function (element, index) { //accountControl은 map의 key 이름, accountControlList가 들어있음
                                        	    element['journalNo'] = selectedJournalRow['journalNo'];  // accountControlList에는 journalNo가 없어서 셋팅 후 아래 그리드옵션에 할당
                                        	})
                                        	gridOptions2.api.applyTransaction(  selectedJournalRow['journalDetailList'] = jsonObj );
                                        	 
                                    	}
                                	});
                                	Price(event); 
                                	
								};


                            },
                            onCellValueChanged: function (event){  // onCellEditingStopped에 있으면 금액수정할때도 계속 실행되서 수정함(dong)
                            	selectedJournalRow = event.data;
                                if (event.colDef.field=='accountCode') {
                                    getAccountName(event.data['accountCode']);
                                }
							},
                            onRowClicked: function (event) {
                            	console.log("onRowClicked 실%%%%%%%%%%%%%%%%%");
                                selectedJournalRow = event.data;
                                console.log(selectedJournalRow);
                            }
                        };
                        journalGrid = document.querySelector('#journalGrid');
                        new agGrid.Grid(journalGrid, gridOptions2);
                    }

                    function cellDouble(event) {
                    	console.log("cellDouble(event) 실행");
                        if (selectedSlipRow["slipNo"] !== NEW_SLIP_NO) {
                            $("#journalDetailGridModal").modal('show');
                            //분개상세 보기  
                            $.ajax({
                                type: "GET",
                                // JournalDetailDAO- ArrayList<JournalDetailBean> selectJournalDetailList(String journalNo)- return journalDetailBeans
                                url: "${pageContext.request.contextPath}/posting/journaldetaillist",
                                data: {
                                    "journalNo": selectedJournalRow["journalNo"] //rowid 분개번호임 
                                },
                                dataType: "json",
                                success: function (jsonObj) {
                                    gridOptions4.api.setRowData(jsonObj);
                                }
                            });
                        }
                    }

                    // 차변 대변 입력
                   // var errBoolean = false;
                    var lastIndex;
                    var lastRow;
                    function Price(event) {
                    	console.log("price(event) 실행");
                        lastIndex = gridOptions2.api.getFirstDisplayedRow();  //0
                        lastRow = gridOptions2.api.getRowNode(lastIndex);  // undifine  (dong)

                        var sum = 0;
                        if (event.data['journalNo'] != "Total") {
                            if (event.data['balanceDivision'] == "차변") {
                                var price = prompt("차변의 금액을 입력해주세요", "");
                                price = price == null ? 0 : price;
                                if (!isNaN(price)) {
                                    gridOptions2.api.applyTransaction([event.data['rightCreditsPrice'] = 0]);
                                    gridOptions2.api.applyTransaction([event.data['leftDebtorPrice'] = price]);
 
                                    computeJournalTotal();
                                } 
                                
                                
                                else {
                                    alert("숫자만 입력해주세요");
                                }
                              
                            }
                            if (event.data['balanceDivision'] == "대변") {
                                var price = prompt("대변의 금액을 입력해주세요", "");
                                price = price == null ? 0 : price;
                                if (!isNaN(price)) {
                                    gridOptions2.api.applyTransaction([event.data['leftDebtorPrice'] = 0]);
                                    gridOptions2.api.applyTransaction([event.data['rightCreditsPrice'] = price]);

                                    computeJournalTotal();
                                }
                                else {
                                    alert("숫자만 입력해주세요");
                                }
                            }
                        }
                        var totalIndex = (gridOptions2.api.getDisplayedRowCount())-1;
                        var totalRow = gridOptions2.api.getDisplayedRowAtIndex(totalIndex); // lastRow.data 이게 먹통이라 소스 수정(dong)

                        if (totalRow.data['leftDebtorPrice'] != 0 && totalRow.data['rightCreditsPrice'] != 0) {
                            if (totalRow.data['leftDebtorPrice'] != totalRow.data['rightCreditsPrice'] ) {
                                alert("차변과 대변이 일치하지 않으면 승인이 거부될 수 있습니다.");

                            }
                        }
                    }
 

                    function saveSlip(confirm) {
		            	var JournalTotalObj = [];
		            	var slipStatus= confirm=="승인요청" ? confirm : null //기본은 null이고 confirm할때만 "승인요청"으로 바뀐다
		            			
                   		if( selectedSlipRow['slipStatus']=="승인요청" || selectedSlipRow['slipStatus']=="승인완료" ){
                            alert("전표 작성중이 아닙니다.\n현재상태 : "+selectedSlipRow['slipStatus']);  //먼저 한번 걸러줌
                  		}
                   		else {
			                gridOptions2.api.forEachNode(function (node, index) {
			                   
			                    	 if(node.data.journalNo !="Total"){
			                         JournalTotalObj.push(node.data); //분개노드 마지막 total 빼고 JournalTotalObj에 담음
			                         console.log(" JournalTotalObj.push(node.data) :" +JSON.stringify(node.data));
			                         console.log(" JournalTotalObj.push(node.data) :" +JSON.stringify(JournalTotalObj));
			                     }
			                });
	
							if(selectedSlipRow['slipNo'] == NEW_SLIP_NO){ //선택된 로우가 new면 

				                $.ajax({
				                	type: "POST",
				                	url: "${pageContext.request.contextPath}/posting/registerslip",
				                	data: {
				                         "slipObj": JSON.stringify(selectedSlipRow),
				                         "journalObj": JSON.stringify(JournalTotalObj),
		                                 "slipStatus": slipStatus
				                	},
				                	async: false,		// 동기식   // 비동기식으로할경우 아래 showslipgrid에서 값을 못불러올수있다.
				              		dataType: "json",
				                  	success: function () { //return 값이 필요 없음(choi)
				                  		enableElement({ "#addSlip": true });
				                      	location.reload();
				                	}
				               	});
				          	}
         
	                     	else if (selectedSlipRow['slipNo'] != NEW_SLIP_NO) { //기존 저장 후 수정 및 반려 후 저장
	                            var JournalTotalObj2 = [];
	                            gridOptions2.api.forEachNode(function (node, index) {
	                                gridOptions2.api.applyTransaction([node.data["status"] = "update"]);
	                                JournalTotalObj2.push(node.data);
	                               console.log("slipStatus:" + slipStatus);
	                               console.log(" JournalTotalObj.push(node.data)!!!! :" +JSON.stringify(JournalTotalObj));
	                            });
		                          //  saveJournal(selectedSlipRow["slipNo"], JournalTotalObj2); 삭제(dong)
	                            $.ajax({
	                                type: "POST",
	                                url: "${pageContext.request.contextPath}/posting/slipmodification",
	                                data: {
				                        "slipObj": JSON.stringify(selectedSlipRow),
				                        "journalObj": JSON.stringify(JournalTotalObj),
	                                    "slipStatus": slipStatus
	                                },
	                                async: false,		
	                                dataType: "json",
	                                success: function (jsonObj) {
	                                    enableElement({ "#addSlip": true });
	                                    console.log("slipNo:" + jsonObj.slipNo);

	                                }
	                            });
							}

	                      	if(confirm=="승인요청") alert("결제 신청이 완료되었습니다.");
	                      	else alert("저장 되었습니다.");
	                      	showSlipGrid();
	                      	showJournalGrid(selectedSlipRow.slipNo); 
                   		}
					}
                    
					function confirmSlip(){
						console.log("comfirmSlip() 실행");
                        var result = true;
                        var compare = compareDebtorCredits();  // for문 안에서 계속 실행되서 밖으로 꺼냄, 한번만 실행되도됨(dong)
                        var approvalStatus = compare.isEqualSum; //isEqualSum=true
                        gridOptions2.api.forEachNode(function (rowNode, index) { //forEachNode=forEach
				            if (rowNode.data["journalNo"] != "Total") { //토탈이 아니면 == 차변과 대변이면
		                        if (rowNode.data["balanceDivision"] == null) {
		                            alert("구분(분개필수 항목)을 확인해주세요");
		                            result = false;
		                            return;
		                        }
		                        if (rowNode.data["accountCode"] == null) {
		                            alert("계정코드(분개필수 항목)을 확인해주세요");
		                            result = false;
		                            return;
		                        }
		                        if (rowNode.data["accountName"] == null) {
		                            alert("계정과목(분개필수 항목)을 확인해주세요");
		                            result = false;
		                            return;
		                        } 
		                        if (!approvalStatus) {    //대변의 합과 차변의 합이 같지 않으면
		                            alert("전표의 차변/대변 총계가 일치하지않습니다.\n 차변/대변 총계를 확인해주세요.");
		                            result = false;
		                            return;
		                        }
							}
      					});
	
                        
                   		if( selectedSlipRow['slipStatus']=="승인요청" || selectedSlipRow['slipStatus']=="승인완료" ){
                            alert("전표 작성중이 아닙니다.\n현재상태 : "+selectedSlipRow['slipStatus']); 
                  		}
                   		else if (result) {
                   			saveSlip("승인요청");
                      		}
						
					}
                    function compareDebtorCredits() { // 대변차변 합계 일치 여부 확인 
                    	console.log("compareDebotrCredits() 실행");
                        var isEqualSum;
                        var debtorPriceSum = 0;
                        var creditsPriceSum = 0;
                      
                        gridOptions2.api.forEachNode(function (node) {
                            debtorPriceSum += parseInt(node.data.leftDebtorPrice);
                            creditsPriceSum += parseInt(node.data.rightCreditsPrice);
                        });
                        var result = { isEqualSum: debtorPriceSum == creditsPriceSum };
               
                        return result;
                    }



                    //분개 추가
                    function addJournalRow() {
                    	console.log("addJournalRow 실행");

                        if (selectedSlipRow["expenseReport"] == "") {
                            alert("적요란을 기입하셔야 합니다.");
                            return;
                        }
                        var journal = gridOptions2.api.getDisplayedRowCount() == 0 ? 1 : gridOptions2.api.getDisplayedRowCount();// 현재 보여지는 로우의 수를 반환
                        var journalObj = {
                            "journalNo": NEW_JOURNAL_PREFIX + journal, //이부분이 분개번호 
                            "leftDebtorPrice": 0,  //차변 금액
                            "rightCreditsPrice": 0,  //대변 금액
                            "status": "insert"
                        };
                        var newObject2 = $.extend(true, {}, journalObj);
                        gridOptions2.api.applyTransaction({ add: [newObject2] });

                        enableElement({
                            "#addSlip": false,
                            "#deleteSlip": true,
                            "#addJournal": true,
                            "#deleteJournal": true,
                            "#createPdf": true,

                        });
                    }

               
                    //찾기
                    function searchSlip() {
                   		console.log("searchSlip() 실행");
                        enableElement({
                            "#addSlip": true,
                            "#deleteSlip": false, //비활성화
                            "#addJournal": false,
                            "#deleteJournal": false,
                            "#showPDF": true,
                        });
                        showSlipGrid();
                        console.log("pdf abled");
                    }

                    //전표 보기
                    function showSlipGrid() {   // 먼저 날짜 데이트를 받고 / 전표추가시 오늘날짜를 actual argument로 넘긴다. 

                        $.ajax({
                            url: "${pageContext.request.contextPath}/posting/rangedsliplist",    
                            data: { 
                                "fromDate": $("#from").val(), 
                                "toDate": $("#to").val(),
                                "slipStatus": $("#selTag").val()
                            },
                            dataType: "json",
                            success: function (jsonObj) { 

                                    gridOptions.api.setRowData(jsonObj);
                                    gridOptions2.api.setRowData([]);

                            },
                            async: false //비동기방식설정 - 순서대로 처리
                        });
/*                         return isSuccess; */
                    }

                    // 분개 보기
                    function showJournalGrid(slipNo) { //slip rowid 선택한 전표행이다
                        // show loading message
                        console.log("showJournalGrid("+slipNo+") 실행");
                        rowData2 = [];

                        var journalObj = { 
                            "journalNo": "Total", //이부분이 분개번호
                            "leftDebtorPrice": 0,  //차변 금액
                            "rightCreditsPrice": 0,  //대변 금액
                            "status": ""
                        };
                        
                        var totalObject = $.extend(true, {}, journalObj);
                        rowData2.push(totalObject);
             

                        if (selectedSlipRow["slipNo"] !== NEW_SLIP_NO) {  
                            $.ajax({
                                type: "GET",
                                async: false,
                                url: "${pageContext.request.contextPath}/posting/singlejournallist",
                                data: {
                                    "slipNo": slipNo
                                },
                                dataType: "json",
                                success: function (jsonObj) {//선택한 전표에 등록된 분개정보

                                  
								console.log(JSON.stringify(jsonObj));
                                    jsonObj.forEach(function (element) {
                                        rowData2.push(element);
                                    }
                                    );


                                jsonObj.forEach(function (element, index) {
                                       

                                        $.ajax({
                                            type: "GET",
                                            async: false,
                                            url: "${pageContext.request.contextPath}/posting/journaldetaillist",
                                            data: {
                                                "journalNo": element["journalNo"] //rowid 분개번호임 
                                            },
                                            dataType: "json",
                                            success: function (jsonObj) {
                                            
                                                element.journalDetailList = jsonObj;
                                            }
                                        });
                                    }); 
                                }
                            });
                        } else {
                        	
                            var journalObj = { //분개1 생성
                                "journalNo": NEW_JOURNAL_PREFIX + 1, //이부분이 분개번호 NEW_JOURNAL_PREFIX = NEW_SLIP_NO + "JOURNAL"
                                "balanceDivision":"차변",
                                "leftDebtorPrice": 0,  //차변 금액
                                "rightCreditsPrice": 0,  //대변 금액
                                "status": "insert"
                            };
                            var journalObj1 = { //분개 2 생성
                                "journalNo": NEW_JOURNAL_PREFIX + 2, //이부분이 분개번호
                                "balanceDivision":"대변",
                                "leftDebtorPrice": 0,  //차변 금액
                                "rightCreditsPrice": 0,  //대변 금액
                                "status": "insert"
                            };
                            var newJournal1 = $.extend(true, {}, journalObj);  
                            // 굳이 이렇게 변수에 담은다음에 배열에 넣을필요있나 ?바로넣지..? 수정하쟈(dong)
                            var newJournal2 = $.extend(true, {}, journalObj1);
                            rowData2.push(newJournal1);
                            rowData2.push(newJournal2);
                            console.log("이거실행!!!");
                        }
                        console.log(rowData2);
                        gridOptions2.api.setRowData(rowData2);
                        computeJournalTotal();
                        
                    }

 


                    var accountGrid;
                	var gridOptionsAccount;
                    
                    function createAccountGrid() { //분개의 계정과목 왼쪽 부모그리드 생성
                		rowData=[];
                	  	var columnDefs1 = [
                		      {headerName: "계정과목 코드", field: "accountInnerCode",sort:"asc", width:120, resizable: true,
                		    	  cellClass: "grid-cell-centered"},//셀의 내용을 중심에 맞춤
                		      {headerName: "계정과목", field: "accountName", resizable: true, cellClass: "grid-cell-centered"},
                		  ];	  	
                		  gridOptionsAccount = { 
                				      columnDefs: columnDefs1,
                				      rowSelection:'single', //row는 하나만 선택 가능
                				      defaultColDef: {editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
                		 			  onGridReady: function (event){// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                		        			event.api.sizeColumnsToFit();
                		    		  },
                		    		  onGridSizeChanged:function (event){ // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                		    		        event.api.sizeColumnsToFit();
                		    		  },
                		    		  onRowClicked:function (event){
                		    			  console.log("Row선2222222222222222택");
                		    			  console.log(event.data);
                		    			  selectedRow=event.data;
                		    			  showAccountDetail(selectedRow["accountInnerCode"]);
                		    		  }
                		}
                		
                		accountGrid = document.querySelector('#accountGrid');
              		 	new agGrid.Grid(accountGrid,gridOptionsAccount);
                    }
                    
                	function showAccount(){ //부모코드 조회함
                		 $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/operate/parentaccountlist",
                            data: {
                            },
                            dataType: "json",
                            success: function (jsonObj) {
                                gridOptionsAccount.api.setRowData(jsonObj); //gridOptionsAccount에 값 붙임
                            }
                        }); 
               		}
                    
                    var gridOpionsAccountDetail
                    
                    function createAccountDetailGrid() {
                    	console.log("createAccountDetailGrid() 실행");
                        rowData = [];
                        var columnDefs = [
                            { headerName: "계정과목 코드", field: "accountInnerCode", width: 120, sortable: true, resizable: true,   },
                            { headerName: "계정과목", field: "accountName", sortable: true, resizable: true,   },
                        ];

                        gridOpionsAccountDetail = {
                            columnDefs: columnDefs,
                            rowSelection: 'single', //row는 하나만 선택 가능
                            defaultColDef: { editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
/*                             pagination: true, // 페이저
                            paginationPageSize: 15, // 페이저에 보여줄 row의 수 */
                            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                                event.api.sizeColumnsToFit();
                            },
                            onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                                event.api.sizeColumnsToFit();
                            },
                            onCellDoubleClicked: function (event) {
                                $("#accountGridModal").modal('hide');
                                gridOptions2.api.applyTransaction([selectedJournalRow['accountCode'] = event.data["accountInnerCode"]]);
                                gridOptions2.api.applyTransaction([selectedJournalRow['accountName'] = event.data["accountName"]]);
								console.log("event.data[accountInnerCode] :" + event.data["accountInnerCode"]);
                                $.ajax({ //여기서부터는 분개상세
                                    type: "GET",
                                    url: "${pageContext.request.contextPath}/operate/accountcontrollist",
                                    data: {
                                        accountCode: event.data["accountInnerCode"] //이값이 겁색한 값이다. ex)매출
                                    },
                                    dataType: "json",
                                    success: function (jsonObj) {
                                        console.log(jsonObj);
                                        ///     gridOptions2.api.applyTransaction([selectedJournalRow['journalDetail']=jsonObj['accountControl']]);


                                        console.log(selectedJournalRow['journalNo']);

                                        jsonObj['accountControl'].forEach(function (element, index) { //분개상세 key값
                                            element['journalNo'] = selectedJournalRow['journalNo']; //요소추가?
                                        })
                                        console.log(jsonObj['accountControl']);
                                        gridOptions2.api.applyTransaction([selectedJournalRow['journalDetailList'] = jsonObj['accountControl']]);
                                       
                                        console.log("selectedJournalRow :" +selectedJournalRow);
                                        gridOptions2.api.redrawRows(); //행 다시 그리기
                                    }
                                });
                            }
                        };
                        accountDetailGrid = document.querySelector('#accountDetailGrid');
                        new agGrid.Grid(accountDetailGrid, gridOpionsAccountDetail); //div 태그에 붙임
                    }
                    
                    
                    
                    function showAccountDetail(code) { //code 에 selectedRow["accountInnerCode"] 값 들어감
                        $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/operate/detailaccountlist",
                            data: {
                                "code": code
                            },
                            dataType: "json",
                            success: function (jsonObj) {
                            	gridOpionsAccountDetail.api.setRowData(jsonObj);
                            }
                        });
                    }
                    ///  모달 내부에서 검색
                    function searchAccount() {
                   	console.log("searchAccount() 실행");
                        // show loading message   
                        $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/operate/accountlistbyname",
                            data: {
                                accountName: $("#accountCode").val() //이값이 겁색한 값이다. ex)매출
                            },
                            dataType: "json",
                            success: function (jsonObj) {
                            	gridOpionsAccountDetail.api.setRowData(jsonObj.accountList); //내부 상세 그리드
                                $("#accountCode").val(""); // 검색한다음에 지우기 셋팅(dong)
                            }
                        });  
                    }
                    //거래처코드 
                     function searchCustomerCodeList() { // 거래처리스트 불러오기
						
							$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/operate/allworkplacelist",
					data : {
					},
					dataType : "json",
					success : function(jsonObj) {
						//console.log("거래처코드 : " +JSON.stringify(jsonObj.allWorkplaceList));
						 gridOptions6.api.setRowData(jsonObj);

					}
				});
	}

                    // 계정코드 입력시 계정과목 검색   
                    function getAccountName(accountCode) {
                    	console.log("findAccountName(accountCode) 실행");
                        $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/operate/account",
                            data: {
                                accountCode: accountCode
                            },
                            dataType: "json",
                            success: function (jsonObj) {
                                var accountName = jsonObj.accountName;
                                gridOptions2.api.applyTransaction([selectedJournalRow['accountName'] = accountName]);
                            },
                            async: false
                        });
                    }

                    
                    //분개 상세
                    
                    var selectedJournalDetail;
                    var gridOptions4;
                                       
                     function createjournalDetailGrid() {
                    	 console.log("createjournalDetailGrid() 실행");
                        rowData = [];
                        var columnDefs = [
                            { headerName: "계정 설정 속성", field: "accountControlType", width: 150, sortable: true },
                            { headerName: "분개 상세 번호", field: "journalDetailNo", width: 150, sortable: true },
                            { headerName: "-", field: "status", width: 100, hide: true },
                            { headerName: "-", field: "journalDescriptionCode", width: 100, hide: true },
                            { headerName: "분개 상세 항목", field: "accountControlName", width: 150, },
                            { headerName: "분개 상세 내용", field: "journalDescription", width: 250, cellRenderer: cellRenderer}
                        ]; 
                      
                        
                        gridOptions4 = {
                            columnDefs: columnDefs,
                            rowSelection: 'single', //row는 하나만 선택 가능
                            defaultColDef: { editable: false }, // 정의하지 않은 컬럼은 자동으로 설정
                            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                                event.api.sizeColumnsToFit();
                            },
                            onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                                event.api.sizeColumnsToFit();
                            },
                            onRowClicked: function (event) {
                                selectedJournalDetail = event.data;
                                cellRenderer(event); 
                                console.log('분개 상세 선택11111111111111됨');
                            },
                            onCellDoubleClicked: function (event) {
                            	console.log("onCellDoubleClicked 실행");
                                if (event.data["accountControlType"] == "SEARCH") {
                                    $("#codeModal").modal('show');
                                }
                                else if (event.data["accountControlType"] == "SELECT") {
                                    gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescription"] = selectBank()]);

                                }
                                else if (event.data["accountControlType"] == "TEXT") {
                                    var str = prompt('상세내용을 입력해주세요', '');
                                    gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescription"] = str]);
                                    saveJournalDetailRow();
                                }
                                else {
                                    gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescription"] = selectCal()]);
                                }
                                
                            },
                            onCellChangedValue: function (event) {
                            	console.log("onCellChangedValue 실행");
                                console.log("분개 디테일 수정 : " + event.data);
                            }

                        };
                        journalDetailGrid = document.querySelector('#journalDetailGrid');
                        new agGrid.Grid(journalDetailGrid, gridOptions4);
                    }

                  	function cellRenderer(params) {  // 중복되는일이라 불필요(dong)
                    	console.log("cellRenderer(params) 실행");
                        var result;
                        if (params.value != null)
                            result = params.value;
                        else
                            result = ''

                        return result;
                    }

                    var gridOptions5;
                    function createCodeGrid() {
                    	console.log("createCodeGrid() 실행");
                        rowData = [];
                        var columnDefs = [{
                            headerName: "코드",
                            field: "detailCode",
                            width: 100,
                            sortable: true,
                        }, {
                            headerName: "부서이름",
                            field: "detailCodeName",
                            width: 100,
                            sortable: true,
                        }];

                        gridOptions5 = {
                            columnDefs: columnDefs,
                            rowSelection: 'single', //row는 하나만 선택 가능
                            defaultColDef: {
                                editable: false
                            }, // 정의하지 않은 컬럼은 자동으로 설정
                            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                                event.api.sizeColumnsToFit();
                            },
                            onGridSizeChanged: function (event) { // 그리드의 사이즈가 변하면 자동으로 컬럼의 사이즈 정리
                                event.api.sizeColumnsToFit();
                            },
                            onRowClicked: function (event) {
                            	console.log("onRowClicked 실행+ 위에@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@꺼");
                                var detailCodeName = event.data["detailCodeName"]
                                var detailCode = event.data["detailCode"]
                                console.log(detailCodeName);
                                gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescription"] = detailCodeName]); //journalDescription 분개상세내용
                                gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescriptionCode"] = detailCode]); 
                                saveJournalDetailRow();
                                gridOptions2.api.getDetailGridInfo('detail_' + selectedJournalRow); //쓰는데가 없는거같은데...
                                $("#codeModal").modal('hide');
                            }
                        };
                        codeGrid = document.querySelector('#codeGrid');
                        new agGrid.Grid(codeGrid, gridOptions5);
                    }
                    
                    //거래처 코드
                  var rowDataCode;
                    var gridOpions6;
              		function createCustomerCodeGrid() {
              			rowDataCode = [];
              	        var columnDefs = [
              	        	 { headerName: "사업장 코드", field: "workplaceCode", width: 100,hide: true },
              	            { headerName: "거래처 코드", field: "companyCode", width: 100 },
              	            { headerName: "사업장명", field: "workplaceName", width: 100 },
              	            { headerName: "대표자명", field: "workplaceCeoName", width: 100,hide: true },
              	            { headerName: "업태", field: "businessConditions", width: 100,hide: true },
              	            { headerName: "사업자등록번호", field: "businessLicense", width: 100 },
              	            { headerName: "법인등록번호", field: "corporationLicence", width: 100,hide: true },
              	            { headerName: "사업장전화번호", field: "workplaceTelNumber", hide: true },
              	            { headerName: "승인상태", field: "approvalStatus", width: 100 ,hide: true},
              	        ];

              	        gridOptions6 = {
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

   
              	            //cell double click
              	                  onCellDoubleClicked: function (event) {
                                $("#customerCodeModalGrid").modal('hide');
                                gridOptions2.api.applyTransaction([selectedJournalRow['customerName'] = event.data["workplaceName"]]);

                            }
              	        };
              	      customerCodeGrid = document.querySelector('#customerCodeGrid');
              	        new agGrid.Grid(customerCodeGrid, gridOptions6);
              		}

					//분개 상세 부서조회에서의 코드조회
                    function searchCode() {
                    	console.log("searchCode 실행");
                        $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/base/detailcodelist",
                            data: {
                                divisionCodeNo: selectedJournalDetail["accountControlDescription"], //accountControlDescription = ACCOUNT_CONTROL_DETAIL의 Description
                                detailCodeName: $("#searchCode").val() //부서 입력한 값
                            },
                            dataType: "json",
                            success: function (jsonObj) {
                                gridOptions5.api.setRowData(jsonObj.detailCodeList);
                               
                            },
                            async: false
                        });
                    }
   


                    function selectBank() {
                	  console.log("selectBank() 실행");
                        ele = document.createElement("select");
                        ele.id = "selectId"
                        $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/base/detailcodelist",
                            data: {
                                divisionCodeNo: selectedJournalDetail["accountControlDescription"]
                            },
                            dataType: "json",
                            async: false,
                            success: function (jsonObj) {
                                console.log(jsonObj);
                                $("<option></option>").appendTo(ele).val('').html('')  //val()은 빼도 상관없을듯(dong)
                                $.each(jsonObj.detailCodeList, function (index, obj) {
                                    $("<option></option>").appendTo(ele).val(obj.detailCode + ", " + obj.detailCodeName).html(obj.detailCodeName); //앞이 코드번호 , 뒤에가 계좌번호
                                }); //위에서 빈칸넣고 each에서 값넣고 
                            }
                        });

                        $(ele).change(function () {
                        	console.log("$(ele).change 실행");
                            gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescription"] = $(this).children("option:selected").text()]);
                            gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescriptionCode"] = $(this).val()]);
                            saveJournalDetailRow();
                        })

                        return ele;
                    }

                    function selectCal() {
                    	console.log("selectCal 실행");
                        ele = document.createElement("input");
                        ele.type = "date"
                        $(ele).change(function () {
                            gridOptions4.api.applyTransaction([selectedJournalDetail["journalDescription"] = $(ele).val()]);
                            saveJournalDetailRow();
                        })
                        return ele;
                    }


                    function saveJournalDetailRow() {
                    	console.log("saveJournalDetailRow() 실행");
                    	console.log(selectedJournalRow);
                    	var rjournalDescription;
                        if (selectedJournalDetail["accountControlType"] == "SELECT" || selectedJournalDetail["accountControlType"] == "SEARCH")
                            rjournalDescription = selectedJournalDetail["journalDescriptionCode"]; //- 숨겨진 곳에 저장한 값

                        else
                            rjournalDescription = selectedJournalDetail["journalDescription"];

                        $.ajax({
                            type: "GET",
                            url: "${pageContext.request.contextPath}/posting/journaldetailmodification",
                            data: {
                                journalNo: selectedJournalRow["journalNo"],
                                accountControlType: selectedJournalDetail["accountControlType"],
                                journalDetailNo: selectedJournalDetail["journalDetailNo"],
                                journalDescription: rjournalDescription

                            },
                            dataType: "json",
                            async: false,
                            success: function (jsonObj) {
                                console.log("분개 상세  저장 성공");
                            }
                        });
                    } 
                    
                    /*분개 합계 계산*/
                    
              		function computeJournalTotal() {
                	   console.log("computeJournalTotal 실행");
                       	var totalIndex = (gridOptions2.api.getDisplayedRowCount())-1;

 
                         //표시된 행의 총 수를 반환합니다.
                        var totalRow = gridOptions2.api.getDisplayedRowAtIndex(totalIndex);
                         console.log("totalRow :" + JSON.stringify(totalRow.data));
                        //지정된 인덱스에 표시된 RowNode를 반환합니다. 즉 마지막 total의 정보를 담고있음
                        var leftDebtorTotal =0;
                        var rightCreditsTotal =0;

                         gridOptions2.api.forEachNode(function (node, index) {
                        	 console.log(node);
                            if (node != totalRow ) {
                            	if(node.journalNO!="Total"){
                                	leftDebtorTotal += parseInt(node.data.leftDebtorPrice);
                                	rightCreditsTotal += parseInt(node.data.rightCreditsPrice);
                         		}
                            }
                       	});
                        totalRow.setDataValue('leftDebtorPrice', leftDebtorTotal);
                        totalRow.setDataValue('rightCreditsPrice', rightCreditsTotal);   
					}
                    
              		// 거래처 그리드 생성
                    
              		
                    
                   
                   
                    
                    
                </script>
        </head>

        <body class="bg-gradient-primary">
            <h4>전표</h4>
            <hr>
            <div class="row">

                <input id="from" type="date" class="date" required style="margin-left:12px;">
                <input id="to" type="date" class="date" required>
                <select id="selTag" class="date" id="selTag">
                    <option>승인여부</option> 
                    <option>작성중</option>
                    <option>승인요청</option>
                    <option>승인완료</option>
                    <option>작성중(반려)</option>
                </select>
                <input type="button" id="search" value="검색" class="btn btn-Light shadow-sm btnsize2"
                    style="margin-left:5px;">
            </div>

            <div>

                <div style="text-align:right;">
                    <input type="button" id="addSlip" value="전표 추가(F2)" class="btn btn-Light shadow-sm btnsize">
                    <input type="button" id="deleteSlip" value="전표 삭제" class="btn btn-Light shadow-sm btnsize">
                    <input type="button" id="showPDF" value="PDF보기" class="btn btn-Light shadow-sm btnsize">
                    <input type="button" id="saveSlip" value="전표 저장(F3)" class="btn btn-Light shadow-sm btnsize">
                    <input type="button" id="confirm" value="결재 신청(F4)" class="btn btn-Light shadow-sm btnsize">

                </div>
            </div>
            <div align="center"> <!-- 셀정렬 -->
                <div id="slipGrid" class="ag-theme-balham" style="height:250px;width:auto;"></div>
            </div>
            <hr />
            <h3>분개</h3>
            <div align="right">
                <input type="button" id="addJournal" value="분개 추가" class="btn btn-Light shadow-sm btnsize">
                <input type="button" id="deleteJournal" value="분개 삭제" class="btn btn-Light shadow-sm btnsize">
                <div id="journalGrid" class="ag-theme-balham" style="height:450px;width:auto;"></div>
            </div>
            
            
            <div  class="modal fade" id="accountGridModal" tabindex="-1" role="dialog"
                aria-labelledby="accountGridLabel" style="padding-right: 210px;">
                <div class="modal-dialog" role="document" >
                    <div class="modal-content" style="width: 645px; margin-top: 130px">
                        <div class="modal-header">
                            <h5 class="modal-title" id="accountGridLabel">계정 코드 조회</h5>
                            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                        <div class="modal-header">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="계정과목을 입력해주세요"
                                id="accountCode" aria-label="AccountSearch" aria-describedby="basic-addon2">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="button" id="Accountbtn">
                                    <i class="fas fa-search fa-sm"></i>
                                </button>
                            </div>
                        </div>
                        <div class="modal-body">                       
                            <div style="float: left; width: 50%;" >
								<div align="center"> <!-- 셀 정렬 -->
									<div id="accountGrid" class="ag-theme-balham"
									 style="height: 500px; width: 100%; margin-left:-10px;"></div>
								</div>
							</div> 
			
							<div style="float: left; width:50%;">
								<div align="center"> <!-- 셀 정렬 -->
									<div id="accountDetailGrid" class="ag-theme-balham"
										style="height: 500px; width: 100%; margin-left:5px;"></div>
								</div>
							</div>
                        </div>
                    </div>
                </div>
            </div>


            <div align="center" class="modal fade" id="journalDetailGridModal" tabindex="-1" role="dialog"
                aria-labelledby="journalDetailGridLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content" style="width:700px;">
                        <div class="modal-header">
                            <h5 class="modal-title" id="journalDetailGridLabel">분개 상세</h5>
                            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div align="center" id="journalDetailGrid" class="ag-theme-balham"
                                style="width:100%;height:200px"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div align="center" class="modal fade" id="codeModal" tabindex="-1" role="dialog"
                aria-labelledby="codeLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="codeLabel">부서 코드 조회</h5>
                            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                        <div class="modal-header">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="부서를 입력해주세요"
                                id="searchCode" aria-label="deptSearch" aria-describedby="basic-addon2">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="button" id="searchCodebtn">
                                    <i class="fas fa-search fa-sm"></i>
                                </button>
                            </div>
                        </div>
                        <div class="modal-body">
                            <div align="center" id="codeGrid" class="ag-theme-balham" style="width:auto;height:150px">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 거래처 코드 -->
             <div align="center" class="modal fade" id="customerCodeModalGrid" tabindex="-1" role="dialog"
                aria-labelledby="customerCodeModalGrid">
                <div class="modal-dialog" role="document">
                    <div class="modal-content" style="width:700px;">
                        <div class="modal-header">
                            <h5 class="modal-title" id="customerCodeModalLabel">거래처 코드</h5>
                            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                        <div class="modal-body">                       
                            
								<div align="center"> <!-- 셀 정렬 -->
									<div id="customerCodeGrid" class="ag-theme-balham"
									 style="height: 500px; width: 100%; margin-left:-10px;"></div>
								</div>
							
			
                        </div>
                    </div>
                </div>
            </div>
            

        </body>

        </html>
        
<!-- 
/***********************************************************************************
SELECT * FROM JOURNAL;
SELECT * FROM JOURNAL_DETAIL;
SELECT * FROM ACCOUNT_CONTROL_CODE;
SELECT * FROM ACCOUNT_CONTROL_DETAIL;
SELECT * FROM CODE_DETAIL;




SELECT * FROM MENU_AVAILABLE_BY_POSITION;
SELECT * FROM POSITION;
SELECT * FROM AUTHORITY_EMP;
SELECT * FROM AUTHORITY;
SELECT * FROM AUTHORITY_MENU;
SELECT * FROM MENU
SELECT * FROM MENU_AVAILABLE_BY_POSITION
SELECT * FROM POSITION
SELECT * FROM EMPLOYEE


************************************************************************************/ -->