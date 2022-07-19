package kr.co.seoulit.account.settlement.financialstatements.controller;

import java.io.IOException;
import java.io.PrintWriter;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import kr.co.seoulit.account.sys.common.exception.DataAccessException;
import lombok.extern.log4j.Log4j2;
import kr.co.seoulit.account.settlement.financialstatements.service.FinancialStatementsService;
import kr.co.seoulit.account.settlement.financialstatements.service.FinancialStatementsServiceImpl;
import net.sf.json.JSONObject;


@Log4j2
@RestController
@RequestMapping("/settlement")
public class IncomeStatementController  {

	@Autowired
  private FinancialStatementsService financialStatementsService;
    
 
	@GetMapping("/incomestatement")
    public HashMap<String, Object> handleRequestInternal(@RequestParam String accountPeriodNo,
		     								             @RequestParam String callResult) {

		HashMap<String, Object> params = new HashMap<>();
		params.put("accountPeriodNo",accountPeriodNo);
		params.put("callResult",callResult);
		
		financialStatementsService.findIncomeStatement(params);

        return params;
    }

}


