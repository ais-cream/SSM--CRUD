package packages.bean;

import java.util.HashMap;
import java.util.Map;

public class RetMes {
	//״̬��
	private int code;
	
	//��ʾ��Ϣ
	private String message;
	
	//�û�Ҫ���ظ������������
	private Map<String, Object> extend=new HashMap<String, Object>();
	
	public static RetMes success() {
		RetMes mes=new RetMes();
		mes.setCode(100);
		mes.setMessage("����ɹ�!");
		return mes;
	}
	
	public static RetMes falid() {
		RetMes mes=new RetMes();
		mes.setCode(200);
		mes.setMessage("����ʧ��!");
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
