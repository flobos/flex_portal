package
{ 
	import mx.controls.Alert;
	import mx.rpc.events.*;
	import mx.utils.ArrayUtil;
	
	public class fx_librerias
	{
	//***********************************************************************************************************
	public static function f_proper(final:String):String
	{
		var frase:String;
		var largo:Number;
		var contador:Number;
		var letra:String;
		var mayus:String;
		var control:String;

		frase = f_trim(final);
		largo = frase.length;
		 
		final = "";
		for(contador=1; contador<=largo; contador++)
		{
			letra = frase.substr((contador-1),1);
			if(contador == 1)
			{
				letra = letra.toUpperCase();
				final = final.concat(letra);
			}
			else
			{
				if(letra == " ")
				{
					mayus = frase.substr((contador),1);
					mayus = mayus.toUpperCase();
					final = final.concat(letra,mayus);
				}
				else
				{
					control = frase.substr((contador-2),1)
					if(control != " ")
					{
						final = final.concat(letra);
					}
				}
			}
		}
		return final;
	}
	//***********************************************************************************************************
	public static function f_proper_primera_letra(final:String):String
	{
		var frase:String;
		var largo:Number;
		var contador:Number;
		var letra:String;

		frase = f_trim(final);
		largo = frase.length;
		final = "";
		for(contador=1; contador<=largo; contador++)
		{
			letra = frase.substr((contador-1),1);
			if(contador == 1)
			{
				letra = letra.toUpperCase();
			}
			final = final.concat(letra);
		}
		return final;
	}
	//***********************************************************************************************************
	public static function f_ltrim(matter:String):String
	{
		var i:Number;
	    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) 
	    {
        	i = 0;
	        while (i<matter.length && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) 
	        {
            	i++;
	        }
        	matter = matter.substring(i);
	    } 
	    else 
	    {
	    	matter = "";
    	}
    	return matter;
	}
	//***********************************************************************************************************
	public static function f_rtrim(matter:String):String
	{
		var i:Number;
	    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) 
	    {
	    	i = matter.length-1;
	      	while (i>=0 && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) 
	      	{
	            i--;
	        }
	        matter = matter.substring(0, i+1);
	    } 
	    else 
	    {
	        matter = "";
	    }
	    return matter;
	}
	//***********************************************************************************************************
	public static function f_trim(matter:String):String
	{
    	return f_ltrim(f_rtrim(matter));
	}
	//***********************************************************************************************************
	public static function f_returnIndex(matter:Array,valor:int):int
	{
		//como usar
		//cb_combobox.selectedIndex = fx_librerias.f_returnIndex(ArrayUtil.toArray(cb_combobox.dataProvider), int(event.result[0].campo));
		
		var i:int; 
		
		for(i=0;i<matter[0].length;i++)
		{
			if(String(matter[0][i].data) == String(valor))
			{
				valor = i;
			
				i = matter[0].length + 1;
			}
		}	
		return valor;
	}
	//***********************************************************************************************************
	}
}