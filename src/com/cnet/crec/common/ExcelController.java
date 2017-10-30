package com.cnet.crec.common;

import java.io.IOException;
import java.nio.charset.Charset;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

import com.cnet.crec.util.DateUtil;

public class ExcelController {

	public String toExcel(String excel, String extension, HttpServletRequest request) throws IOException {
		String filename="";
		if (extension.equals("csv") || extension.equals("xml")) {
			filename = "pqGrid." + extension;
			HttpSession ses = request.getSession(true);
			ses.setAttribute("excel", excel);
		}
		return filename;
	}

	public void toExcel(String filename, HttpServletRequest request, HttpServletResponse response) throws IOException {
		if (filename.equals("pqGrid.csv") || filename.equals("pqGrid.xml")) {
			HttpSession ses = request.getSession(true);
			String excel = (String) ses.getAttribute("excel");

			byte[] bytes = excel.getBytes(Charset.forName("UTF-8"));

			response.reset();
			response.setHeader("Content-type","application/vnd.ms-excel; charset=euc_kr");
			response.setHeader("Content-Description","Generated By CNetTechnology");
			response.setHeader("Content-Disposition","attachment; filename = " + java.net.URLEncoder.encode(filename+"_("+DateUtil.getToday("yyyy-MM-dd")+")"+".xls", "UTF-8"));

			response.setContentLength(bytes.length);
			ServletOutputStream out = response.getOutputStream();
			out.write(bytes);

			out.flush();
			out.close();
		}
	}

	public void toExcel(HttpServletRequest request, HttpServletResponse response, JspWriter out) throws IOException {
		String filename = ComLib.getPSNN(request, "filename");
		String excel = ComLib.getPSNN(request, "excel");
		String ext = ComLib.getPSNN(request, "extension");
		if(!excel.equals("")) request.getSession().setAttribute("excel", excel);
		else excel = ComLib.toNN(request.getSession().getAttribute("excel"));
		//System.out.println("filename="+filename);
		//System.out.println("excel"+excel);
		//System.out.println("ext="+ext);

		byte[] bytes = excel.getBytes(Charset.forName("EUC-KR"));
		//System.out.println("bytes.length="+bytes.length);
		//response.reset();
		response.setHeader("Content-type","application/vnd.ms-excel; charset=euc_kr");
		response.setHeader("Content-Description","Generated By CNetTechnology");
		response.setHeader("Content-Disposition","attachment; filename = " + java.net.URLEncoder.encode("test_("+DateUtil.getToday("yyyy-MM-dd")+")"+".xls", "UTF-8"));


		//response.setContentType("text/plain");
		//response.setHeader("Content-Disposition", "attachment;filename=" + "aaa.xls" + ext);
		excel = excel.substring(excel.indexOf("<Table>"));
		excel = excel.replaceAll("<Table>", "<Table border=1>");
		excel = excel.replaceAll("<Row>", "<tr>");
		excel = excel.replaceAll("<Cell>", "<td>&nbsp;");
		excel = excel.replaceAll("</Cell>", "</td>");
		excel = excel.replaceAll("</Row>", "</tr>");
		excel = excel.replaceAll("<Data ss:Type=\"String\">", "");
		excel = excel.replaceAll("</Data>", "");
		excel = excel.replaceAll("<!\\[CDATA\\[", "");
		excel = excel.replaceAll("]]>", "");
		excel = excel.replaceAll("undefined>", "");

		out.println(excel);
		//System.out.println("excel="+excel);
		//response.setContentLength(bytes.length);
//		ServletOutputStream out1 = response.getOutputStream();
//		out1.write(bytes);
//		out1.flush();
//		out1.close();
	}
}
