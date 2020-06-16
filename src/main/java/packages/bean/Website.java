package packages.bean;

public class Website {
	@Override
	public String toString() {
		return "Website [ID=" + ID + ", name=" + name + ", url=" + url + ", rank=" + rank + ", country=" + country
				+ "]";
	}
	public int ID;
	public String name;
	public String url;
	public int rank;
	public String country;
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public int getRank() {
		return rank;
	}
	public void setRank(int rank) {
		this.rank = rank;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
}

