package kr.co.seoulit.account.settlement.trialbalance.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.seoulit.account.settlement.trialbalance.service.TrialBalanceService;
import kr.co.seoulit.account.settlement.trialbalance.to.DetailTrialBalanceBean;



@RestController
@RequestMapping("/settlement")
public class DetailTrialBalanceController {
	@Autowired
    private TrialBalanceService trialBalanceService;
    
	 @RequestMapping("/detailtrialbalance")
    public ArrayList<DetailTrialBalanceBean> handleRequestInternal(@RequestParam String fromDate, @RequestParam String toDate) {
     
        ArrayList<DetailTrialBalanceBean> detailTrialBalanceList = trialBalanceService.findDetailTrialBalance(fromDate, toDate);

       
        return detailTrialBalanceList;
    }

}
