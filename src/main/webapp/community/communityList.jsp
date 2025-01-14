<%@page import="data.dto.ReplyDTO"%>
<%@page import="data.dao.ReplyDAO"%>
<%@page import="data.dto.MemberDTO"%>
<%@page import="data.dao.MemberDAO"%>
<%@page import="data.dto.SmartDTO"%>
<%@page import="data.dao.SmartDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<style>
.search-div>* {
	vertical-align: top;
}

#selsearch {
	width: 100px;
	height: 30px;
}

#textSearch {
	width: 350px;
	height: 30px;
}
</style>
<script type="text/javascript">
 $(function(){
	$(".searchBTN").click(function(){
		var col=$("#selSearch").val();
		var s=$("#textSearch").val();
		//alert(col+","+s);
		location.href="index.jsp?go=community/communityList.jsp&menu_one=11&menu_two=27&selSearch="+col+"&textSearch="+s;
	}) ;
 });
</script>
<%
request.setCharacterEncoding("UTF-8");
String column=request.getParameter("selSearch");
String words=request.getParameter("textSearch");
//System.out.println(column+","+words);

//세션
MemberDTO mdto = new MemberDTO();
MemberDAO mdao = new MemberDAO();
String sessionLogin = (String)session.getAttribute("sessionLogin");

SmartDAO dao = new SmartDAO();
int perPage = 7;//한페이지에 보여질 갯수
int chuPage = 3;//페이지마다 출력될 3개의 추천게시물
int totalCount;//총갯수글
int currentPage;//현재 페이지 번호
int totalPage;//총 페이지 갯수
int start;//각페이지에서 불러올 db의 시작번호
int perBlock = 5;//몇개의 페이지 번호씩 표현할것인가
int startPage;//각블럭에 표시할 시작페이지
int endPage;//각 블럭에 표시할 마지막 페이지

//총 갯수
totalCount = dao.getTotalCount(column,words);
//현재페이지 번호 읽기 (단 null 일경우는 1페이지로 설정)
if (request.getParameter("currentPage") == null)
	currentPage = 1;
else
	currentPage = Integer.parseInt(request.getParameter("currentPage"));

//총 페이지 갯수 구하기
totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);
//각 블럭의 시작페이지
startPage = (currentPage - 1) / perBlock * perBlock + 1;
endPage = startPage + perBlock - 1;
if (endPage > totalPage)
	endPage = totalPage;
//각페이지에서 불러올 시작번호
start = (currentPage - 1) * perPage;
//각페이지에서 필요한 게시글 가져오기
List<SmartDTO> list = dao.getList(start, perPage, column, words);
//제목 검색한 게시물 가져오기
//List<SmartDTO> list1= dao.SearchSubList(search, start, perPage);
if (list.size() == 0 && totalCount > 0) {
%>
<script type="text/javascript">
			//	location.href="index.jsp?go=community/communityList.jsp?currentPage=<%=currentPage - 1%>";
</script>
<%
}
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
//각페이지에 출력할 시작번호
int no = totalCount - (currentPage - 1) * perPage;
ReplyDAO adao=new ReplyDAO();
%>
<body>
<!-- <form action="index.jsp?go=community/communityList.jsp" method="post">
   <input type="hidden" name="menu_two" value="27" id="menu_two">
   <input type="hidden" name="menu_one" value="11">
   
	<div>
		<select name="selSearch">
			<option value="">--검색타입</option>
			<option value="subject" class="onlySub">제목만</option>
			<option value="content" class="onleCon">내용만</option>
			<option value="nickname" class="onlyNick">닉네임</option>
		</select> <input name="textSearch" />
		<button type="submit" class="btn btn-success searchBTN" style="width: 70px;">검색</button>
	</div>
</form>	 -->
	<p class="title">커뮤니티</p>
   <input type="hidden" name="menu_two" value="27" id="menu_two">
   <input type="hidden" name="menu_one" value="11">
   
	<div>
		<select id="selSearch">
			<option value="">--검색타입</option>
			<option value="subject" class="onlySub">제목만</option>
			<option value="content" class="onleCon">내용만</option>
			<option value="nickname" class="onlyNick">닉네임</option>
		</select> <input id="textSearch" />
		<button type="button" class="btn btn-add searchBTN" style="width: 70px; margin-bottom: 10px;">검색</button>
	</div>

	<!-- 게시판 출력 -->
	<table class="table table-bordered">
		<colgroup>
			<col width="70">
			<col width="350">
			<col width="100">
			<col width="150">
			<col width="70">
			<col width="70">
		</colgroup>
		<thead>
			<tr bgcolor="#ddd">
				<th>번호</th>
				<th>제목</th>
				<th>닉네임</th>
				<th>작성일</th>
				<th>조회</th>
				<th>추천</th>
			</tr>
		</thead>
		<tbody>
			<%
				if (totalCount == 0) {
				%>
			<tr height="40">
				<td colspan="5" align="center"><b>등록된 게시글이 없습니다</b></td>
			</tr>
			<%
				} else{
				for (SmartDTO dto : list) {
				List<ReplyDTO> alist=adao.getAllAnswer(dto.getIdx());
				%>
			<tr id="selShow">
				<td align="center"><%=no--%></td>
				<td><a style="color: black;"
					href="index.jsp?go=community/detail.jsp?idx=<%=dto.getIdx()%>&currentPage=<%=currentPage%>&key=list&menu_one=11&menu_two=27">
						<%=dto.getSubject()%><span style="color: orange;">[<%=alist.size()%>]</span>
				</a></td>
				<td><%=dto.getNickname()%></td>
				<td><%=sdf.format(dto.getWrite_day())%></td>
				<td><%=dto.getRead_count()%></td>
				<td><%=dto.getChu_count()%></td>
			</tr>
			<%
					}
				}
				%>
		</tbody>
	</table>
	<%
	if(sessionLogin!=null){
	%>
	<button type="button" class="btn btn-add"
		style="width: 100px; margin-left: 700px;"
		onclick="location.href='index.jsp?go=community/comForm.jsp&menu_one=11&menu_two=27'">
		<span class="glyphicon glyphicon-pencil"></span>글쓰기
	</button>
	<%
	}
	%>

	<!-- 페이징 -->
	<div style="width: 900px; text-align: center;">
		<ul class="pagination">
			<%
			//이전
			if (startPage > 1) {
			%>
			<li><a
				href="community/communityList.jsp&menu_one=11&menu_two=27&column=<%=column%>&words=<%=words%>&currentPage=<%=startPage - 1%>">이전</a>
			</li>
			<%
			}

			for (int pp = startPage; pp <= endPage; pp++) {
			if (pp == currentPage)//현재페이지일때  active
			{
			%>
			<li class="active"><a
				href="index.jsp?go=community/communityList.jsp&menu_one=11&menu_two=27&column=<%=column%>&words=<%=words%>&currentPage=<%=pp%>"><%=pp%></a></li>
			<%
			} else {
			%>
			<li><a href="index.jsp?go=community/communityList.jsp&menu_one=11&menu_two=27&column=<%=column%>&words=<%=words%>&currentPage=<%=pp%>"><%=pp%></a></li>
			<%
			}
			}

			//다음
			if (endPage < totalPage) {
			%>
			<li><a
				href="index.jsp?go=community/communityList.jsp&menu_one=11&menu_two=27&column=<%=column%>&words=<%=words%>&currentPage=<%=endPage + 1%>">다음</a>
			</li>
			<%
			}
			%>
		</ul>
	</div>
</body>
</html>