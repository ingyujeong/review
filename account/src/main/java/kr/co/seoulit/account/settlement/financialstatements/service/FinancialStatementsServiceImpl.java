package kr.co.seoulit.account.settlement.financialstatements.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.seoulit.account.settlement.financialstatements.mapper.FinancialPositionMapper;
import kr.co.seoulit.account.settlement.financialstatements.mapper.IncomeStatementMapper;

@Service
public class FinancialStatementsServiceImpl implements FinancialStatementsService{
    
	@Autowired
    private FinancialPositionMapper financialPositionDAO;
	@Autowired
    private IncomeStatementMapper incomeStatementDAO;

    @Override
    public HashMap<String, Object> findFinancialPosition(HashMap<String,Object> params) {
    	HashMap<String, Object>  financialPosition = financialPositionDAO.selectcallFinancialPosition(params);

        return financialPosition;
    }

    
    @Override
    public HashMap<String, Object> findIncomeStatement(HashMap<String, Object> param) {

        	HashMap<String, Object> incomeledgerList = null;
        	incomeledgerList = incomeStatementDAO.selectcallIncomeStatement(param);
        	System.out.println(incomeledgerList+"@@@@@@@@@@@@@@@@@@@@@@");
            
        return incomeledgerList;
    }
}
