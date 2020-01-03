import flash.net.URLRequest;

import libreria.*;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

private var func_mod_fun_idn:String; 
public var url_frame:URLRequest;

public function asigna_matricula (rut:String, matricula:String, carrera:String, nombre:String):void {
	txt_rut_alu.text=rut;
	txt_matricula.text=matricula;
	txt_carrera.text=carrera;
	txt_nombre_comp.text=nombre;
	txt_rut.enabled = false;
	btn_busca_rut.enabled = false;
	txt_matric.enabled = false;
	btn_busca_matricula.enabled = false;
}


private function inicio():void
{
//	ro_certificados_alumnos.muestra_certificados();
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	txt_rut.restrict = "0-9\K-k"
	
	txt_rut.setFocus();
		
	txt_matric.setFocus();
	consulta_reportes()
} 

//**********************************************
private function consulta_reportes():void
{
	ro_certificados_alumnos.rellena_combo(func_mod_fun_idn);
}
private function result_rellena_combo(event:ResultEvent):void
{
	cmb_certificados.dataProvider = event.result
}

//********************************************** Busca matriculas por rut
private function result_busca_matriculas_por_rut(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		if (event.result.length ==1)
		{
			txt_rut_alu.text=event.result[0].campo_uno;
			txt_matricula.text=event.result[0].campo_dos;
			txt_carrera.text=event.result[0].campo_tres;
			txt_nombre_comp.text=event.result[0].campo_cuatro;
			txt_rut.enabled = false;
			btn_busca_rut.enabled = false;
			txt_matric.enabled = false;
			btn_busca_matricula.enabled = false;
			cmb_certificados.enabled = true;
		} 
		else {
			
			var popup1:frm_certificados_alumnos_popup_matriculas = frm_certificados_alumnos_popup_matriculas(PopUpManager.createPopUp( this, frm_certificados_alumnos_popup_matriculas , true));
			popup1.resultado=event;
			mx.managers.PopUpManager.centerPopUp(popup1)
		}
	}
	else {
		mx.controls.Alert.show("No se encontraron matrículas para el rut ingresado","Alerta");
	}
}

//********************************************** Busca matriculas por matriculas
private function result_busca_matriculas_por_matriculas(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		if (event.result.length ==1)
		{
			txt_rut_alu.text=event.result[0].campo_uno;
			txt_matricula.text=event.result[0].campo_dos;
			txt_carrera.text=event.result[0].campo_tres;
			txt_nombre_comp.text=event.result[0].campo_cuatro;
			txt_matric.enabled = false;
			btn_busca_matricula.enabled = false;
			txt_rut.enabled = false;
			btn_busca_rut.enabled = false;
			cmb_certificados.enabled = true;
		} 
		else {
			mx.controls.Alert.show("pop","Alerta");
		}
	}
	else {
		mx.controls.Alert.show("No se encontraron matrículas para la matrícula ingresada","Alerta");
	}
}

//**********************************************
private function result(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		if (event.result.length ==1)
		{
			txt_rut_alu.text=event.result[0].campo_uno;
			txt_matricula.text=event.result[0].campo_dos;
			txt_carrera.text=event.result[0].campo_tres;
			txt_nombre_comp.text=event.result[0].campo_cuatro;
		} 
		else {
			
		}
	}
	else {
		mx.controls.Alert.show("");
	}
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
	
	if (txt_rut.length == 12)
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
		focusManager.setFocus(txt_rut);
	}
	
	if (is_ok == 1)
	{
		ro_certificados_alumnos.busca_matriculas_por_rut(txt_rut.text)
	}
	
}

//***********************************************************************************************************
private function valida_matricula(matric_temp:String):void{
	var dt:Number
	var dt2:String
	var resto:Number
	var i:Number
	var suma:Number
	var j:Number
	var is_ok:Number
	var us_matric:String 
	var largo:Number
	
	us_matric = matric_temp
	
	is_ok = 0
	
	if (txt_matric.length == 12)
	{
		j = 2
		suma = 0
		largo = us_matric.length
		i = us_matric.length - 2
		
		
		while(i>0)
		{
			if (us_matric.substr(i-1, 1) != '.')
			{
				if (j > 7)
				{
					j = 2
				}
				suma = suma + Number(us_matric.substr(i-1, 1)) * j
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
			if (us_matric.substr(largo-1, 1) == 'K')
			{
				is_ok = 1
				//mx.controls.Alert.show('Es K')
			}
		}
		
		if (dt2 == '11')
		{
			if (us_matric.substr(largo - 1, 1) == '0')
			{
				is_ok = 1
				//mx.controls.Alert.show('Es 0')
			}
		}
		
		if (dt2.substr(0, 1) == us_matric.substr(largo - 1, 1))
		{
			is_ok = 1
			//mx.controls.Alert.show('dt2 sub ' + dt2.substr(0, 1) + ' y pase poe aqui')
		}
	}
	
	if (is_ok == 0)
	{
		mx.controls.Alert.show('La matrícula ingresada no es valida.', 'Ingreso')
		focusManager.setFocus(txt_matric);
	}
	
	if (is_ok == 1)
	{
		ro_certificados_alumnos.busca_matriculas_por_matriculas(txt_matric.text)
	}
	
}


//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}

//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (txt_rut.length == 2) {
		txt_rut.text = txt_rut.text + '.'
		rut_temp = txt_rut.text + '.'
		focusManager.setFocus(txt_rut);
		txt_rut.setSelection(txt_rut.length,txt_rut.length);
	}
	if (txt_rut.length == 6) {
		txt_rut.text = txt_rut.text + '.'
		rut_temp = txt_rut.text + '.'
		focusManager.setFocus(txt_rut);
		txt_rut.setSelection(txt_rut.length,txt_rut.length);
	}
	if (txt_rut.length == 10) {
		txt_rut.text = txt_rut.text + '-'
		rut_temp = txt_rut.text + '.'
		focusManager.setFocus(txt_rut);
		txt_rut.setSelection(txt_rut.length,txt_rut.length);
	}
}
//***********************************************************************************************************
private function buscar_rut():void{
	var rut_temp:String = txt_rut.text
	rut_temp = rut_temp.toUpperCase()
	
	valida_rut(rut_temp);
}
//***********************************************************************************************************
private function buscar_matricula():void{
	if (txt_matric.length != 11)
	{
		mx.controls.Alert.show("Debe ingresar una matrícula válida", 'Ingreso');	
	}
	else
	{
		ro_certificados_alumnos.busca_matriculas_por_matriculas(txt_matric.text)
	}
	
}
//***********************************************************************************************************
private function txt_rut_presskey(event:KeyboardEvent):void{
var rut_temp:String = txt_rut.text
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
//***********************************************************************************************************

public function btn_nueva_busqueda_click():void
{
	txt_matric.text = "";
	txt_matric.enabled = true;
	btn_busca_matricula.enabled = true;
	txt_rut.text = "";
	txt_rut.enabled = true;
	btn_busca_rut.enabled = true;
	txt_rut_alu.text= "";
	txt_matricula.text= "";
	txt_carrera.text= "";
	txt_nombre_comp.text= "";
	cmb_certificados.selectedIndex = 0;
	cmb_certificados.enabled = false;
}	
	
private function carga_informe():void
{
	
	if (cmb_certificados.selectedItem.data != "0")
	{
		url_frame = new URLRequest("http://192.168.1.10/reportes_flex_net/"+this.cmb_certificados.selectedItem.data+"?mat_idn=" + txt_matricula.text + "&func_mod_fun_idn="+func_mod_fun_idn); 
		navigateToURL(url_frame, "_blank"); 
	}
}	

