package kr.co.seoulit.account.settlement.trialbalance.to;

public class DetailTrialBalanceBean {
	private int lev;
	private String accountInnerCode;
	private int debitsSum;
	private int exceptCashDebits;
	private int cashDebits;
	private String accountName;
	private int creditsSumBalance;
	private int debitsSumBalance;
	private int cashCredits;
	private int exceptCashCredits;
	private int creditsSum;
	
	public int getCreditsSumBalance() {
		return creditsSumBalance;
	}
	public void setCreditsSumBalance(int creditsSumBalance) {
		this.creditsSumBalance = creditsSumBalance;
	}
	public int getDebitsSumBalance() {
		return debitsSumBalance;
	}
	public void setDebitsSumBalance(int debitsSumBalance) {
		this.debitsSumBalance = debitsSumBalance;
	}
	public int getLev() {
		return lev;
	}
	public void setLev(int lev) {
		this.lev = lev;
	}
	public String getAccountInnerCode() {
		return accountInnerCode;
	}
	public void setAccountInnerCode(String accountInnerCode) {
		this.accountInnerCode = accountInnerCode;
	}
	public int getDebitsSum() {
		return debitsSum;
	}
	public void setDebitsSum(int debitsSum) {
		this.debitsSum = debitsSum;
	}
	public int getExceptCashDebits() {
		return exceptCashDebits;
	}
	public void setExceptCashDebits(int exceptCashDebits) {
		this.exceptCashDebits = exceptCashDebits;
	}
	public int getCashDebits() {
		return cashDebits;
	}
	public void setCashDebits(int cashDebits) {
		this.cashDebits = cashDebits;
	}
	public String getAccountName() {
		return accountName;
	}
	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}
	public int getCashCredits() {
		return cashCredits;
	}
	public void setCashCredits(int cashCredits) {
		this.cashCredits = cashCredits;
	}
	public int getExceptCashCredits() {
		return exceptCashCredits;
	}
	public void setExceptCashCredits(int exceptCashCredits) {
		this.exceptCashCredits = exceptCashCredits;
	}
	public int getCreditsSum() {
		return creditsSum;
	}
	public void setCreditsSum(int creditsSum) {
		this.creditsSum = creditsSum;
	}

}
