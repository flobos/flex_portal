// ActionScript file
import flash.net.URLRequest;

import libreria.*;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.*;


private var func_mod_fun_idn:String;
private var mod_cam_idn:String;
private var rut_usuario:String;

public var url_frame:URLRequest;
//******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	rut_usuario = Application.application.parameters.par_rut;
	
}
//***********************************************************************************************************
private function btn_ver_informe_click():void{
	if(this.txt_matricula.length != 11)
	{
		mx.controls.Alert.show("Ingrese una matrícula válida","Alerta");
	}
	else
	{
		this.txt_matricula.enabled = false;
		if (rut_usuario == '78.230.020-2')
		{
			this.ro_informes_academicos.comprueba_matricula(this.txt_matricula.text, this.func_mod_fun_idn, '1');
		}
		else
		{
			this.ro_informes_academicos.comprueba_matricula(this.txt_matricula.text, this.func_mod_fun_idn, '0');	
		}
		
	}
}

private function btn_nuevo_click():void
{
	this.txt_matricula.text = "";
	this.txt_matricula.enabled = true;
}
//***********************************************************************************************************
private function result_comprueba_matricula(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		ver_informe();
	}
	else
	{
		mx.controls.Alert.show("No se encontró la matrícula para la modalidad del campus","Alerta");
	}
}
//******************************************************************************************************
private function ver_informe():void
{
		url_frame = new URLRequest("http://192.168.1.10/reportes_flex_net/frm_informe_estado_cuenta_matricula.aspx?mat_idn=" + this.txt_matricula.text);
		navigateToURL(url_frame, "_blank");
			
}
//******************************************************************************************************
private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//*******