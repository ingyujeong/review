<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>주소검색</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script src="${pageContext.request.contextPath}/scripts/jqGrid/js/jquery-1.11.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/jqGrid/js/i18n/grid.locale-en.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/jqGrid/css/ui.jqgrid.css"/>
    <script src="${pageContext.request.contextPath}/scripts/jqGrid/js/jquery.jqGrid.min.js"></script>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/scripts/jqueryUI/jquery-ui.min.css"/>
    <script src="${pageContext.request.contextPath}/scripts/jqueryUI/jquery-ui.min.js"></script>
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script>
        function openZipSearch() {
            new daum.Postcode({
                oncomplete: function (data) {
                    $('[name=zip]').val(data.zonecode); // 우편번호 (5자리)
                    $('[name=addr1]').val(data.address); //기본주소
                    $('[name=addr2]').val(data.buildingName); //상세주소
                }
            }).open();
        }
    </script>
</head>
<body>
    우편번호 : <input type="text" name="zip" style="width:80px; height:30px;"/>
    <button type="button" style="width:60px; height:32px;" onclick="openZipSearch()">검색</button>
    <br>
    주소 : <input type="text" name="addr1" style="width:300px; height:30px;" readonly/><br>
    상세 : <input type="text" name="addr2" style="width:300px; height:30px;"/>
</body>
</html>
