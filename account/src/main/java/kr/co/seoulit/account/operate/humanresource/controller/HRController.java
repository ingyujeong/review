package kr.co.seoulit.account.operate.humanresource.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import kr.co.seoulit.account.operate.humanresource.service.HumanResourceService;

import kr.co.seoulit.account.operate.humanresource.to.DepartmentBean;
import kr.co.seoulit.account.operate.humanresource.to.EmployeeBean;

import net.sf.json.JSONObject;

@RestController
@RequestMapping("/operate")
public class HRController {

    @Autowired
    private HumanResourceService humanResourceService;

    ModelAndView mav;
    ModelMap map = new ModelMap();
    
    @GetMapping("/employeelist")
	public ArrayList<EmployeeBean> findEmployeeList(@RequestParam String deptCode) {

            ArrayList<EmployeeBean> empList = humanResourceService.findEmployeeList(deptCode);
            return empList;
    }
    
    @GetMapping("/employeeListall")
    public ArrayList<EmployeeBean> findEmployeeListAll() {

            ArrayList<EmployeeBean> empList = humanResourceService.findEmployeeList();
            
            return empList;
    }

    @GetMapping("/employee")
    public EmployeeBean findEmployee(@RequestParam String empCode) {

            EmployeeBean employeeBean = humanResourceService.findEmployee(empCode);

            return employeeBean;
    }

    @GetMapping("/batchempinfo")
    public void batchEmpInfo(@RequestParam String employeeInfo,@RequestParam String image) {
      
            JSONObject jsonObject = JSONObject.fromObject(employeeInfo);
         
            EmployeeBean employeeBean = (EmployeeBean) JSONObject.toBean(jsonObject, EmployeeBean.class);
            employeeBean.setImage(image);
            humanResourceService.batchEmployeeInfo(employeeBean);
           
   
    }

    @GetMapping("/emptyempbean")
    public ModelAndView EmptyEmpBean(HttpServletRequest request, HttpServletResponse response) {
       
        return null;
    }

    @GetMapping("/batchemp")
    public void batchEmp(@RequestParam String JoinEmployee) {
     
            JSONObject jsonObject = JSONObject.fromObject(JoinEmployee);
            
            EmployeeBean employeeBean = (EmployeeBean) JSONObject.toBean(jsonObject, EmployeeBean.class);

            humanResourceService.registerEmployee(employeeBean);
          
    }
    
    @GetMapping("/employeeremoval")
    public void removeEmployee(@RequestParam String empCode) {
    	
           
            EmployeeBean employeeBean = new EmployeeBean();
            employeeBean.setEmpCode(empCode);
            humanResourceService.removeEmployee(employeeBean);
          
     
    }
    @GetMapping("/deptlist")
    public ArrayList<DepartmentBean> findDeptList() {
       
            ArrayList<DepartmentBean> deptList = humanResourceService.findDeptList();
         
        return deptList;
    }
    
    @GetMapping("/detaildeptlist")
    public ArrayList<DepartmentBean> findDetailDeptList(@RequestParam String workplaceCode) {

            ArrayList<DepartmentBean> detailDeptList = humanResourceService.findDetailDeptList(workplaceCode);
        
        return detailDeptList;
    }

    public ArrayList<DepartmentBean> findDeptList2() {
        
   	 ArrayList<DepartmentBean> deptList = humanResourceService.findDeptList2();
        
       return deptList;
   }
}
