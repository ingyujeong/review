package kr.co.seoulit.account.posting.business.to;

public class AccountingSettlementStatusBean {
	private int accountPeriodNo;
	private String totalTrialBalance;
	private String incomeStatement;
	private String financialPosition;
	
	public int getAccountPeriodNo() {
		return accountPeriodNo;
	}
	public void setAccountPeriodNo(int accountPeriodNo) {
		this.accountPeriodNo = accountPeriodNo;
	}
	public String getTotalTrialBalance() {
		return totalTrialBalance;
	}
	public void setTotalTrialBalance(String totalTrialBalance) {
		this.totalTrialBalance = totalTrialBalance;
	}
	public String getIncomeStatement() {
		return incomeStatement;
	}
	public void setIncomeStatement(String incomeStatement) {
		this.incomeStatement = incomeStatement;
	}
	public String getFinancialPosition() {
		return financialPosition;
	}
	public void setFinancialPosition(String financialPosition) {
		this.financialPosition = financialPosition;
	}
	
	
}
