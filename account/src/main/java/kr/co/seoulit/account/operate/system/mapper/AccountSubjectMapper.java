package kr.co.seoulit.account.operate.system.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.account.operate.system.to.AccountBean;
import kr.co.seoulit.account.operate.system.to.AccountControlBean;
import kr.co.seoulit.account.operate.system.to.PeriodBean;

@Mapper
public interface AccountSubjectMapper {

    public AccountBean selectAccount(String accountCode);

    public ArrayList<AccountBean> selectDetailAccountList(String code);

    public ArrayList<AccountBean> selectParentAccountList();

    public void updateAccount(AccountBean accountBean);

    public ArrayList<AccountBean> selectAccountListByName(String accountName);

    public ArrayList<AccountControlBean> selectAccountControlList(String accountCode);
    
    public ArrayList<AccountBean> selectDetailBudgetList(String code);
    
    public ArrayList<AccountBean> selectParentBudgetList();
    
    public ArrayList<PeriodBean> selectAccountPeriodList();
}
