package kr.co.seoulit.account.budget.formulation.mapper;

import java.util.ArrayList;
import java.util.Vector;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.account.budget.formulation.to.BudgetBean;
import kr.co.seoulit.account.budget.formulation.to.BudgetStatusBean;

@Mapper
public interface FormulationMapper {
	
	public BudgetBean selectBudget(BudgetBean bean);
	
	public void selectBudgetList(BudgetBean bean);
	
	public ArrayList<BudgetBean>  selectBudgetAppl(BudgetBean bean);
	
	public Vector<BudgetStatusBean> selectBudgetStatus(BudgetBean bean);
}
