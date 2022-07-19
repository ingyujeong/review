package kr.co.seoulit.account.budget.formulation.service;

import java.util.ArrayList;
import java.util.Vector;

import kr.co.seoulit.account.budget.formulation.to.BudgetBean;
import kr.co.seoulit.account.budget.formulation.to.BudgetStatusBean;

public interface FormulationService {
	
	public BudgetBean findBudget(BudgetBean bean);
	
	public void findBudgetList(BudgetBean bean);
	
	public ArrayList<BudgetBean> findBudgetAppl(BudgetBean bean);
	
	public Vector<BudgetStatusBean> findBudgetStatus(BudgetBean bean);
	
}
