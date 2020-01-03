import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

private function inicio():void{

	ro_seguridad.muestra_paises();
	txt_usuario.restrict = "0-9\K-k"
	
	txt_usuario.setFocus();
} 
//***********************************************************************************************************
private function valida_rut(rut_temp:String):void{
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

	if (txt_usuario.length == 12)
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
		
		//mx.controls.Alert.show('Es suma ' + suma.toString() + '')
		
		resto = suma % 11
		dt = 11 - resto
		dt2 = dt.toString()
		
		//mx.controls.Alert.show('Es dt2 ' + dt2 + '')
		
		if (dt2 == '10')
		{
			if (us_rut.substr(largo-1, 1) == 'K')
			{
				is_ok = 1
				//mx.controls.Alert.show('Es K')
			}
		}

		if (dt2 == '11')
		{
			if (us_rut.substr(largo - 1, 1) == '0')
			{
				is_ok = 1
				//mx.controls.Alert.show('Es 0')
			}
		}
		
		if (dt2.substr(0, 1) == us_rut.substr(largo - 1, 1))
		{
			is_ok = 1
			//mx.controls.Alert.show('dt2 sub ' + dt2.substr(0, 1) + ' y pase poe aqui')
		}
	}
	
	if (is_ok == 0)
	{
			mx.controls.Alert.show('El R.U.T. ingresado no es valido.', 'Ingreso')
			focusManager.setFocus(txt_usuario);
	}
	
	if (is_ok == 1)
	{
			txt_clave.setFocus();
	}
	
}
//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (txt_usuario.length == 2) {
		txt_usuario.text = txt_usuario.text + '.'
		rut_temp = txt_usuario.text + '.'
		focusManager.setFocus(txt_usuario);
		txt_usuario.setSelection(txt_usuario.length,txt_usuario.length);
	}
	if (txt_usuario.length == 6) {
		txt_usuario.text = txt_usuario.text + '.'
		rut_temp = txt_usuario.text + '.'
		focusManager.setFocus(txt_usuario);
		txt_usuario.setSelection(txt_usuario.length,txt_usuario.length);
	}
	if (txt_usuario.length == 10) {
		txt_usuario.text = txt_usuario.text + '-'
		rut_temp = txt_usuario.text + '.'
		focusManager.setFocus(txt_usuario);
		txt_usuario.setSelection(txt_usuario.length,txt_usuario.length);
	}
}

//***********************************************************************************************************
private function txt_usuario_presskey(event:KeyboardEvent):void{
	var obj:Object;
	obj = cmb_paises.selectedItem;
	
	if (obj.data == '100'){
		var rut_temp:String = txt_usuario.text
		rut_temp = rut_temp.toUpperCase()
			
			if (event.charCode==13){
				valida_rut(rut_temp);
			}else{
				if (event.charCode >= 48 && event.charCode <= 57){
					puntos()
				}else{
					Keyboard.BACKSPACE
				}
			}
	}
	if (event.charCode==13){
				txt_clave.setFocus();
	}
}
//***********************************************************************************************************
private function txt_clave_presskey(event:KeyboardEvent):void{
	if (event.charCode == 13){
	btn_entrar.setFocus();
	}
}
//***********************************************************************************************************
private function devuelve_datos(event:ResultEvent):void{
	var arreglo:Object;
	
	arreglo = event.result;
	
	if (arreglo.length < 1)
	{
		mx.controls.Alert.show('No Existe', 'Información')
	}
	else
	{
		parentApplication.alu_idn = arreglo[0].data;
		parentApplication.pop_up_frm_matriculas(true)
		parentApplication.ro_alumnos_main.registro_login(arreglo[0].data);
		parentApplication.lbl_nombre.text = String(arreglo[0].label);
		parentApplication.lbl_rut.text = String(txt_usuario.text);
		
		PopUpManager.removePopUp(this);
		
	}

}
//***********************************************************************************************************
private function no_devuelve_datos(event:Event):void
{
	mx.controls.Alert.show('El R.U.T. y/o la clave ingresado no son validos.', 'Ingreso');
	btn_entrar.enabled = true;
}
//***********************************************************************************************************
private function cmb_paises_change(event:Event):void{
	var obj:Object;
	obj = cmb_paises.selectedItem
	
	if (obj.data != '100')
	{
	//	txt_usuario.restrict = ""
	}
	
	txt_usuario.setFocus();
}
//***********************************************************************************************************	
private function devuelve_datos_servicio_paises(event:ResultEvent) :void
{
	cmb_paises.dataProvider =  event.result;
	txt_usuario.setFocus();
}
//***********************************************************************************************************
private function result_devuelve_datos_seguridad_nacional(event:ResultEvent):void
{
	var arreglo1:Object;
	arreglo1 = event.result;
	
	if  (event.result.length < 1)
	{
		no_devuelve_datos(event);
	}
//	mx.controls.Alert.show(event.result.le
	else
	{
 		parentApplication.alu_idn = arreglo1[0].data;
		parentApplication.ro_alumnos_main.registro_login(arreglo1[0].data);
		var popup1:frm_matriculas = frm_matriculas(PopUpManager.createPopUp( this, frm_matriculas , true));
		mx.managers.PopUpManager.centerPopUp(popup1)

		
		var x:Number = flash.system.Capabilities.screenResolutionX/2;
		var y:Number = flash.system.Capabilities.screenResolutionY/2;
	
		var x_less:Number = popup1.width/2;
		var y_less:Number = popup1.height;
	
		popup1.x = x-x_less;
		popup1.y = y-y_less;

		parentApplication.lbl_nombre.text = String(arreglo1[0].label);
		parentApplication.lbl_rut.text = String(txt_usuario.text);

		PopUpManager.removePopUp(this);
		
	/*	var popup = mx.managers.PopUpManager.createPopUp(this, frm_popup_noticia, true);
		popup.x = x-x_less;
		popup.y = y-y_less;
		*/
	}
}
//***********************************************************************************************************
private function btn_entrar_presskey(event:KeyboardEvent):void
{
	if (event.charCode == 13)
	{
		
		if (txt_usuario.text != "")
		{
			if (txt_clave.text != "")
				if 	(cmb_paises.selectedItem.data == '100')
					{
						ro_seguridad.devuelve_datos_seguridad_nacional(txt_usuario.text,txt_clave.text);
					}
				else
					{
						ro_seguridad.devuelve_datos_alumnos_internacional(txt_usuario.text,txt_clave.text);
					}
			else
				{
						mx.controls.Alert.show('Ingrese su clave.', 'Ingreso')
						txt_clave.setFocus()
				}
				
			btn_entrar.enabled = false;
		}
		else
		{
				mx.controls.Alert.show('Ingrese Usuario', 'Ingreso')
				txt_usuario.setFocus()
		}
	
	}
}
//***********************************************************************************************************
private function btn_entrar_click(event:Event):void
{
		if 	(cmb_paises.selectedItem.data == '100')
			{
				ro_seguridad.devuelve_datos_seguridad_nacional(txt_usuario.text,txt_clave.text);
			}
		else
			{
				ro_seguridad.devuelve_datos_alumnos_internacional(txt_usuario.text,txt_clave.text);
				
			}
			btn_entrar.enabled = false;

}

private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
