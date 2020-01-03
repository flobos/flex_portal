// ActionScript file
import flash.events.KeyboardEvent;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var det_ope_idn:String; 

//***********************************************************************************************************
private function inicio():void
{
	this.ro_pagos.muestra_glosa(det_ope_idn);
}

//******************************************************************************************************
private function result_muestra_glosa(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("No existe glosa para esta operación");
	else{
		this.dg_glosa.dataProvider = event.result;
		this.ro_pagos.muestra_medios(det_ope_idn);
	}
}
//******************************************************************************************************
private function result_muestra_medios(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No existen medios de pago para esta operacion");
	}
	else{
		this.dg_medios_pago.dataProvider = event.result;
		
	}
}
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}