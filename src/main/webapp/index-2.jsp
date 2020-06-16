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

<script src="${APP_PATH }/js/jquery.min.js" charset="utf-8"></script>
<link href="/DontKonwWTI/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="/DontKonwWTI/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	var totalPage;
	var currentPage;
	//查询表单调用serialize函数后得到的字符串，用来区分是普通翻页还是结果翻页
	var form;
	$(function() {
		to_page(1);
		//为点击查询按钮绑定事件
		//1.先查国家的Ajax数据
		$.ajax({
			url : "${APP_PATH}/queryCountry",
			type : "get",
			success : function(result) {
				//给模态框的select标签增加国家
				$("#country_query").empty();
				var countrys = result.extend.countrys;
				$.each(countrys, function(index, item) {
					$("#country_query").append(
							$("<option></option>").append(item.name));
				});
			}
		});
		//2.绑定查询事件
		$("#query").click(function(){
			form=$("#kuang_query").serialize();
			to_partical_page(1);
			////////////////////////////////////////////////////////
		});
		//为点击批量删除按钮绑定事件
		//ajax请求是异步的，但函数执行是顺序的，所以这里可以拿到checkbox
		//更正上一句，函数遇到ajax请求就退出了。例子是上面to_page(1)函数执行的过程中
		//下面的为查询按钮查找国家数据的ajax请求里面的Sout语句也会执行，这里能拿到纯粹
		//是间隔的时间太长了。
		$("#Delete").click(function() {
			var temp = "";
			//为什么不能用size()，用length就没问题。。
			if ($(".check:checked").length == 0)
				alert("没有选择要删除的行！");
			else {
				$.each($(".check:checked"), function(index, item) {
					temp += $(this).parent().nextAll(".name").text() + ",";
				});
				temp = temp.substring(0, temp.length - 1);
				if (confirm("确定要删除[" + temp + "]吗？")) {
					temp = "";
					$.each($(".check:checked"), function(index, item) {
						temp += $(this).parent().next().text() + "-";
					});
					//去删除
					$.ajax({
						url : "${APP_PATH}/deleteWebsite/" + temp,
						type : "get",
						success : function() {
							console.log("已经批量删除啦");
							//怕万一全选的checkbox是选中状态，将它复原
							$("#check_all").prop("checked", false);
							if(form)to_partical_page(currentPage);
							else to_page(currentPage);
						}
					});
				}
			}

		});
		//为点击新增按钮绑定事件
		$("#newAdd").click(
				function() {
					//清除输入框的文本和class
					$("#name").val("");
					$("#url").val("");
					$("#rank").val("");
					$("#kuang #country").empty();
					resetClass();
					//为框的保存按钮绑定事件
					//因为会点击一次就绑定一次，所以要先将上次的解绑
					$("#save").unbind('click').click(function() {
						//前端校验数据
						if (!validate_form()) {
							return false;
						}
						//去保存
						$.ajax({
							url : "${APP_PATH}/save",
							type : "post",
							data : $("#kuang").serialize(),
							success : function(result) {
								alert(result.message);
								//关闭模态框
								$('#myModal').modal("hide");
								//去最后一页(去第总记录数页，然后pageHelper如果去了大于总页数的页
								form=null;  //清空一下form
								//会自动到最后一页，这样就避免了参数写一个常数可能会出现的异常）
								to_page(totalPage + 1);
							}
						});
					});
					//先查国家的Ajax数据

					$.ajax({
						url : "${APP_PATH}/queryCountry",
						type : "get",
						success : function(result) {
							//给模态框的select标签增加国家
							var countrys = result.extend.countrys;
							$.each(countrys, function(index, item) {
								$("#country").append(
										$("<option></option>")
												.append(item.name));
							});
						}
					});
					//弹出模态框
					$('#myModal').modal({
						backdrop : "static"
					});
				});
		//console.log(777);
		//为点击编辑按钮绑定事件,恼火 只有这一种方式能绑方法，不想努力了
		//上面这一行 console.log(777); 要比最上面的to_page函数还先执行，我吐了！！
		$(document).on(
				"click",
				".edit",
				function() {
					resetClass_edit();
					//0.给修改按钮绑定事件
					$("#edit").unbind('click').click(
							function(temp) {
								//前端校验数据
								if (!validate_form_edit()) {
									return false;
								}
								//去修改
								$.ajax({
									url : "${APP_PATH}/update",
									type : "post",
									data : "id=" + $("#id_edit").text() + "&"
											+ $("#kuang_edit").serialize(),
									success : function(result) {
										alert(result.message);
										//关闭模态框
										$('#myModal_edit').modal("hide");
										//跳转到同一页，刷新数据
										if(form)to_partical_page(currentPage);
										else to_page(currentPage);
									}
								});
							});
					//1.查询要回显的网站数据
					$.ajax({
						url : "${APP_PATH}/queryWebsiteById",
						type : "post",
						data : "id=" + $(this).attr("id"),
						success : function(result) {
							console.log(result);
							//先查国家的Ajax数据
							$.ajax({
								url : "${APP_PATH}/queryCountry",
								type : "get",
								success : function(result) {
									//给模态框的select标签增加国家
									$("#country_edit").empty();
									var countrys = result.extend.countrys;
									$.each(countrys, function(index, item) {
										$("#country_edit").append(
												$("<option></option>").append(
														item.name));
										$("#country_edit option:contains("
												+ web.country + ")")
												.attr("selected", "true");
									});
								}
							});
							//拼数据
							$("#country_edit").empty();
							var web = result.extend.website;
							$("#id_edit").text(web.ID);
							$("#name_edit").val(web.name);
							$("#url_edit").val(web.url);
							$("#rank_edit").val(web.rank);
						}
					});
					//2.打开模态框
					$('#myModal_edit').modal({
						backdrop : "static"
					});
				});

		//为点击删除按钮绑定事件
		$(document)
				.on(
						"click",
						".delete",
						function() {
							if (confirm("确定要删除["
									+ $(this).parent().prevAll(".name").text()
									+ "]吗？")) {
								$.ajax({
									url : "${APP_PATH}/deleteWebsite/"
											+ $(this).prev().attr("id"),
									type : "get",
									success : function() {
										console.log("已经删除啦");
										if(form)to_partical_page(currentPage);
										else to_page(currentPage);
									}
								});

							}
						});

	});

	//校验表单	
	function validate_form_edit() {
		//1.拿到要校验的数据
		var name = $("#name_edit").val();
		var url = $("#url_edit").val();
		var rank = $("#rank_edit").val();
		//只能是2到5个中文或者6到16个数字、字母、下划线、-的组合
		var segName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
		//只能以http(s)开头，以/结尾
		var segUrl = /(^https?.*\/$)/;
		//只能是数字
		var segRank = /(^\d\d*?$)/;
		//先清空输入框的显示
		resetClass();
		if (!segName.test(name)) {
			$("#name-fa_edit").addClass("has-error");
			$("#name_edit").next("span").text(
					"网站名必须是2到5位的中文或者6到16位的数字、字母、下划线、-的组合");
			return false;
		} else
			$("#name-fa_edit").addClass("has-success");
		if (!segUrl.test(url)) {
			$("#url-fa_edit").addClass("has-error");
			$("#url_edit").next("span").text("网站地址必须以http(s)开头，以/结尾");
			return false;
		} else
			$("#url-fa_edit").addClass("has-success");
		if (!segRank.test(rank)) {
			$("#rank-fa_edit").addClass("has-error");
			$("#rank_edit").next("span").text("排名必须是数字");
			return false;
		} else
			$("#rank-fa_edit").addClass("has-success");
		return true;
	}

	//校验表单	
	function validate_form() {
		//1.拿到要校验的数据
		var name = $("#name").val();
		var url = $("#url").val();
		var rank = $("#rank").val();
		var segName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
		var segUrl = /(^https?.*\/$)/;
		var segRank = /(^\d\d*?$)/;
		//先清空输入框的显示
		resetClass();
		if (!segName.test(name)) {
			$("#name-fa").addClass("has-error");
			$("#name").next("span").text("网站名必须是2到5位的中文或者6到16位的数字、字母、下划线、-的组合");
			return false;
		} else
			$("#name-fa").addClass("has-success");
		if (!segUrl.test(url)) {
			$("#url-fa").addClass("has-error");
			$("#url").next("span").text("网站地址必须以http(s)开头，以/结尾");
			return false;
		} else
			$("#url-fa").addClass("has-success");
		if (!segRank.test(rank)) {
			$("#rank-fa").addClass("has-error");
			$("#rank").next("span").text("排名必须是数字");
			return false;
		} else
			$("#rank-fa").addClass("has-success");
		return true;
	}

	function resetClass_edit() {
		$("#name-fa_edit").removeClass("has-success has-error");
		$("#name_edit").next("span").text("");
		$("#url-fa_edit").removeClass("has-success has-error");
		$("#url_edit").next("span").text("");
		$("#rank-fa_edit").removeClass("has-success has-error");
		$("#rank_edit").next("span").text("");
	}

	function resetClass() {
		$("#name-fa").removeClass("has-success has-error");
		$("#name").next("span").text("");
		$("#url-fa").removeClass("has-success has-error");
		$("#url").next("span").text("");
		$("#rank-fa").removeClass("has-success has-error");
		$("#rank").next("span").text("");
	}
	
	function to_partical_page(pn){
		console.log(form);
		$.ajax({
			url : "${APP_PATH}/queryParticalWebsites",
			type : "post",
			data : "pn="+pn+"&"+form,
			success : function(result){
				var func="to_partical_page(pn,temp)";
				build_table(result);
				build_nav(result);
				//部分查询的时候新增应该不更新总记录数，去所有记录的最后一页
				//totalPage = result.extend.pageInfo.total;
				//保存当前第几页，方便修改网站信息后跳转到同一页
				currentPage = result.extend.pageInfo.pageNum;
			}
		});
	}
	
	function to_page(pn) {
		$.ajax({
			url : "${APP_PATH}/listWithJson",
			data : "pn=" + pn,
			type : "post",
			success : function(result) {
				console.log(result);
				//1.构造表格
				build_table(result);
				//2.构造分页条
				build_nav(result);
				//保存总记录数，方便新增记录后跳转到最后一页
				totalPage = result.extend.pageInfo.total;
				//保存当前第几页，方便修改网站信息后跳转到同一页
				currentPage = result.extend.pageInfo.pageNum;
			}
		});
	}

	function build_table(result) {
		//每次append前先清空table
		$("#table tbody").empty();
		var websites = result.extend.pageInfo.list;
		$.each(websites, function(index, item) {
			var check = $("<td></td>").append(
					$("<input/>").addClass("check").attr({
						type : "checkbox",
						onclick : "check()"
					}));
			var id = $("<td></td>").append(item.ID);
			var name = $("<td></td>").append(item.name).addClass("name");
			var url = $("<td></td>").append(item.url);
			var alexa = $("<td></td>").append(item.rank);
			var country = $("<td></td>").append(item.country);
			var editbutton = $("<button></button>").addClass(
					"btn btn-info btn-sm edit").attr("id", item.ID).append(
					$("<span></span>").addClass("glyphicon glyphicon-pencil")
							.append("编辑"));
			var deletebutton = $("<button></button>").addClass(
					"btn btn-danger btn-sm delete").append(
					$("<span></span>").addClass("glyphicon glyphicon-trash")
							.append("删除"));
			var btd = $("<td></td>").append(editbutton).append(" ").append(
					deletebutton);
			$("<tr></tr>").append(check).append(id).append(name).append(url)
					.append(alexa).append(country).append(btd).appendTo(
							"#table tbody");
		});
	}

	function build_nav(result) {
		$("#mes").empty();
		$(".pagination").empty();
		//分页条左边
		$("#mes").append(
				"当前" + result.extend.pageInfo.pageNum + "页,共"
						+ result.extend.pageInfo.pages + "页,共"
						+ result.extend.pageInfo.total + "条记录");
		//分页条右边
		var firstPage = $("<li></li>").append(
				$("<a></a>").append("首页").attr("href", "#"));
		var prePage = $("<li></li>").append(
				$("<a></a>").append("&laquo;").attr("href", "#"));
		if (result.extend.pageInfo.hasPreviousPage == false) {
			firstPage.addClass("disabled");
			prePage.addClass("disabled");
		} else {
			firstPage.click(function() {
				if(form)to_partical_page(1);
				else to_page(1);
			});
			prePage.click(function() {
				if(form)to_partical_page(result.extend.pageInfo.pageNum - 1);
				else to_page(result.extend.pageInfo.pageNum - 1);
			});
		}
		var nextPage = $("<li></li>").append(
				$("<a></a>").append("&raquo;").attr("href", "#"));
		var lastPage = $("<li></li>").append(
				$("<a></a>").append("末页").attr("href", "#"));
		if (result.extend.pageInfo.hasNextPage == false) {
			nextPage.addClass("disabled");
			lastPage.addClass("disabled");
		} else {
			nextPage.click(function() {
				if(form)to_partical_page(result.extend.pageInfo.pageNum + 1);
				else to_page(result.extend.pageInfo.pageNum + 1);
			});
			lastPage.click(function() {
				if(form)to_partical_page(result.extend.pageInfo.pages);
				else to_page(result.extend.pageInfo.pages);
			});
		}
		$(".pagination").append(firstPage).append(prePage);
		$.each(result.extend.pageInfo.navigatepageNums, function(index, item) {
			var temp = $("<li></li>").append(
					$("<a></a>").append(item).attr("href", "#"));
			if (result.extend.pageInfo.pageNum == item)
				temp.addClass("active");
			temp.click(function() {
				if(form)to_partical_page(item);
				else to_page(item);
			});
			$(".pagination").append(temp);
		});
		$(".pagination").append(nextPage).append(lastPage);
	}

	function checkAll() {
		if ($("#check_all").prop("checked")) {
			$.each($(".check"), function() {
				$(this).prop("checked", true);
			});
		} else {
			$.each($(".check"), function() {
				$(this).prop("checked", false);
			});
		}
	}

	function check() {
		if ($(".check:checked").length == 5)
			$("#check_all").prop("checked", true);
		else if ($(".check:checked").length < 5)
			$("#check_all").prop("checked", false);
	}
