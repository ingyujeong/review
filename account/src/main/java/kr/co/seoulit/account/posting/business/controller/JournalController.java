package kr.co.seoulit.account.posting.business.controller;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.account.posting.business.service.BusinessService;
import kr.co.seoulit.account.posting.business.to.JournalBean;
import kr.co.seoulit.account.sys.common.util.BeanCreator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@RequestMapping("/posting")
public class JournalController {

	@Autowired
	private BusinessService businessService;
	
	@GetMapping("/singlejournallist")
	public ArrayList<JournalBean> findSingleJournalList(@RequestParam String slipNo){
	     
        ArrayList<JournalBean> journalList = businessService.findSingleJournalList(slipNo);

        return journalList;
	}
	
	@GetMapping("/rangedjournallist")
    public ArrayList<JournalBean> findRangedJournalList(@RequestParam String fromDate,
			  								  	        @RequestParam String toDate) {
            ArrayList<JournalBean> journalList = businessService.findRangedJournalList(fromDate,toDate);
 
        return journalList;
    }

    @GetMapping("/journalremoval")
    public void removeJournal(@RequestParam String journalNo) {
       
      
    		businessService.removeJournal(journalNo);

    }
    @GetMapping("modifyJournal")
	public void modifyJournal(@RequestParam String slipNo,
							  @RequestParam JSONArray journalObj) {

        JSONArray journalObjs = JSONArray.fromObject(journalObj);

        ArrayList<JournalBean> journalBeanList = new ArrayList<>();

        for (Object journalObjt : journalObjs) {
            JournalBean journalBean = BeanCreator.getInstance().create(JSONObject.fromObject(journalObjt), JournalBean.class);
            journalBean.setStatus(((JSONObject)journalObjt).getString("status"));
            journalBeanList.add(journalBean);
        }
			businessService.modifyJournal(slipNo, journalBeanList);

	}

}
