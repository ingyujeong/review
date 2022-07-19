package kr.co.seoulit.account.settlement.trialbalance.to;

public class ImTotalTrialBalanceBean {
private String accountName;
private int leftBalance;
private int sumLeftDebtorPrice;
private int rightBalance;
private int sumRightCreditsPrice;

public String getAccountName() {
	return accountName;
}
public void setAccountName(String accountName) {
	this.accountName = accountName;
}
public int getLeftBalance() {
	return leftBalance;
}
public void setLeftBalance(int leftBalance) {
	this.leftBalance = leftBalance;
}
public int getSumLeftDebtorPrice() {
	return sumLeftDebtorPrice;
}
public void setSumLeftDebtorPrice(int sumLeftDebtorPrice) {
	this.sumLeftDebtorPrice = sumLeftDebtorPrice;
}
public int getRightBalance() {
	return rightBalance;
}
public void setRightBalance(int rightBalance) {
	this.rightBalance = rightBalance;
}
public int getSumRightCreditsPrice() {
	return sumRightCreditsPrice;
}
public void setSumRightCreditsPrice(int sumRightCreditsPrice) {
	this.sumRightCreditsPrice = sumRightCreditsPrice;
}
}
