package kr.co.seoulit.account.sys.base.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.account.operate.system.to.AuthorityEmpBean;
import kr.co.seoulit.account.sys.base.exception.DeptCodeNotFoundException;
import kr.co.seoulit.account.sys.base.exception.IdNotFoundException;
import kr.co.seoulit.account.sys.base.exception.PwMissmatchException;
import kr.co.seoulit.account.sys.base.to.BorderBean;
import kr.co.seoulit.account.sys.base.to.CodeBean;
import kr.co.seoulit.account.sys.base.to.DetailCodeBean;
import kr.co.seoulit.account.sys.base.to.IreportBean;
import kr.co.seoulit.account.sys.base.to.MenuBean;
import kr.co.seoulit.account.operate.humanresource.to.EmployeeBean;

public interface BaseService {

    public EmployeeBean findLoginData(String empCode, String userPw) throws IdNotFoundException, PwMissmatchException, DeptCodeNotFoundException;

    public ArrayList<MenuBean> findUserMenuList(String deptCode);

    public ArrayList<DetailCodeBean> findDetailCodeList(HashMap<String, String> param);

    public ArrayList<CodeBean> findCodeList();

    public ArrayList<IreportBean> findIreportData(HttpServletRequest request, HttpServletResponse response, String slipNo);

    public void batchCodeProcess(ArrayList<CodeBean> codeList, ArrayList<DetailCodeBean> codeList2);

	public String findPeriodNo(String today);

	public void registerPeriodNo(String sdate, String edate);

	public void modifyEarlyStatements(String periodNo);
	
	public ArrayList<AuthorityEmpBean> findAuthority(String empCode);
	
	public void findIreportData3(HttpServletRequest request, HttpServletResponse response);
	
	public void findIreportData4(HttpServletRequest request, HttpServletResponse response);

	public void findIreportDataincome(HttpServletRequest request, HttpServletResponse response);
	
	public void findIreportDatafinance(HttpServletRequest request, HttpServletResponse response);
	
	public HashMap<String, String> findUrlMapper();

	public void findIreportTotalData(HttpServletRequest request, HttpServletResponse response);

	public List<BorderBean> getList();
}
