---
title: Spring Boot & poi 导出Excel表格、Txt到浏览器下载
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- poi
- Excel
---
# Spring Boot & poi 导出Excel表格、Txt到浏览器下载
---
[toc]

+ 注：若只需要导出Txt则不需要Excel的pom包和工具类

---
## 一. pom依赖
```
<!-- ****************************************** poi导出excel ************************************ -->
<dependency>
	<groupId>org.apache.poi</groupId>
	<artifactId>poi</artifactId>
	<version>3.17</version>
</dependency>
<dependency>
	<groupId>org.apache.poi</groupId>
	<artifactId>poi-ooxml</artifactId>
	<version>3.17</version>
</dependency>
<dependency>
	<groupId>org.apache.poi</groupId>
	<artifactId>poi-ooxml-schemas</artifactId>
	<version>3.17</version>
</dependency>
```

---
## 二. 工具类
1. ExcelUtil 用于生成工作簿对象和sheet对象等
```
public class ExcelUtils {
	/**
	 * 
	 * @param titles 表格标题
	 * @param name sheet名
	 * @return
	 * @throws Exception
	 */
	public static Workbook exportExcel(String[] titles,String name) throws Exception{

		// 新建工作簿对象
		XSSFWorkbook workBook = new XSSFWorkbook();
		// 创建sheet对象
		XSSFSheet sheet = workBook.createSheet(name);
		// 创建行,标题行
		XSSFRow row = sheet.createRow(0);
		for(int i = 0; i < titles.length; i++){
			// 创建单元格
			XSSFCell cell = row.createCell(i);
			// 设置单元格内容
			cell.setCellValue(titles[i]);
		}
		return workBook;
	}
}
```
2. BuildPath 用于创建响应对象输出流
```
public class BuildPath {
	/**
	 * 
	 * @param response  响应对象
	 * @param fileName  输出内容
	 * @return 响应对象输出流
	 * @throws IOException
	 */
	public  static OutputStream  Manual_Saving(HttpServletResponse response,String fileName) throws IOException{
		
		//浏览器自选输出路径
		response.setHeader("Content-disposition", "attachment;filename="+fileName);
		response.setContentType("application/msexcel");

		OutputStream out=response.getOutputStream();
		return out;
	}
}
```
---
## 三、后台
1. 导出Txt(只需要传入需要导出表的id集合如“1,2,3”即可)
```
@RequestMapping("/exportTxt.do")
public void exportTerminalKey(HttpServletRequest request, HttpServletResponse response,String ids) throws Exception {

		Result result=new Result(6001, false, "导出失败");
		
		List<String> list=new ArrayList<>();
		Collections.addAll(list, ids.split(","));
		VO mv=new VO();
		mv.setIds(list);
		List<Medicine> medicines=medicineService.selectAll(mv);
		StringBuilder sb = new StringBuilder("编号,图片地址,进价,售价,药品名称\r\n");
		if(medicines!=null&&medicines.size()>0){
			for(int i=0;i<medicines.size();i++){
				sb.append(
						medicines.get(i).getM_number()+","+
						medicines.get(i).getM_image_addr()+","+
						medicines.get(i).getM_purchase()+","+
						medicines.get(i).getM_selling()+","+
						medicines.get(i).getM_name()+"\r\n");
			}
		}
		BufferedOutputStream output = null;
		BufferedInputStream input = null;
		
		//设置输出流对象
		OutputStream os =BuildPath.Manual_Saving(response, "Mediine.txt");
		try{
			byte[] byt = sb.toString().getBytes();
			os.write(byt);
		}catch(Exception e){
			System.out.println("chucuo");
		}finally{
			os.flush();
			os.close();
			if(input!=null){
				input.close();
			}
			if(output!=null){
				output.close();
			}
		}
		if(medicines!=null){
			//所有信息装入result对象
			result.setCode(6000);
			result.setFlag(true);
			result.setMessage("导出成功");		
		}
	}
```
2. 导出Excel(只需要传入需要导出表的id集合如“1,2,3”即可)
```
@RequestMapping("/exportMedicine.do")
	public void exportDoctor(String ids,HttpServletResponse response) throws Exception{

		String[] titles={"编号","图片地址","进价","售价","药品名称"};
		Result result=new Result(6001, false, "导出失败");
		VO mv=new VO();
		List<String> list=new ArrayList<>();
		//分割ids字符串得到数组并放入集合
		Collections.addAll(list, ids.split(","));
		mv.setIds(list);
		//查询所有信息放到集合中
		List<Medicine> medicines=medicineService.selectAll(mv);
		
		//设置导出信息
		Workbook wk=ExcelUtils.exportExcel(titles,"药品信息");

		XSSFSheet sheet=(XSSFSheet) wk.getSheet("药品信息");
		
		//取出集合中的数据放到表格中
		for(int i=0;i<medicines.size();i++){
			XSSFRow row = sheet.createRow(i+1);

			row.createCell(0).setCellValue(medicines.get(i).getM_number());
			row.createCell(1).setCellValue(medicines.get(i).getM_image_addr());
			row.createCell(2).setCellValue(medicines.get(i).getM_purchase());
			row.createCell(3).setCellValue(medicines.get(i).getM_selling());
			row.createCell(4).setCellValue(medicines.get(i).getM_name());

		}
		//设置输出流
		OutputStream out=BuildPath.Manual_Saving(response, "Medicine.xls");
		wk.write(out);
		wk.close();
		if(medicines!=null){
			//所有信息装入result对象
			result.setCode(6000);
			result.setFlag(true);
			result.setMessage("导出成功");		
		}

		System.out.println(result);
	} 
```
## 四、前端
1. JavaScript
```
$.post("../selectMedicineByCondition.do",{pageNum:pageNum,m_name:m_name,m_type:m_type},function(result){
    //填充数据到tbody
    $("#tbody").empty();//清除之前的内容
    $(result.object.list).each(function(index,medicine){
    	$("#tbody").append(
    			" <tr>"+
             	"<td style='vertical-align:middle;'><input type='checkbox' name='check' value='"+medicine.m_id+"'></td>"+
                "<td style='vertical-align:middle;'>"+medicine.m_number+"</td>"+
                "<td style='vertical-align:middle;''>"+medicine.m_name+"</td>"+
                "<td style='vertical-align:middle;''>"+medicine.m_type+"</td>"+
                "<td style='vertical-align:middle;''>"+medicine.m_description+"</td>"+
                "<td style='vertical-align:middle;''>"+medicine.m_state+"</td>"+
                "<td style='vertical-align:middle;''>"+medicine.m_residue+"</td>"+
                "<td style='vertical-align:middle;'>"+
                "<a id='btn6' m_id="+medicine.m_id+">详情>>></a> &nbsp;&nbsp;&nbsp;"+
            	"</tr>"
            	);
    })
},"json");	

$("input[type=checkbox]").live("change",function(){
	delAll();  
})
//查看所有被选中的checkbox框并记录其id
function delAll(){
	var alls=document.getElementsByName("check");
	var ids=new Array();
	for(var i=0;i<alls.length;i++){
		if(alls[i].checked){
			ids.push(alls[i].value);
		}		
	}
	$(".ids").val(ids);	
}

```
2. Html
```
<table class="table table-bordered table-hover definewidth m10" >
    <thead>
    <tr>
        <th><input type="checkbox" id="checkall" onChange="checkall();"></th>
        <th>药品编号</th>
        <th>药品名称</th>
        <th>药品类型</th>
        <th>简单描述</th>
        <th>状态</th>
        <th>剩余量</th>
        <th>操作</th>
    </tr> 
    </thead>
    <tbody id="tbody">
    </tbody>
</table>

<form action="../exportMedicine.do" method="post" style="display: inline-block;">
	<input type="hidden" class="ids" name="ids" value="">
	<input type="submit" class="btn btn-success" value="导出Excel">
</form>
<form action="../exportTxt.do" method="post" style="display: inline-block;">
	<input type="hidden" class="ids" name="ids" value="">
	<input type="submit" class="btn btn-success" value="导出txt">
</form>
```
