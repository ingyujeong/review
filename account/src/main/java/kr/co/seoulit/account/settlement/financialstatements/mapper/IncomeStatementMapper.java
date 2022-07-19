package kr.co.seoulit.account.settlement.financialstatements.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IncomeStatementMapper {
	public HashMap<String, Object> selectcallIncomeStatement(HashMap<String, Object> param);
}
