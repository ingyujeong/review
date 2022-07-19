<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title> 회원정보관리</title>

    <%-- jqGrid --%>
    <script type="text/ecmascript" src="${pageContext.request.contextPath}/assets/js/i18n/grid.locale-kr.js"></script>
    <script type="text/ecmascript" src="${pageContext.request.contextPath}/assets/js/jquery.jqGrid.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ui.jqgrid-bootstrap4.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/octicons/4.4.0/font/octicons.css">

    <script>
        $.jgrid.defaults.styleUI = 'Bootstrap4';
        $.jgrid.defaults.iconSet = "Octicons";
    </script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"
            integrity="sha384-FzT3vTVGXqf7wRfy8k4BiyzvbNfeYjK+frTVqZeNDFl8woCbF0CYG6g2fMEFFo/i"
            crossorigin="anonymous"></script>
            
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

    <script>
        var deptListGrid = "#deptListGrid";
        var employeeListGrid = "#employeeListGrid";
        var selectedEmployeeRow;

        $(document).ready(function () {
            // $('[data-toggle="datepicker-to"]').datepicker({language: 'ko-KR', format: 'yyyy-mm-dd', trigger: $('.docs-datepicker-to-trigger')});
            // $('[data-toggle="datepicker-from"]').datepicker({language: 'ko-KR', format: 'yyyy-mm-dd', trigger: $('.docs-datepicker-from-trigger')});

            createEmployeeList();
            createDeptList();

            $("button.show-dept-button").click(
                function () {
                    $("#deptListModal").modal();
                    showDeptList();
                }
            );

            $("button#saveEmployee").click(saveEmployee);

            $("input#selectProfileImage").change(function () {
                var fileReader = new FileReader();

                fileReader.onload = function (e) {
                    $("#profileImage").attr("src", e.target.result);
                }

                fileReader.readAsDataURL(this.files[0]);
            });
            $(".imageControl .fa-close").click(deleteImage);
            $(".imageControl .fa-upload").click(uploadImage);
            
            $("#addEmployee").click(addEmployeeFunc);
            $("#deleteEmployee").click(deleteEmployeeFunc);
        });

        function deleteImage() {
            $("img#profileImage").attr("src", "${pageContext.request.contextPath}/photos/unknown.jpg");
        }

        function uploadImage() {
            $("input#selectProfileImage").click();
        }

        function saveEmployee() {
            $("input[name='empCode']").val($("input#empCode").val());

            var options = {
                dataType: "json",
                success: function (jsonObj) {
                    $("#profileImage").attr("src", jsonObj.url);
                    saveEmployeeData();
                }
            };

            $("#profileForm").ajaxForm(options).submit();

            function saveEmployeeData() {
                var employeeInfo = {};

                var inputForm = $("#employeeEditModal .modal-body input[id]");
                console.log(inputForm)
                var profileImage = $("img#profileImage").attr("src");
                $.each(inputForm, function (index, obj) {
                	
                    employeeInfo[obj.id] = $("input#" + obj.id).val();
                    console.log(employeeInfo[obj.id]);
                });

                var jsonString = JSON.stringify(employeeInfo);
				console.log(jsonString);
                $.ajax({
                    url: "${pageContext.request.contextPath}/operate/batchempinfo",
                    type: "post",
                    data: {
                        "employeeInfo": jsonString,
                        "image": profileImage.substring(profileImage.lastIndexOf("/") + 1)
                    },
                    dataType: "json",
                    success: function () {
                        $("#employeeEditModal").modal("hide");
                        showEmployeeList();
                    }
                });
            }
        }

        function createEmployeeList() {

            $(employeeListGrid).jqGrid({
                colModel: [
                    {name: "empCode", label: "사원번호", type: "text", key: true},
                    {name: "empName", label: "성명", type: "text"},
                    {name: "deptCode", label: "부서코드", type: "text"},
                    {name: "gender", label: "성별", type: "text"},
                    {name: "birthDate", label: "생년월일", type: "number"},
                    {name: "positionCode", label: "직급", type: "text"},
                    {name: "status", label: "상태", type: "text"}
                ],
                viewrecords: true,
                autowidth: true,
                responsive: true,
                height: 562,
                rowNum: 20,
                datatype: 'local',
                pager: "#employeeGridPager",

                onSelectRow: function (key) {
                    $("div#employeeEditModal").modal();
                    selectedEmployeeRow = $(employeeListGrid).jqGrid("getLocalRow", key);
                    
                    $.ajax({
                        type: "GET",
                        url: "${pageContext.request.contextPath}/operate/employee",
                        data: {
                            "empCode": key
                        },
                        dataType: "json",
                        success: function (obj) {
                            var item = obj.employeeInfo;

                            $("img#profileImage").attr("src", "${pageContext.request.contextPath}/photos/" + item.image + "?" + new Date().getTime());

                            var inputForm = $("#employeeEditModal .modal-body input[id]");
                            $.each(inputForm, function (index, obj) {
                                $("input#" + obj.id).val(item[obj.id]);
                            });
                        }
                    });
                }
            });
        }

        function showEmployeeList() {
        	$(employeeListGrid).jqGrid("clearGridData");
            // show loading message
            $(employeeListGrid)[0].grid.beginReq();
            $.ajax({
                type: "GET",
                url: "${pageContext.request.contextPath}/operate/employeelist",
                data: {
                    "deptCode": $("input#searchedDeptCode").val()
                },
                dataType: "json",
                success: function (jsonObj) {
                    $(employeeListGrid).jqGrid('setGridParam', {data: jsonObj.empList});
                    // hide the show message
                    $(employeeListGrid)[0].grid.endReq();
                    // refresh the grid
                    $(employeeListGrid).trigger('reloadGrid');
                }
            });

            $(employeeListGrid)[0].grid.endReq();
        }

        function createDeptList() {
            $(deptListGrid).jqGrid({
                colModel: [
                    {name: "detailCode", label: "코드", type: "text", key: true},
                    {name: "detailCodeName", label: "부서명", type: "text"}
                ],
                viewrecords: true,
                width: 465,
                height: 300,
                rowNum: 20,
                datatype: 'local',

                onSelectRow: function (key) {
                    var item = $(deptListGrid).jqGrid("getRowData", key);

                    $("input#searchedDeptCode").val(item.detailCode);
                    $("input#searchedDeptName").val(item.detailCodeName);

                    $("#deptListModal").modal('hide');
                }
            });
        }

        function showDeptList() {

            // show loading message
            $(deptListGrid)[0].grid.beginReq();
            $.ajax({
                type: "GET",
                url: "${pageContext.request.contextPath}/base/detailcodelist",
                data: {
                    "divisionCodeNo": "CO-03"
                },
                dataType: "json",
                success: function (jsonObj) {
                    // set the new data
//                     console.log(jsonObj.detailCodeList);
                    $(deptListGrid).jqGrid('setGridParam', {data: jsonObj.detailCodeList});
                    // hide the show message
                    $(deptListGrid)[0].grid.endReq();
                    // refresh the grid
                    $(deptListGrid).trigger('reloadGrid');
                }
            });

            $(deptListGrid)[0].grid.endReq();
        }
        
        function addEmployeeFunc(){
        	location.href = "${pageContext.request.contextPath}/operate/empinsertform";
        }
        
        function deleteEmployeeFunc(){
        	$.ajax({
        		url : "${pageContext.request.contextPath}/operate/employeeremoval",
        		data : {
        			"empCode" : selectedEmployeeRow.empCode
        		},
        		dataType : "json",
        		success : function(){
        			$(employeeListGrid).jqGrid("delRowData", selectedEmployeeRow.empCode);
        			$(employeeListGrid).jqGrid("clearGridData");
        			showEmployeeList();
        		}
        	});
        }
        
        function zipCodeListFunc() {
    		new daum.Postcode({
    			oncomplete : function(data) {
    				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
    				// 예제를 참고하여 다양한 활용법을 확인해 보세요.
    				$("#zipCode").val(data.zonecode);
    				$("#basicAddress").val(data.address);
    				$("#detailAddress").val(data.buildingName);
    			}
    		}).open();
    	}
    </script>
