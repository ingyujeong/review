package kr.co.seoulit.account.sys.base.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
//import org.springframework.web.servlet.ModelAndView;
//import org.springframework.web.servlet.mvc.AbstractController;

import kr.co.seoulit.account.operate.humanresource.service.HumanResourceService;
import kr.co.seoulit.account.operate.humanresource.to.EmployeeBean;


@RestController
public class FileUploadController{
	
	@Autowired
	private HumanResourceService humanResourceService;
	
	
	/*
	 * @PostMapping("/base/profileimage")
	 * 
	 * @ResponseStatus(HttpStatus.CREATED) public List<String> upload(
	 * 
	 * @RequestPart List<MultipartFile> files) //@RequestPart(value="file", required
	 * = false) MultipartFile file, //@RequestPart(value="employInfo", required =
	 * false) EmployeeBean employee) throws Exception { List<String> list = new
	 * ArrayList<>(); for (MultipartFile file : files) { String originalfileName =
	 * file.getOriginalFilename(); File dest = new File("C:/Temp/",
	 * originalfileName); file.transferTo(dest);
	 * 
	 * String s3fileurl = awsS3Service.s3FileUpload(file);
	 * humanResourceService.modifyImage(s3fileurl); // TODO }
	 * 
	 * return list; }
	 */
	
	/*
	public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
		{
			JSONObject json = new JSONObject();
			String savePath = "C:\\temp";
			String fileFullPath;
			String fileName;
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			try {
				if(isMultipart) {
		            DiskFileItemFactory factory = new DiskFileItemFactory();		 
		            // 파일 업로드 핸들러 생성
		            ServletFileUpload upload = new ServletFileUpload(factory);		 
		            // 한글 인코딩
		            upload.setHeaderEncoding("UTF-8");
		 
		            // request parsing
		            List<FileItem> items = upload.parseRequest(request);
		            if(items.size()==0) {
		            	System.out.println("데이터가 없습니다");
		            	return null;
		            }
		            	
		            Iterator<FileItem> iter = items.iterator();
		            
		            while (iter.hasNext()) {
		                FileItem item = iter.next();		 
		                // 한글 인코딩
		                item.getString("UTF-8");		 
		                if (item.isFormField()) {
		                    // file 형식이 아닐 때
		                    String name = item.getFieldName(); // 필드 이름
		                    String value = new String((item.getString()).getBytes("8859_1"),"utf-8"); // 필드 값, 한글 인코딩
		                    System.out.println("데이터 이름 : " + name + ", 데이터 내용 :" + value);
		                } else {
		                    // file 형식일 때
		                    fileName = new File(item.getName()).getName();
		                    fileFullPath = savePath + "/"  + fileName;
		                    File storeFile = new File(savePath + "/"  + fileName);
		                    // saves the file on disk
		                    item.write(storeFile);
		    				humanResourceService.modifyImage(fileFullPath); // db 연동
		    				json.put("FileAddress", fileFullPath);
		    				json.put("errorCode", 1);
		    				json.put("errorMsg", "데이터 저장 성공");
		                }
		            }
		        }
			} catch (IOException | DataAccessException e) {
				System.out.println("FileUploadController 에러 발생");
				// logger.fatal(e.getMessage());
				json.put("errorCode", -1);
				json.put("errorMsg", e.getMessage());
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try (PrintWriter out = response.getWriter()) {
					out.println(json);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			return null;			
		}
	*/
}
