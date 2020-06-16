package packages.bean;

import org.springframework.core.convert.converter.Converter;

public class ConvertToInt implements Converter<String,Integer>{
	{
		System.out.println("构造器");
	}
    @Override
	public Integer convert(String s) {
        try{
        	//System.out.println(s);
            return Integer.parseInt(s);
            
        }catch (Exception e){
            //System.out.println("异常了");
            return 0;
        }


    }
}
