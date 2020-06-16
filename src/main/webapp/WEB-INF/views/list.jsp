<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>员工列表</title>

<!-- web路径
1.不以/开始的相对路径，找资源是以当前资源的路径为基准，经常容易出问题
推荐以“/”开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306），需要加上项目名
项目名也可以通过request的getcontextpath动态获得 
 -->
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>

<!-- Bootstrap -->

<script src="/DontKonwWTI/js/jquery.min.js" charset="utf-8"></script>
<link href="/DontKonwWTI/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="/DontKonwWTI/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12" style="border: 1px dashed #000">
				<h1>SSM CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-9" style="border: 1px dashed #000">
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-success">删除</button>
			</div>
		</div>
		<!-- 表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-striped">
					<tr>
						<th>ID</th>
						<th>名字</th>
						<th>网址</th>
						<th>排名</th>
						<th>国家</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="website">
						<tr>
							<th>${website.ID }</th>
							<th>${website.name }</th>
							<th>${website.url }</th>
							<th>${website.rank }</th>
							<th>${website.country }</th>
							<th><button type="button" class="btn btn-info btn-sm">
									<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
									编辑
								</button>
								<button type="button" class="btn btn-danger btn sm">
									<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
									删除
								</button></th>
						</tr>
					</c:forEach>


				</table>
			</div>
		</div>
		<!-- 分页信息 -->
		<div class="row">
			<div class="col-md-6">当前${pageInfo.pageNum }页，总${pageInfo.pages }页，总记录数${pageInfo.total }</div>
			<div class="col-md-6">
				<nav aria-label="...">
					<ul class="pagination">
						<li><a href="${APP_PATH }/list?pn=1">首页</a></li>
						<c:if test="${pageInfo.hasPreviousPage }">
							<li><a href="${APP_PATH }/list?pn=${pageInfo.pageNum-1}"
								aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
						</c:if>

						<c:forEach items="${pageInfo.navigatepageNums}" var="page_num">
							<c:if test="${page_num == pageInfo.pageNum }">
								<li class="active"><a href="#">${page_num }</a></li>
							</c:if>
							<c:if test="${page_num != pageInfo.pageNum }">
								<li><a href="${APP_PATH }/list?pn=${page_num }">${page_num }</a></li>
							</c:if>

						</c:forEach>
						<c:if test="${pageInfo.hasNextPage }">
							<li><a href="${APP_PATH }/list?pn=${pageInfo.pageNum+1}"
								aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>
						</c:if>
						<li><a href="${APP_PATH }/list?pn=${pageInfo.pages }">末页</a></li>
					</ul>
				</nav>
			</div>
		</div>
	</div>
</body>
</html>