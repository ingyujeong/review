package kr.co.seoulit.account.posting.business.to;

import kr.co.seoulit.account.sys.base.to.BaseBean;

public class JournalDetailBean extends BaseBean {
    private String journalDetailNo;
    private String accountControlName;
    private String accountControlType;
    private String journalDescription;
    private String accountControlDescription;
    private String journalNo;
    private String accountControlCode;

    public String getAccountControlCode() {
		return accountControlCode;
	}

	public void setAccountControlCode(String accountControlCode) {
		this.accountControlCode = accountControlCode;
	}

	public String getJournalDetailNo() {
        return journalDetailNo;
    }

    public void setJournalDetailNo(String journalDetailNo) {
        this.journalDetailNo = journalDetailNo;
    }

    public String getAccountControlName() {
        return accountControlName;
    }

    public void setAccountControlName(String accountControlName) {
        this.accountControlName = accountControlName;
    }

    public String getAccountControlType() {
        return accountControlType;
    }

    public void setAccountControlType(String accountControlType) {
        this.accountControlType = accountControlType;
    }

    public String getJournalDescription() {
        return journalDescription;
    }

    public void setJournalDescription(String journalDescription) {
        this.journalDescription = journalDescription;
    }

    public String getAccountControlDescription() {
        return accountControlDescription;
    }

    public void setAccountControlDescription(String accountControlDescription) {
        this.accountControlDescription = accountControlDescription;
    }

	public void setJournalNo(String journalNo) {
		this.journalNo = journalNo;
	}
	
	public String getJournalNo() {
        return journalNo;
    }
	
}
