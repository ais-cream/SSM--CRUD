package packages.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import packages.bean.Country;
import packages.bean.Website;
@Repository
public interface WebsiteDao {

    /**
     * ����id��ѯ��վ��Ϣ
     *
     * @param i
     * @return
     */
    public Website queryWebsiteById(@Param("id")int i);

    /**
     * ��ѯ�����û���Ϣ
     *
     * @return
     */
    public List<Website> queryAllWebsites();

    /**
     * ��ѯ���Ҽ���
     *
     * @param i
     * @return
     */
    public List<Country> queryCountry();
    
    /**
     * ������վ
     *
     * @param xx
     */
	public void addWebsite(@Param("name")String name,
							@Param("url")String url,
							@Param("rank")int rank,
							@Param("country")String country);
    
    

	public void updateWebsite(@Param(value = "id")Integer id, @Param(value = "website") Website website_update);
	
	/**
	 * ɾ��������վ
	 * @param id
	 */
	public void deleteWebsite(Integer id);

	public List<Website> queryParticalWebsites(Website website1);
}

