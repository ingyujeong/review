package kr.co.seoulit.account.posting.business.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.account.posting.business.to.JournalBean;
import kr.co.seoulit.account.posting.business.to.JournalDetailBean;

@Mapper
public interface JournalMapper {

    public ArrayList<JournalBean> selectJournalList(String slipNo);

    public void deleteJournal(String journalNo);
    
    public void deleteJournalAll(String slipNo);

    public boolean updateJournal(JournalBean journalBean);
    
    ArrayList<JournalDetailBean> selectJournalDetailList(String journalNo);
    
    String selectJournalDetailDescriptionName(String journalDetailNo);

    public void deleteJournalDetail(String journalNo);
    
    public void deleteJournalDetailByJournalNo(String journalNo);

    public void updateJournalDetail(JournalDetailBean journalDetailBean);

    public void insertJournalDetailList(JournalDetailBean journalDetailBean);

	public ArrayList<JournalBean> selectRangedJournalList(HashMap<String, String> map);

	public void insertJournal(JournalBean journalBean);

	public String selectJournalName(String slipNo);
}
