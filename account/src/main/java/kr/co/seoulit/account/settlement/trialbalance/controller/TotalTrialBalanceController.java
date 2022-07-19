package kr.co.seoulit.account.settlement.trialbalance.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.seoulit.account.settlement.trialbalance.service.TrialBalanceService;

@RestController
@RequestMapping("/settlement")
public class TotalTrialBalanceController {

	@Autowired
	private TrialBalanceService trialBalanceService;


	@PostMapping("/totaltrialbalance")
	public HashMap<String, Object> finddoClosing(@RequestParam String accountPeriodNo,
			                                     @RequestParam String callResult) {

		HashMap<String,Object> params = new HashMap<>();
		params.put("accountPeriodNo",accountPeriodNo);
		params.put("callResult",callResult);
		

             HashMap<String, Object> closingResult = trialBalanceService.findEarlyStatements(params);

           return closingResult;
	}

	  @GetMapping("/totaltrialbalance/{accountPeriodNo}")
	public HashMap<String,Object> findTotalTrialBalance(@PathVariable String accountPeriodNo,
														 @RequestParam String callResult) {
		 
		  
		HashMap<String,Object> params = new HashMap<>();
		params.put("accountPeriodNo",accountPeriodNo);
		params.put("callResult",callResult);

		trialBalanceService.findTotalTrialBalance(params);
         
        
          
        return params;

	}
	@PostMapping("/totaltrialbalancecancle")
	public void findcancelClosing(@RequestParam String accountPeriodNo,
										  @RequestParam String callResult) {

		trialBalanceService.findchangeAccountingSettlement(accountPeriodNo, callResult);
	}

}
