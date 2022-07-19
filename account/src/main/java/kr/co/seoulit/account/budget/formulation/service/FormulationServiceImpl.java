package kr.co.seoulit.account.budget.formulation.service;

import java.util.ArrayList;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.seoulit.account.budget.formulation.mapper.FormulationMapper;
import kr.co.seoulit.account.budget.formulation.to.BudgetBean;
import kr.co.seoulit.account.budget.formulation.to.BudgetStatusBean;

@Service
@Transactional
public class FormulationServiceImpl implements FormulationService {

	@Autowired
	private FormulationMapper formulationDAO;

	@Override
	public BudgetBean findBudget(BudgetBean bean) {
		// TODO Auto-generated method stub

			bean = formulationDAO.selectBudget(bean);

		return bean;
	}

	@Override
	public void findBudgetList(BudgetBean bean) {
		// TODO Auto-generated method stub

			formulationDAO.selectBudgetList(bean);

	}

	@Override
	public Vector<BudgetStatusBean> findBudgetStatus(BudgetBean bean) {
		// TODO Auto-generated method stub

		Vector<BudgetStatusBean> beans = null;
		beans = formulationDAO.selectBudgetStatus(bean);
		
		return beans;
	}

	@Override
	public ArrayList<BudgetBean> findBudgetAppl(BudgetBean bean) {
		// TODO Auto-generated method stub

			return formulationDAO.selectBudgetAppl(bean);

	}
}
