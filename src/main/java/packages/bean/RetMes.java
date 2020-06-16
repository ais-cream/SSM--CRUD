package packages.bean;

import java.util.HashMap;
import java.util.Map;

public class RetMes {
	//状态码
	private int code;
	
	//提示信息
	private String message;
	
	//用户要返回给浏览器的数据
	private Map<String, Object> extend=new HashMap<String, Object>();
	
	public static RetMes success() {
		RetMes mes=new RetMes();
		mes.setCode(100);
		mes.setMessage("处理成功!");
		return mes;
	}
	
	public static RetMes falid() {
		RetMes mes=new RetMes();
		mes.setCode(200);
		mes.setMessage("处理失败!");
		return mes;
	}
	
	public RetMes add(String string,Object object) {
		this.getExtend().put(string, object);
		return this;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Map<String, Object> getExtend() {
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
	
	
}
