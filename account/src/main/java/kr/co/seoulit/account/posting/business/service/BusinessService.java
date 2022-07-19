package kr.co.seoulit.account.posting.business.service;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.account.posting.business.to.JournalBean;
import kr.co.seoulit.account.posting.business.to.JournalDetailBean;
import kr.co.seoulit.account.posting.business.to.SlipBean;

public interface BusinessService {
	
    public ArrayList<JournalDetailBean> findJournalDetailList(String journalNo);

    public String modifyJournalDetail(JournalDetailBean journalDetailBean);

    public ArrayList<JournalBean> findSingleJournalList(String slipNo);

    public void removeJournal(String journalNo);
    
    void modifyJournal(String slipNo, ArrayList<JournalBean> journalBeanList);

    public ArrayList<SlipBean> findRangedSlipList(HashMap<String, Object> params);

    public ArrayList<SlipBean> findDisApprovalSlipList();

    public void registerSlip(SlipBean slipBean, ArrayList<JournalBean> journalBeans);

    public void removeSlip(String slipNo);

    public String modifySlip(SlipBean slipBean, ArrayList<JournalBean> journalBeans);

    public void modifyapproveSlip(ArrayList<SlipBean> slipBeans);
    
    public ArrayList<SlipBean> findSlipDataList(String slipDate);

    public HashMap<String, Object> findAccountingSettlementStatus(HashMap<String, Object> params);

    public ArrayList<SlipBean> findSlip(String slipNo);

	ArrayList<JournalBean> findRangedJournalList(String fromDate, String toDate);
}