</head>
<body>
    <div class="col-12">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-sm-6 form-row ml-0">
                        <div class="mr-1">
                            <div class="input-group">
                                <input id="searchedDeptCode" type="hidden">
                                <input id="searchedDeptName" type="text" class="form-control form-control-sm docs-date"
                                       placeholder="부서 검색" readonly>
                                <div class="input-group-append">
                                    <button type="button"
                                            class="form-control form-control-sm btn btn-outline-secondary show-dept-button">
                                        <i style="color:#FD7D86;" class="fa fa-list" aria-hidden="true"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div>
                            <button type="button" id="search"
                                    class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
                                    onclick="showEmployeeList();">
                                검색
                            </button>
                        </div>
                    </div>
                    <div class="col-sm-6 text-right">
                        <div class="form-row mr-0">
                            <div class="ml-auto mr-0">
                                <button type="button" id="addEmployee"
                                        class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
                                        style="width:100px">
                                    사원 추가
                                </button>
                                <button type="button" id="deleteEmployee"
                                        class="form-control form-control-sm btn btn-flat btn-outline-dark mb-3"
                                        style="width:100px">
                                    사원 삭제
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <table id="employeeListGrid"></table>
                    <div id="employeeGridPager"></div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="deptListModal" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">부서 검색</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>×</span></button>
                </div>
                <div class="modal-body">
                    <table id="deptListGrid"></table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="employeeEditModal" aria-hidden="true" style="display: none;">
        <div class="modal-dialog" style="max-width:600px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">사원 수정</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>×</span></button>
                </div>
                <div class="modal-body row">
                    <div class="col-4 form-group">
                        <label for="profileImageArea" class="col-form-label">프로필 사진</label>
                        <form id="profileForm" method="post" enctype="multipart/form-data"
                              action="${pageContext.request.contextPath}/base/imgFileupload.do">

                            <input type="hidden" name="method" value="image">
                            <input type="hidden" name="empCode">
                            <div id="profileImageArea">
                                <img id="profileImage" src="${pageContext.request.contextPath}/photos/unknown.jpg">
                                <div class="row imageControl">
                                    <div class="col-6">
                                        <i class="fa fa-upload" aria-hidden="true"></i>
                                        <input id="selectProfileImage" name="selectProfileImage" type="file"
                                               style="display: none;">
                                    </div>
                                    <div class="col-6">
                                        <i class="fa fa-close" aria-hidden="true"></i>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <%--<div class="col-sm-6">--%>
                        <%--<input type="file">--%>
                        <%--</div>--%>
                        <%--<div class="col-sm-6">--%>
                        <%--<button></button>--%>
                        <%--</div>--%>
                    </div>
                    <div class="col-8 form-row">
                        <div class="form-group col-5">
                            <label for="empCode" class="col-form-label">코드</label>
                            <input class="form-control" type="text" id="empCode" disabled>
                        </div>
                        <div class="form-group col-7">
                            <label for="userPW" class="col-form-label">비밀번호</label>
                            <input class="form-control" type="password" id="userPw">
                        </div>
                        <div class="form-group col-5">
                            <label for="empName" class="col-form-label">이름</label>
                            <input class="form-control" type="text" id="empName">
                        </div>
                        <div class="form-group col-7">
                            <label for="socialSecurityNumber" class="col-form-label">주민번호</label>
                            <input class="form-control" type="text" id="socialSecurityNumber" disabled>
                        </div>
                        <div class="form-group col-5">
                            <label for="positionName" class="col-form-label">직급</label>
                            <input class="form-control" type="text" id="positionName">
                            <input type="hidden" id="positionCode">
                        </div>
                        <div class="form-group col-7">
                            <label for="deptName" class="col-form-label">부서</label>
                            <input class="form-control" type="text" id="deptName">
                            <input type="hidden" id="deptCode">
                        </div>
                    </div>
                    <div class="form-group col-4">
                        <label for="phoneNumber" class="col-form-label">전화번호</label>
                        <input class="form-control" type="text" id="phoneNumber">
                    </div>
                    <div class="form-group col-8">
                        <label for="eMail" class="col-form-label">이메일</label>
                        <input class="form-control" type="text" id="eMail">
                    </div>
                    <div class="form-group col-4">
                        <label for="zipCode" class="col-form-label">우편번호</label>
                        <div class="input-group">
                            <input class="form-control" type="text" id="zipCode" readonly>
                            <div class="input-group-append">
                                <button type="button" class="form-control btn btn-outline-secondary" onclick="zipCodeListFunc()">
                                    <i style="color:#FD7D86;" class="fa fa-search" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="form-group col-8">
                        <label for="basicAddress" class="col-form-label" readonly>기본주소</label>
                        <input class="form-control" type="text" id="basicAddress">
                    </div>
                    <div class="form-group col-12">
                        <label for="detailAddress" class="col-form-label">상세주소</label>
                        <input class="form-control" type="text" id="detailAddress">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-sm btn-primary" id="saveEmployee">저장</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
