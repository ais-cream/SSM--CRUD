package packages.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import packages.bean.Country;
import packages.bean.RetMes;
import packages.bean.Website;
import packages.service.WebService;

@Controller
public class WebController {
	@Autowired
	WebService website;
	
	@RequestMapping("/deleteWebsite/{id}")
	@ResponseBody
	public RetMes deleteWebsite(@PathVariable(value = "id")String id) {
		System.out.println("删除单个网站");
		if(id.contains("-")) {
			String[] list=id.split("-");
			for(String temp:list) {
				website.deleteWebsite(Integer.parseInt(temp));
			}
		}else website.deleteWebsite(Integer.parseInt(id));
		return RetMes.success();
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public RetMes updateWebsite(@RequestParam(value = "id")Integer id,Website website_update) {
		System.out.println(website_update);
		website.updateWebsiteById(id,website_update);
		return RetMes.success();
	}
	
	@RequestMapping("/queryWebsiteById")
	@ResponseBody
	public RetMes queryWebsiteById(@RequestParam(value = "id")Integer id) {
		Website web=website.queryWebsiteById(id);
		return RetMes.success().add("website",web);
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public RetMes add(Website website1) {
		website.addWebsite(website1.name,website1.url,website1.rank,website1.country);
		return RetMes.success();
	}
	
	@RequestMapping("/queryCountry")
	@ResponseBody
	public RetMes countryEnums() {
		List<Country> list = website.queryCountryEnums();
		//System.out.println(list.size());
		return RetMes.success().add("countrys",list);
	}
	
	@RequestMapping("/queryParticalWebsites")
	@ResponseBody
	public RetMes queryParticalWebsites(@RequestParam(value = "pn",defaultValue = "1") Integer pn,Website website1) {
		//System.out.println(666);
		System.out.println(website1);
		PageHelper.startPage(pn, 5);
		List<Website> list = website.queryParticalWebsites(website1);
		PageInfo<Website> page = new PageInfo<Website>(list,/*连续显示5页*/5);
		return RetMes.success().add("pageInfo",page);
	}

	
	@RequestMapping("/listWithJson")
	@ResponseBody
	public RetMes awithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn,Model model) {
		// 这是一个分页查询
		// 引入pagehelper分页插件
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是分页查询
		List<Website> list = website.getall();
		// pageInfo封装了详细的查询数据
		PageInfo<Website> page = new PageInfo<Website>(list,/*连续显示5页*/5);
		return RetMes.success().add("pageInfo",page);
	}

	@RequestMapping("/list")
	public String a(@RequestParam(value = "pn",defaultValue = "1") Integer pn,Model model) {
		// 这是一个分页查询
		// 引入pagehelper分页插件
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是分页查询
		List<Website> list = website.getall();
		// pageInfo封装了详细的查询数据
		PageInfo<Website> page = new PageInfo<Website>(list,/*连续显示5页*/5);
		model.addAttribute("pageInfo",page);
		return "list";
	}
}
