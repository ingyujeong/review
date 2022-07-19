	function validate() {
		essential="필수로입력하세요";
		$("#valss").validate({
			//확인
			  submitHandler: function() {
	                var f = confirm("회사등록을 완료하시겠습니까?");
	                if(f){
	                	workplaceAdd();
	                } else {
	                    return false;
	                }
	            },
			//규칙
			rules : {
				workplaceCode : {
					required : true,
					digits : true
				},
				companyCode : {
					required:true,
					minlength : 6,
					maxlength : 6
				},
				businessLicense:{
					required : true,
					minlength: 12
				},
				corporationLicence : {
					required : true,
					minlength: 16
				},
				workplaceName : {
					required : true
				},
				workplaceCeoName : {
					required : true
				},
				workplaceTelNumber : {
					required : true,
					rangelength : [9,13]
				},
				workplaceFaxNumber : {
					required : true,
					rangelength : [9,13]
				},
				workplaceBasicAddress:{
					required : true
				},
				businessConditions : {
					required : true
				},
				businessItems : {
					required : true
				}
			}, // 에러 메시지
			messages : {
				workplaceCode : {
					required : essential
				},
				companyCode : {
					required : essential,
					minlength : "6자리여야 합니다 예)COM-01",
					maxlength : "6자리여야 합니다 예)COM-01",
				},
				businessLicense : {
					required : essential,
					minlength : "-포함10자리입력   예)012-23-45678"
					
				},
				corporationLicence : {
					required : essential,
					minlength : "-포함13자리입력   예)0123-45-567890-1"
				},
				workplaceName : {
					required : essential
				},
				workplaceCeoName : {
					required : essential
				},
				workplaceTelNumber : {
					required : essential,
					rangelength : "-포함 번호를 입력해주세요"
				},
				workplaceFaxNumber : {
					required : essential,
					rangelength : "-포함 번호를 입력해주세요"
				},
				workplaceBasicAddress:{
					required : essential
				},
				businessConditions : {
					required : essential
				},
				businessItems : {
					required : essential
				}, 
				
			
			}
		});
	}