</script>

</head>
<body>
	<!-- 点击编辑按钮出来的div -->
	<div class="modal fade" id="myModal_edit" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel_edit">修改网站信息</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="kuang_edit" onsubmit="return false;" >
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">ID</label>
							<div class="col-sm-10" id="id-fa_edit">
								<p class="form-control-static" id="id_edit"></p>
							</div>
						</div>
						<div class="form-group" id="name-fa_edit">
							<label for="inputPassword3" class="col-sm-2 control-label">WebsiteName</label>
							<div class="col-sm-10">
								<input type="text" name="name" class="form-control" id="name_edit"
									placeholder="bilibili">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group" id="url-fa_edit">
							<label for="inputPassword3" class="col-sm-2 control-label">WebsiteUrl</label>
							<div class="col-sm-10">
								<input type="text" name="url" class="form-control" id="url_edit"
									placeholder="www.bilibili.com/">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group" id="rank-fa_edit">
							<label for="inputPassword3" class="col-sm-2 control-label">排名</label>
							<div class="col-sm-10">
								<input type="text" name="rank" class="form-control" id="rank_edit"
									placeholder="1">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="inputPassword3" class="col-sm-2 control-label">国家</label>
							<div class="col-sm-4">
								<select name="country" class="form-control" id="country_edit">
									
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="edit">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 点击新增按钮出来的div -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增网站</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="kuang" onsubmit="return false;" >
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">ID</label>
							<div class="col-sm-10" id="id-fa">
								<input type="text" name="ID_notneed" class="form-control" id="id"
									placeholder="disabled input here" disabled>
							</div>
						</div>
						<div class="form-group" id="name-fa">
							<label for="inputPassword3" class="col-sm-2 control-label">WebsiteName</label>
							<div class="col-sm-10">
								<input type="text" name="name" class="form-control" id="name"
									placeholder="bilibili">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group" id="url-fa">
							<label for="inputPassword3" class="col-sm-2 control-label">WebsiteUrl</label>
							<div class="col-sm-10">
								<input type="text" name="url" class="form-control" id="url"
									placeholder="www.bilibili.com/">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group" id="rank-fa">
							<label for="inputPassword3" class="col-sm-2 control-label">排名</label>
							<div class="col-sm-10">
								<input type="text" name="rank" class="form-control" id="rank"
									placeholder="1">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="inputPassword3" class="col-sm-2 control-label">国家</label>
							<div class="col-sm-4">
								<select name="country" class="form-control" id="country">
									
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="save">保存</button>
				</div>
			</div>
		</div>
	</div>

	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12" style="border: 1px dashed #000">
				<h1>SSM CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-10">
				<form class="form-inline" id="kuang_query"
					onsubmit="return false;">
					<div class="form-group" id="name-fa_query"  style="width:30%;border: 1px dashed #000">
						<label for="name_query">WebsiteName</label>
							<input type="text" name="name" class="form-control"
								id="name_query" placeholder="bilibili"style="width:65%"> <span
								class="help-block"></span>
					</div>
					<div class="form-group"  style="width:30%;border: 1px dashed #000">
						<label for="url_query">WebsiteUrl</label>
							<input type="text" name="url" class="form-control" id="url_query"
								placeholder="www.bilibili.com/"> <span
								class="help-block"></span>
					</div>
					<div class="form-group"  style="width:20%;border: 1px dashed #000">
						<label for="rank_query">排名</label>
							<input type="text" name="rank" class="form-control"
								id="rank_query" placeholder="1" style="width:80%"> <span class="help-block"></span>
					</div>
					<div class="form-group"  style="width:18%;border: 1px dashed #000">	
						<label for="country_query">国家</label>
							<select name="country" class="form-control" id="country_query" style="width:45%">

							</select>
							<button class="btn btn-warning" id="query">查询</button>
					</div>
				</form>
			</div>
			<div class="col-md-2" style="border: 1px dashed #000">
				<button class="btn btn-primary" id="newAdd">新增</button>
				<button class="btn btn-success" id="Delete">删除</button>
			</div>
		</div>
		<!-- 表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-striped" id="table">
					<thead>
						<tr>
							<th><input type="checkbox" id="check_all" onclick="checkAll()"/></th>
							<th>ID</th>
							<th>名字</th>
							<th>网址</th>
							<th>排名</th>
							<th>国家</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<!-- 分页信息 -->
		<div class="row">
			<div class="col-md-6" id="mes"></div>
			<div class="col-md-6" id="nav">
				<nav aria-label="...">
					<ul class="pagination">
						
					</ul>
				</nav>
			</div>
		</div>
	</div>
</body>
</html>