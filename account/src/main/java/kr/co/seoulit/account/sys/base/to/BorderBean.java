package kr.co.seoulit.account.sys.base.to;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@AllArgsConstructor
@NoArgsConstructor
public class BorderBean {
	private int id;
	private String title;
	private String contents;
	private String wiritten_by;
	private String update_by;
	private String write_date;
	private String update_date_time;
	private int lookup;
	private int board_like;

}
