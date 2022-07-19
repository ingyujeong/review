package kr.co.seoulit.account.budget.formulation.to;

import kr.co.seoulit.account.sys.base.to.BaseBean;

public class BudgetStatusBean extends BaseBean{
private String accountInnerCode;
private String accountName;
private int annualBudgetRecord;//연간 예산 실적
private int annualBudget;
private int remainingBudget;
private double budgetExecRatio;//집행률
private int monthBudgetRecord;
private int monthBudget;
private int remainingMonthBudget;
private double monthBudgetExecRatio;//집행률
public String getAccountInnerCode() {
	return accountInnerCode;
}
public void setAccountInnerCode(String accountInnerCode) {
	this.accountInnerCode = accountInnerCode;
}
public String getAccountName() {
	return accountName;
}
public void setAccountName(String accountName) {
	this.accountName = accountName;
}
public int getAnnualBudgetRecord() {
	return annualBudgetRecord;
}
public void setAnnualBudgetRecord(int annualBudgetRecord) {
	this.annualBudgetRecord = annualBudgetRecord;
}
public int getAnnualBudget() {
	return annualBudget;
}
public void setAnnualBudget(int annualBudget) {
	this.annualBudget = annualBudget;
}
public int getRemainingBudget() {
	return remainingBudget;
}
public void setRemainingBudget(int remainingBudget) {
	this.remainingBudget = remainingBudget;
}
public double getBudgetExecRatio() {
	return budgetExecRatio;
}
public void setBudgetExecRatio(double budgetExecRatio) {
	this.budgetExecRatio = budgetExecRatio;
}
public int getMonthBudgetRecord() {
	return monthBudgetRecord;
}
public void setMonthBudgetRecord(int monthBudgetRecord) {
	this.monthBudgetRecord = monthBudgetRecord;
}
public int getMonthBudget() {
	return monthBudget;
}
public void setMonthBudget(int monthBudget) {
	this.monthBudget = monthBudget;
}
public int getRemainingMonthBudget() {
	return remainingMonthBudget;
}
public void setRemainingMonthBudget(int remainingMonthBudget) {
	this.remainingMonthBudget = remainingMonthBudget;
}
public double getMonthBudgetExecRatio() {
	return monthBudgetExecRatio;
}
public void setMonthBudgetExecRatio(double monthBudgetExecRatio) {
	this.monthBudgetExecRatio = monthBudgetExecRatio;
}


}
