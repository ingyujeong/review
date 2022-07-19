package kr.co.seoulit.account.settlement.trialbalance.to;

public class TotalTrialBalanceBean {

    private int lev;
    private String accountName;
    private String accountInnerCode;
    private int debitsSumBalance;
    private int debitsSum;
    private int creditsSum;
    private int creditsSumBalance;

    public int getLev() {
        return lev;
    }

    public void setLev(int lev) {
        this.lev = lev;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public String getAccountInnerCode() {
        return accountInnerCode;
    }

    public void setAccountInnerCode(String accountInnerCode) {
        this.accountInnerCode = accountInnerCode;
    }

    public int getDebitsSumBalance() {
        return debitsSumBalance;
    }

    public void setDebitsSumBalance(int debitsSumBalance) {
        this.debitsSumBalance = debitsSumBalance;
    }

    public int getDebitsSum() {
        return debitsSum;
    }

    public void setDebitsSum(int debitsSum) {
        this.debitsSum = debitsSum;
    }

    public int getCreditsSum() {
        return creditsSum;
    }

    public void setCreditsSum(int creditsSum) {
        this.creditsSum = creditsSum;
    }

    public int getCreditsSumBalance() {
        return creditsSumBalance;
    }

    public void setCreditsSumBalance(int creditsSumBalance) {
        this.creditsSumBalance = creditsSumBalance;
    }
}
