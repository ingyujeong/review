package kr.co.seoulit.account.sys.base.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.seoulit.account.sys.base.service.BaseService;
import kr.co.seoulit.account.sys.base.to.BorderBean;
import lombok.extern.slf4j.Slf4j;

@Slf4j// log info 하는거 디버깅용도
@Controller
@RequestMapping("/base") 
public class BoardListController {
	@Autowired
	private BaseService baseservice;
	@GetMapping("/boardlist")  
	public String showList(Model amodel) {
		List<BorderBean> list=baseservice.getList();
		amodel.addAttribute("boardlist",list);
		return "base/boardlist";
	}

}
