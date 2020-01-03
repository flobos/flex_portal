// ActionScript file

import mx.controls.Alert;
import flash.events.KeyboardEvent;
import mx.rpc.events.*;
import mx.utils.ArrayUtil;
import mx.managers.PopUpManager;
import mx.containers.TitleWindow;
import mx.core.Application;
//***********************************************************************************************************
private function inicio():void
{
	this.txt_usuario.setFocus();
} 
//***********************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
} 
//***********************************************************************************************************
private function txt_usuario_keypress(event:KeyboardEvent):void
{
	if (event.charCode == 13)
	{
		this.txt_clave.setFocus();
	}
}
//***********************************************************************************************************
private function txt_clave_keypress(event:KeyboardEvent):void
{
	if (event.charCode == 13)
	{
		btn_ingreso.setFocus();
	}	
}
//***********************************************************************************************************
private function btn_ingreso_click():void
{
	var clave:String;
	clave = this.txt_clave.text.substring(0,2) + '-' + this.txt_clave.text.substring(2,3) + '-' + this.txt_clave.text.substring(3,6);
	ro_frm_identificacion.autentifica_funcionario(this.txt_usuario.text, clave);
}
//***********************************************************************************************************
private function btn_ingreso_keypress(event:KeyboardEvent):void
{
	var clave:String;
	if (event.charCode == 13)
	{
		clave = this.txt_clave.text.substring(0,2) + '-' + this.txt_clave.text.substring(2,3) + '-' + this.txt_clave.text.substring(3,6);
		ro_frm_identificacion.autentifica_funcionario(txt_usuario.text.toLowerCase(), clave);
		 
	}		
}
//***********************************************************************************************************
private function result_verifica_usuario(event:ResultEvent):void
{
	if(event.result.length != 0)
	{
		echoRO.sub_entidad_identificacion(String(event.result[0].campo_uno), String(event.result[0].campo_cuatro) + " " + String(event.result[0].campo_dos));
	
	}
	else
	{
		mx.controls.Alert.show("El nombre de usuario o contraseña son incorrectas. Intente ingresar nuevamente. ", "Belzart FX");	
		this.txt_usuario.selectionEndIndex;	
	}
	
}
//***********************************************************************************************************
private function result_sub_entidad_identificacion(event:ResultEvent):void
{
	
	Application.application.echoRO.return_sub_entidad_identificacion();
	//Application.application.pnl_principal.visible = true;
	PopUpManager.removePopUp(this);
	
}

	
	
