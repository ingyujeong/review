package kr.co.seoulit.account.settlement.financialstatements.to;

import kr.co.seoulit.account.sys.base.to.BaseBean;

public class FinancialPositionBean extends BaseBean {
    private int lev;
    private String category;
    private String accountName;
    private String accountCode;
    private int balanceDetail;
    private int balanceSummary;
    private int preBalanceDetail;
    private int preBalanceSummary;
    private int isThisYear;

    public int getLev() {
        return lev;
    }

    public void setLev(int lev) {
        this.lev = lev;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public String getAccountCode() {
        return accountCode;
    }

    public void setAccountCode(String accountCode) {
        this.accountCode = accountCode;
    }

    public int getBalanceDetail() {
        return balanceDetail;
    }

    public void setBalanceDetail(int balanceDetail) {
        this.balanceDetail = balanceDetail;
    }

    public int getBalanceSummary() {
        return balanceSummary;
    }

    public void setBalanceSummary(int balanceSummary) {
        this.balanceSummary = balanceSummary;
    }

    public int getPreBalanceDetail() {
        return preBalanceDetail;
    }

    public void setPreBalanceDetail(int preBalanceDetail) {
        this.preBalanceDetail = preBalanceDetail;
    }

    public int getPreBalanceSummary() {
        return preBalanceSummary;
    }

    public void setPreBalanceSummary(int preBalanceSummary) {
        this.preBalanceSummary = preBalanceSummary;
    }

    public int getIsThisYear() {
        return isThisYear;
    }

    public void setIsThisYear(int isThisYear) {
        this.isThisYear = isThisYear;
    }
}
