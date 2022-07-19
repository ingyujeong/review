package kr.co.seoulit.account.posting.business.to;

import kr.co.seoulit.account.sys.base.to.BaseBean;

public class SlipBean extends BaseBean {
    private String id;
    private String slipNo;
    private String accountPeriodNo;
    private String deptCode;
    private String deptName;
    private String slipType;
    private String expenseReport;
    private String authorizationStatus;
    private String reportingEmpCode;
    private String reportingEmpName;
    private String reportingDate;
    private String approvalEmpCode;
    private String approvalDate;
    private String slipStatus;
    private String balanceDivision;
    private String positionCode;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getReportingEmpName() {
        return reportingEmpName;
    }

    public void setReportingEmpName(String reportingEmpName) {
        this.reportingEmpName = reportingEmpName;
    }

    public String getAccountPeriodNo() {
        return accountPeriodNo;
    }

    public void setAccountPeriodNo(String accountPeriodNo) {
        this.accountPeriodNo = accountPeriodNo;
    }

    public String getDeptCode() {
        return deptCode;
    }

    public void setDeptCode(String deptCode) {
        this.deptCode = deptCode;
    }

    public String getSlipType() {
        return slipType;
    }

    public void setSlipType(String slipType) {
        this.slipType = slipType;
    }

    public String getExpenseReport() {
        return expenseReport;
    }

    public void setExpenseReport(String expenseReport) {
        this.expenseReport = expenseReport;
    }

    public String getAuthorizationStatus() {
        return authorizationStatus;
    }

    public void setAuthorizationStatus(String authorizationStatus) {
        this.authorizationStatus = authorizationStatus;
    }

    public String getReportingEmpCode() {
        return reportingEmpCode;
    }

    public void setReportingEmpCode(String reportingEmpCode) {
        this.reportingEmpCode = reportingEmpCode;
    }

    public String getReportingDate() {
        return reportingDate;
    }

    public void setReportingDate(String reportingDate) {
        this.reportingDate = reportingDate;
    }

    public String getApprovalEmpCode() {
        return approvalEmpCode;
    }

    public void setApprovalEmpCode(String approvalEmpCode) {
        this.approvalEmpCode = approvalEmpCode;
    }

    public String getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(String approvalDate) {
        this.approvalDate = approvalDate;
    }

    public String getSlipStatus() {
        return slipStatus;
    }

    public void setSlipStatus(String slipStatus) {
        this.slipStatus = slipStatus;
    }

    public String getSlipNo() {
        return slipNo;
    }

    public void setSlipNo(String slipNo) {
        this.slipNo = slipNo;
    }

    public String getBalanceDivision() {
        return balanceDivision;
    }

    public void setBalanceDivision(String balanceDivision) {
        this.balanceDivision = balanceDivision;
    }

    public String getPositionCode() {
        return positionCode;
    }

    public void setPositionCode(String positionCode) {
        this.positionCode = positionCode;
    }


}
