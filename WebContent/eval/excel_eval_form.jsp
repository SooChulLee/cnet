<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/common.jsp" %>
<%
// 메뉴 접근권한 체크
if(!Site.isPmss(out,"eval","")) return;

Db db = null;

try {
	// DB Connection
	db = new Db(true);

	// get parameter
	String event_code = CommonUtil.getParameter("event_code");
	String sheet_code = CommonUtil.getParameter("sheet_code");
	String result_seq = CommonUtil.getParameter("result_seq");

	// 파라미터 체크
	if(!CommonUtil.hasText(event_code) || !CommonUtil.hasText(sheet_code) || !CommonUtil.hasText(result_seq)) {
		out.print(CommonUtil.getPopupMsg(CommonUtil.getErrorMsg("NO_PARAM"),"","back"));
		return;
	}

	JSONObject json = new JSONObject();

	Map<String, Object> argMap = new LinkedHashMap();
	Map<String, Object> cpmap = new LinkedHashMap();
	Map<String, Object> camap = new LinkedHashMap();
	Map<String, Object> itmap = new LinkedHashMap();

	argMap.put("event_code", event_code);
	argMap.put("sheet_code", sheet_code);
	argMap.put("result_seq", result_seq);

	// 이벤트 조회
	Map<String, Object> evtmap  = db.selectOne("event.selectItem", argMap);

	// result select
	Map<String, Object> resmap = db.selectOne("eval_result.selectItem", argMap);

	// sheet select
	List<Map<String, Object>> list = db.selectList("eval_result.sheetView", argMap);

	for(Map<String, Object> item : list) {
		// 부모 카테고리 건수
		cpmap.put(item.get("cate_pcode").toString(), ComLib.toINN(cpmap.get(item.get("cate_pcode")))+1);
		// 자식 카테고리 건수
		camap.put(item.get("cate_code").toString(), ComLib.toINN(camap.get(item.get("cate_code")))+1);
		// 평가 항목 건수
		itmap.put(item.get("item_code").toString(), ComLib.toINN(itmap.get(item.get("item_code")))+1);
		/*
		// 부모 카테고리 건수
		if(cpmap.containsKey(item.get("cate_pcode"))) {
			cpmap.put(item.get("cate_pcode").toString(), ComLib.toINN(cpmap.get(item.get("cate_pcode")))+1);
		} else {
			cpmap.put(item.get("cate_pcode").toString(), 1);
		}
		// 자식 카테고리 건수
		if(camap.containsKey(item.get("cate_code"))) {
			camap.put(item.get("cate_code").toString(), ComLib.toINN(camap.get(item.get("cate_code")))+1);
		} else {
			camap.put(item.get("cate_code").toString(), 1);
		}
		// 평가 항목 건수
		if(itmap.containsKey(item.get("item_code"))) {
			itmap.put(item.get("item_code").toString(), ComLib.toINN(itmap.get(item.get("item_code")))+1);
		} else {
			itmap.put(item.get("item_code").toString(), 1);
		}
		*/
	}

	// header 설정
	response.reset();
	response.setHeader("Content-type","application/vnd.ms-excel; charset=euc_kr");
	response.setHeader("Content-Description","Generated By CREC");
	//response.setHeader("Content-Disposition","attachment; filename = " + new String(("평가결과조회_" + resmap.get("user_name") + "_" + DateUtil.getToday("yyyyMMdd") + ".xls").getBytes("UTF-8"),"8859_1"));
	response.setHeader("Content-Disposition","attachment; filename = " + java.net.URLEncoder.encode("평가결과조회_" + resmap.get("user_name") + "_" + DateUtil.getToday("yyyyMMdd") + ".xls", "UTF-8"));
	response.setHeader("Pragma","no-cache");
	response.setHeader("Expires","0");
	response.setHeader("Cache-Control","max-age=0");

	StringBuffer sb = new StringBuffer();

	sb.append("<meta http-equiv='Content-Type' content='application/vnd.ms-excel;charset=euc-kr'>");
	sb.append("<style>.th {background-color:#E4E4E4 !important;font-weight:bold}; .title {font-weight:bold;font-size:18px}</style>");

	// 기본정보
	sb.append("<div class=title>1) 기본 정보</div>");
	sb.append("<table border='1' cellpadding='0' cellspacing='0' bordercolor='#BBBBBB'>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th>평가명</th>");
	sb.append("<td align='left' colspan='2' style='mso-number-format:\\@'>" + resmap.get("event_name") + "</td>");
	sb.append("<th class=th>평가일자</th>");
	sb.append("<td align='left' style='mso-number-format:\\@'>" + resmap.get("regi_datm").toString().substring(0,10) + "</td>");
	sb.append("<th class=th>평가상태</th>");
	sb.append("<td align='left' style='mso-number-format:\\@'>" + Finals.getValue(Finals.hEvalStatusHtml,resmap.get("eval_status")) + " (" + resmap.get("eval_rate_code_desc") + ")</td>");
	sb.append("</tr>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th>평가자명</th>");
	sb.append("<td align='left' colspan='2' style='mso-number-format:\\@'>" + resmap.get("eval_user_name") + "</td>");
	sb.append("<th class=th>상담원명</th>");
	sb.append("<td align='left' style='mso-number-format:\\@'>" + resmap.get("user_name") + "</td>");
	sb.append("<th class=th>총점/배점</th>");
	sb.append("<td align='left' style='mso-number-format:\\@'>" + resmap.get("eval_score") + " / " + evtmap.get("tot_score") + " (" + evtmap.get("item_cnt") + "개)</td>");
	sb.append("</tr>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th>녹취일자</th>");
	sb.append("<td align='left' colspan='2' style='mso-number-format:\\@'>" + resmap.get("rec_datm").toString().substring(0,10) + "</td>");
	sb.append("<th class=th>검색어</th>");
	sb.append("<td align='left' style='mso-number-format:\\@'>" + resmap.get("cust_name") + "</td>");
	sb.append("<td colspan='2'></td>");
	sb.append("</tr>");
	sb.append("</table>");

	sb.append("</td>");
	sb.append("</tr>");
	sb.append("<tr>");
	sb.append("<td height='25'></td>");
	sb.append("</tr>");
	sb.append("<tr>");
	sb.append("<td>");

	// 평가 상세
	sb.append("<br><div class=title>2) 평가 상세</div>");
	sb.append("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#CCCCCC' bordercolorlight='#DDDDDD' bordercolordark='#FFFFFF'>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th colspan='2'>카테고리</th>");
	sb.append("<th class=th>항목</th>");
	sb.append("<th class=th>보기</th>");
	sb.append("<th class=th>가중치</th>");
	sb.append("<th class=th>배점</th>");
	sb.append("<th class=th>채점</th>");
	sb.append("</tr>");

	int cp_idx=0, ca_idx=0, it_idx=0;
	for(Map<String, Object> item : list) {
		sb.append("<tr>");

		// 부모 카테고리
		if(cp_idx<1) {
			sb.append("<td style='mso-number-format:\\@' rowspan='" + cpmap.get(item.get("cate_pcode")) + "'>" + item.get("cate_pname") + "</td>");
			cp_idx = ComLib.toINN(cpmap.get(item.get("cate_pcode")))-1;
		} else {
			cp_idx--;
		}

		// 자식 카테고리
		if(ca_idx<1) {
			sb.append("<td style='mso-number-format:\\@' rowspan='" + camap.get(item.get("cate_code")) + "'>" + item.get("cate_name") + "</td>");
			ca_idx = ComLib.toINN(camap.get(item.get("cate_code")))-1;
		} else {
			ca_idx--;
		}

		// 평가 항목
		//System.out.println("ComLib.toINN(cpmap.get(item.get(item_code)))="+ComLib.toINN(cpmap.get(item.get("item_code"))));
		if(it_idx<1) {
			sb.append("<td style='mso-number-format:\\@' rowspan='" + itmap.get(item.get("item_code")) + "'>" + item.get("item_name") + "</td>");
			it_idx = ComLib.toINN(itmap.get(item.get("item_code")))-1;
		} else {
			it_idx--;
		}

		// 보기
		sb.append("<td style='mso-number-format:\\@'>" + ComLib.toNN(item.get("exam_name")) + "</td>");
		// 가중치
		sb.append("<td style='mso-number-format:\\@'>" + ComLib.strTo(ComLib.toNN(item.get("get_add_score")),"0","") + "</td>");
		// 배점
		sb.append("<td style='mso-number-format:\\@'>" + ComLib.toNN(item.get("exam_score")) + "</td>");
		// 채점
		sb.append("<td style='mso-number-format:\\@'>" + ComLib.toNN(item.get("get_exam_score")) + "</td>");
		sb.append("</tr>");
	}

	sb.append("</table>");

	sb.append("</td>");
	sb.append("</tr>");
	sb.append("<tr>");
	sb.append("<td height='25'></td>");
	sb.append("</tr>");

	sb.append("<tr>");
	sb.append("<td>");

	sb.append("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#CCCCCC' bordercolorlight='#DDDDDD' bordercolordark='#FFFFFF'>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th>코멘트</th>");
	sb.append("<td align='left' colspan='6' style='mso-number-format:\\@'>" + resmap.get("eval_comment") + "</td>");
	sb.append("</tr>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th>총평</th>");
	sb.append("<td align='left' colspan='6' style='mso-number-format:\\@'>" + resmap.get("eval_text") + "</td>");
	sb.append("</tr>");
	sb.append("<tr align='center'>");
	sb.append("<th class=th>베스트/워스트</th>");
	sb.append("<td align='left' colspan='6' style='mso-number-format:\\@'>" + resmap.get("eval_rate_code_desc") + "</td>");
	sb.append("</tr>");
	sb.append("</table>");

	sb.append("</td>");
	sb.append("</tr>");
	sb.append("</table>");


	List<Map<String, Object>> claim = db.selectList("eval_claim.selectList", argMap);
	if(claim.size()>0){
		sb.append("<br><div class=title>3) 이의 신청</div>");
	}
	for(Map<String, Object> item : claim) {
		sb.append("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#CCCCCC' bordercolorlight='#DDDDDD' bordercolordark='#FFFFFF'>");
		sb.append(	"<tr><th class=th style=width:80px>신청일시</th>");
		sb.append(		"<td id=claim_datm name=claim_datm colspan=2 align=left>"+ComLib.toNN(item.get("claim_datm"))+"</td>");
		sb.append(		"<th class=th style=width:80px>신청자</th>");
		sb.append(		"<td id=claim_user_name name=claim_user_name colspan=3>"+ComLib.toNN(item.get("claim_user_name"))+"</td>");
		sb.append(	"<tr><th class=th style=width:80px>신청사유</th>");
		sb.append(		"<td colspan=6 id=claim_contents name=claim_contents>"+ComLib.toHtml(item.get("claim_contents"))+"</td>");
		sb.append(	"<tr><th class=th style=width:80px>접수일시</th>");
		sb.append(		"<td id=recv_datm name=recv_datm colspan=2>"+ComLib.toNN(item.get("recv_datm"))+"</td>");
		sb.append(		"<th class=th style=width:80px>접수자</th>");
		sb.append(		"<td id=recv_user_name name=recv_user_name colspan=3>"+ComLib.toNN(item.get("recv_user_name"))+"</td>");
		sb.append(	"<tr><th class=th style=width:80px>처리일시</th>");
		sb.append(		"<td id=proc_datm name=proc_datm colspan=2>"+ComLib.toNN(item.get("proc_datm"))+"</td>");
		sb.append(		"<th class=th style=width:80px>처리자</th>");
		sb.append(		"<td id=proc_user_name name=proc_user_name colspan=3>"+ComLib.toNN(item.get("proc_user_name"))+"</td>");
		sb.append(	"<tr><th class=th style=width:80px>처리메모</th>");
		sb.append(		"<td colspan=6 id=proc_contents_txt name=proc_contents_txt>"+ComLib.toHtml(item.get("proc_contents_txt"))+"</td>");
		sb.append(	"<tr><th class=th style=width:80px>처리상태</th>");
		sb.append(		"<td colspan=6>"+Finals.getValue(Finals.hClaimStatusHtml,item.get("claim_status"))+"</td>");
		sb.append(	"</tr>");
		sb.append("</table>");
		sb.append("<br>");
	}

	out.print(sb.toString());
} catch(Exception e) {
	logger.error(e.getMessage());
} finally {
	if(db!=null) db.close();
}
%>