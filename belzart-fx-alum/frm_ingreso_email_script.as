// ActionScript file
import flash.events.Event;
import flash.events.TextEvent;

import libreria.*;

import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.ValidationResultEvent;
import mx.managers.*;
import mx.rpc.events.*;

public var alu_idn:String;

private function validarEmail():Boolean { 
	//camputamos los valores de cada validador 
	var validarEmail:ValidationResultEvent =emailValidator.validate(); 
	
	//verificamos si todos cumplen
	if (validarEmail.type == ValidationResultEvent.VALID ) 
	{
		return true;
	} else { 
		return false;
	} 
} 

private function btn_guardar_click():void{

	this.btn_guardar.enabled = false;
	
	if ((this.lbl_email_usuario.text == this.lbl_email_usuario_verif.text))
	{
		if (validarEmail())
		{
			this.lbl_email_usuario.enabled = false;
			this.lbl_email_usuario_verif.enabled = false;
			this.ro_alumnos_main.guardar_email(this.alu_idn,this.lbl_email_usuario.text)
		}
		else
		{
			mx.controls.Alert.show("La dirección ingresada no es válida. Ubique el cursor sobre el cuadro de texto para ver el error.","Error");
			this.btn_guardar.enabled = true;
		}
	}
	else
	{
		mx.controls.Alert.show("Las direcciones no coinciden","Alerta");
		this.btn_guardar.enabled = true;
	}
	
			
	
}


private function result_guardar_email(event:ResultEvent):void{
	if (event.result.length > 0)
	{
		if (event.result[0].campo_uno.length > 3)
		{
			mx.controls.Alert.show("Su correo electrónico fue guardado exitosamente.","Información");
			this.btn_guardar.enabled = false;
			this.btn_cerrar.enabled = true;
		}
		else
		{
			mx.controls.Alert.show("Ha ocurrido un error al guardar su correo electrónico. Por favor intente nuevamente.","Error");
		}
	}
	else
	{
		mx.controls.Alert.show("Ha ocurrido un error en el servidor. Por favor intente nuevamente.","Error");
		
	}
}


private function click_btn_cerrar():void{
	
	PopUpManager.removePopUp(this)
	
}

//***********************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}