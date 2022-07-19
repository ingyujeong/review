<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <style>
    </style>
    <script>
        var codeNo;
        var detcodeNo;
        $(document).ready(function () {

            $("button").button();

            showCodeGrid();
            showDetailCodeGrid("CL-01");

            $("#detailCodeplus").click(detailCodeplusfunc);
            $("#detailCodedel").click(detailCodedelfunc);
            $("#batch").click(batchfunc).button();


        });

        function showCodeGrid() {

            $.jgrid.gridUnload("#codeGrid"); /*리로드*/
            $("#codeGrid")
                .jqGrid(
                    {
                        url: "${pageContext.request.contextPath}/base/codelist",
                        datatype: "json",
                        postData: {

                        },
                        jsonReader: {
                            root: "codeList"
                        },
                        colNames: ["구분코드", "타입", "코드명"],
                        colModel: [{
                            name: "divisionCodeNo",
                            width: 150,


                        }, {
                            name: "codeType",

                            width: 150,
                            align: "center",

                        }, {
                            name: "divisionCodeName",
                            width: 200,

                        }],
                        caption: "코드 리스트",
                        width: 600,
                        height: 460,
                        hoverrows: true,
                        rownumbers: true,
                        multiselect: true,
                        multiboxonly: true,
                        viewrecords: true,
                        cache: false,
                        gridview: true,
                        rowNum: 50,
                        onSelectRow: function (rowid) {


                            codeNo = $(this).jqGrid("getRowData", rowid).divisionCodeNo;

                            showDetailCodeGrid(codeNo);

                        }

                    });

        }

        function showDetailCodeGrid(code) {

            $.jgrid.gridUnload("#detailCodeGrid"); /*리로드*/
            $("#detailCodeGrid")
                .jqGrid(
                    {
                        url: "${pageContext.request.contextPath}/base/detailcodelist",
                        datatype: "json",
                        postData: {
                            "code": code
                        },
                        jsonReader: {
                            root: "detailCodeList"
                        },
                        colNames: ["상위구분코드", "세부코드", "세부코드명", "업데이트상태"],
                        colModel: [{
                            name: "divisionCodeNo",
                            width: 150,

                        }, {
                            name: "detailCode",
                            width: 150,
                            align: "center",
                            editable: true
                        }, {
                            name: "detailCodeName",
                            width: 200,
                            editable: true

                        }, {
                            name: "status",
                            width: 200,


                        }],
                        caption: "세부코드 목록",
                        width: 600,
                        height: 460,
                        hoverrows: true,
                        rownumbers: true,
                        multiselect: true,
                        multiboxonly: true,
                        viewrecords: true,
                        cellEdit: true,
                        cellsubmit: 'clientArray',
                        gridview: true,
                        rowNum: 100,
                        afterEditCell: function (rowid, name, val, iRow, iCol) {
                            var stat = $(this).getRowData(rowid).status;

                            if (stat != "insert") {
                                $(this).setCell(rowid, "status", "update");
                            }
                        },

                        onSelectRow: function (rowid) {


                            detcodeNo = $(this).jqGrid("getRowData", rowid).divisionCodeNo;


                        }

                    });

        }

        function detailCodeplusfunc() {
            var nextSeq = Number($("#detailCodeGrid").getGridParam("records")) + 1;
            var nextCode = 1;
            var alldetailCodeRows = $("#detailCodeGrid").getDataIDs();
            var DetailCode = $("#detailCodeGrid").jqGrid("getRowData", 1).detailCode;
            var originCode = DetailCode.substring(0, 3);
            codeNo = $("#detailCodeGrid").jqGrid("getRowData", 1).divisionCodeNo;
            $.each(alldetailCodeRows, function (index, val) {
                var detCode = $("#detailCodeGrid").jqGrid("getRowData", val).detailCode
                var thisDetailCode = originCode + nextCode;
                if (detCode = thisDetailCode) {
                    nextCode++;
                }
                ;
            });
            nextCode = codeMaker(nextCode, 2);

            var emptycode = {"divisionCodeNo": codeNo, "detailCode": originCode + "-" + nextCode, "status": "insert"};
            $("#detailCodeGrid").addRowData(nextSeq, emptycode);

        }

        function codeMaker(num, width) {

            num = num + '';
            return num.length >= width ? num : new Array(width - num.length + 1).join('0') + num;
        }


        function detailCodedelfunc() {

            var selectedCodeIds = $("#detailCodeGrid").getGridParam("selarrrow");

            selectedCodeIds.sort(function (a, b) {
                return b - a;
            });
            for (var ix = 0; ix < selectedCodeIds.length; ix++) {
                var codeData = $("#detailCodeGrid").getRowData(selectedCodeIds[ix]);
                if (codeData.status == "normal" || codeData.status == "update")
                    $("#detailCodeGrid").setCell(selectedCodeIds[ix], "status", "delete");
                else if (codeData.status == "delete")
                    $("#detailCodeGrid").setCell(selectedCodeIds[ix], "status", "update");
                else
                    $("#detailCodeGrid").delRowData(selectedCodeIds[ix--]);
            }
        }

        function batchfunc() {
            var updateDetailCodeData = $("#detailCodeGrid").getRowData();
            var updateCodeData = $("#codeGrid").getRowData();

            var detailCodejson = JSON.stringify(updateDetailCodeData);
            var codejson = JSON.stringify(updateCodeData);
            $.ajax({
                url: "${pageContext.request.contextPath}/base/codeList.do",
                type: "post",
                dataType: "json",
                data: {
                    method: "batchCodeProcess",
                    batchList: codejson,
                    batchList2: detailCodejson


                },
                success: function (data, textStatus, jqXHR) {
                    if (data.errorCode < 0) {
                        alert(data.errorMsg);
                    } else {
                        alert("변경사항이 저장되었습니다");
                        location.href = "codemanageform";
                    }
                }
            });
        }
    </script>
</head>
<body>
    <input type="button" id="detailCodeplus" value="세부코드 추가">
    <input type="button" id="detailCodedel" value="세부코드 삭제">
    <input type="button" id="batch" value="일괄저장">
    <table>
        <colgroup>

        </colgroup>
        <tr>
            <td>
                <table id="codeGrid"></table>
            </td>
            <td>
                <table id="detailCodeGrid"></table>
            </td>
        </tr>
    </table>
</body>
</html>
