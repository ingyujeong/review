package kr.co.seoulit.account.settlement.financialstatements.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.seoulit.account.settlement.financialstatements.service.FinancialStatementsService;

@RestController
@RequestMapping("/settlement")
public class FinancialPositionController {

	 @Autowired
    private FinancialStatementsService financialStatementsService;
	
  
	 @GetMapping("/financialposition")
    public HashMap<String, Object> handleRequestInternal(@RequestParam String accountPeriodNo, 
    								          			 @RequestParam String callResult) {
      
    	HashMap<String, Object> params = new HashMap<>();
    	params.put("accountPeriodNo",accountPeriodNo);
    	params.put("callResult",callResult);
    	
    	financialStatementsService.findFinancialPosition(params);

       
        return params;
    }

}