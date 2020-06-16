package packages.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import packages.bean.Country;
import packages.bean.Website;
@Repository
public interface WebsiteDao {

    /**
     * 根据id查询网站信息
     *
     * @param i
     * @return
     */
    public Website queryWebsiteById(@Param("id")int i);

    /**
     * 查询所有用户信息
     *
     * @return
     */
    public List<Website> queryAllWebsites();

    /**
     * 查询国家集合
     *
     * @param i
     * @return
     */
    public List<Country> queryCountry();
    
    /**
     * 新增网站
     *
     * @param xx
     */
	public void addWebsite(@Param("name")String name,
							@Param("url")String url,
							@Param("rank")int rank,
							@Param("country")String country);
    
    

	public void updateWebsite(@Param(value = "id")Integer id, @Param(value = "website") Website website_update);
	
	/**
	 * 删除单个网站
	 * @param id
	 */
	public void deleteWebsite(Integer id);

	public List<Website> queryParticalWebsites(Website website1);
}

