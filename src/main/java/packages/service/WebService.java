package packages.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import packages.bean.Country;
import packages.bean.Website;
import packages.dao.WebsiteDao;
@Service
public class WebService {
	@Autowired
	WebsiteDao websiteDao;
	
	/**
	 * 查询所有员工
	 * @return
	 */
	public List<Website> getall() {
		return websiteDao.queryAllWebsites();
		
	}

	public List<Country> queryCountryEnums() {
		// TODO Auto-generated method stub
		return websiteDao.queryCountry();
	}

	public void addWebsite(String name, String url, int rank, String country) {
		// TODO Auto-generated method stub
		websiteDao.addWebsite(name,url,rank,country);
	}

	public Website queryWebsiteById(int id) {
		// TODO Auto-generated method stub
		return websiteDao.queryWebsiteById(id);
	}

	public void updateWebsiteById(Integer id, Website website_update) {
		websiteDao.updateWebsite(id,website_update);
	}

	public void deleteWebsite(Integer id) {
		// TODO Auto-generated method stub
		websiteDao.deleteWebsite(id);
	}

	public List<Website> queryParticalWebsites(Website website1) {
		// TODO Auto-generated method stub
		return websiteDao.queryParticalWebsites(website1);
	}


}
