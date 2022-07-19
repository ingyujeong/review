package kr.co.seoulit.account.budget.formulation.controller;

import java.util.ArrayList;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.seoulit.account.sys.common.util.BeanCreator;

import kr.co.seoulit.account.budget.formulation.service.FormulationService;

import kr.co.seoulit.account.budget.formulation.to.BudgetBean;
import kr.co.seoulit.account.budget.formulation.to.BudgetStatusBean;

import net.sf.json.JSONObject;

@RestController
@RequestMapping("/budget")
public class FormulationController{
	
	@Autowired
	private FormulationService formulationService;
	
	BeanCreator beanCreator  = BeanCreator.getInstance();

    @GetMapping("/budget")
	 public BudgetBean findBudget(@RequestParam String budgetObj) {

		 JSONObject budgetJsonObj = JSONObject.fromObject(budgetObj); //예산
		 BudgetBean budgetBean =beanCreator.create(budgetJsonObj, BudgetBean.class);
		
		 
   
	        return formulationService.findBudget(budgetBean);
	 }

    @GetMapping("/budgetlist")
	 public void findBudgetList(@RequestParam String budgetObj) {
	      		 
		 
		 JSONObject budgetJsonObj = JSONObject.fromObject(budgetObj); //예산
		 BudgetBean budgetBean =beanCreator.create(budgetJsonObj, BudgetBean.class);
		 formulationService.findBudgetList(budgetBean);
   
	 }
    @GetMapping("/budgetstatus")
	 public Vector<BudgetStatusBean> findBudgetStatus(@RequestParam String budgetObj) {
	       	 
    	JSONObject budgetJsonObj = JSONObject.fromObject(budgetObj); //예산
		 BudgetBean budgetBean =beanCreator.create(budgetJsonObj, BudgetBean.class);
		Vector<BudgetStatusBean> beans=formulationService.findBudgetStatus(budgetBean);
		
	        return beans;
	 }
    @RequestMapping(value = "/budgetappl", method = RequestMethod.POST)
	 public ArrayList<BudgetBean> findBudgetAppl(@RequestParam String budgetObj) {
		   
		 
		 JSONObject budgetJsonObj = JSONObject.fromObject(budgetObj); //예산
		 BudgetBean budgetBean =beanCreator.create(budgetJsonObj, BudgetBean.class);
	
		  return null;
	 }
}
