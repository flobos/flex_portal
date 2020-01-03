package
{ 
	class librerias {
	
		static function f_valida_rut(rut_temp:String, valido:Boolean){
 		var dt:Number
		var dt2:String
 		var resto:Number
 		var i:Number
 		var suma:Number
		var j:Number
	   	var is_ok:Number
		var us_rut:String 
		var largo:Number
			
		us_rut = rut_temp
		
		is_ok = 0
	
		if (rut_temp.length == 12)
		{
			j = 2
	      	suma = 0
			largo = us_rut.length
			i = us_rut.length - 2
			
					
			while(i>0) 
			{
				if (us_rut.substr(i-1, 1) != '.')
				{
					if (j > 7)
					{
						j = 2
					}
					suma = suma + Number(us_rut.substr(i-1, 1)) * j
					j = j + 1
				}
				
				i--
			}
			
			//mx.core.Application.alert('Es suma ' + suma.toString() + '')
			
			resto = suma % 11
			dt = 11 - resto
			dt2 = dt.toString()
			
			//mx.core.Application.alert('Es dt2 ' + dt2 + '')
			
			if (dt2 == '10')
			{
				if (us_rut.substr(largo-1, 1) == 'K')
				{
					is_ok = 1
					//mx.core.Application.alert('Es K')
				}
			}
	
			if (dt2 == '11')
			{
				if (us_rut.substr(largo - 1, 1) == '0')
				{
					is_ok = 1
					//mx.core.Application.alert('Es 0')
				}
			}
			
			if (dt2.substr(0, 1) == us_rut.substr(largo - 1, 1))
			{
				is_ok = 1
				//mx.core.Application.alert('dt2 sub ' + dt2.substr(0, 1) + ' y pase poe aqui')
			}
		}
		
		if (is_ok == 0)
		{
				valido = false
		}
		
		if (is_ok == 1)
		{
				valido = true
		}
			return valido
	}	
	
	
	
	
	static  function f_ltrim(matter) {
		var i:Number;
	    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) {
	        i = 0;
	        while (i<matter.length && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) {
	            i++;
	        }
	        matter = matter.substring(i);
	    } else {
	        matter = "";
	    }
	    return matter;
	}
	//***********************************************************************************************************
	static function f_rtrim(matter) {
		var i:Number;
	    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) {
	        i = matter.length-1;
	       while (i>=0 && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) {
	            i--;
	        }
	        matter = matter.substring(0, i+1);
	    } else {
	        matter = "";
	    }
	    return matter;
	}
	//***********************************************************************************************************
	static function f_trim(matter) {
	    return f_ltrim(f_rtrim(matter));
	}
	
	static function f_proper(final){
		var frase:String;
		var largo:Number;
		var contador:Number;
		var letra:String;
		//var final:String;
		var mayus:String;
		var control:String;
	
	//	mx.core.Application.alert(final)
	
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
	
	
	static function f_proper_primera_letra(final){
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
	
	}
}




