package kr.co.seoulit.account.posting.ledger.to;

public class CashJournalBean {
	private String monthReportingDate;
	private String reportingDate;
	private String expenseReport;
	private String customerCode;
	private String customerName;
	private int deposit;
	private int withdrawal;
	private String balance;
	
	public String getMonthReportingDate() {
		return monthReportingDate;
	}
	public void setMonthReportingDate(String monthReportingDate) {
		this.monthReportingDate = monthReportingDate;
	}
	public String getReportingDate() {
		return reportingDate;
	}
	public void setReportingDate(String reportingDate) {
		this.reportingDate = reportingDate;
	}
	public String getExpenseReport() {
		return expenseReport;
	}
	public void setExpenseReport(String expenseReport) {
		this.expenseReport = expenseReport;
	}
	public String getCustomerCode() {
		return customerCode;
	}
	public void setCustomerCode(String customerCode) {
		this.customerCode = customerCode;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public int getDeposit() {
		return deposit;
	}
	public void setDeposit(int deposit) {
		this.deposit = deposit;
	}
	public int getWithdrawal() {
		return withdrawal;
	}
	public void setWithdrawal(int withdrawal) {
		this.withdrawal = withdrawal;
	}
	public String getBalance() {
		return balance;
	}
	public void setBalance(String balance) {
		this.balance = balance;
	}
	
	
}