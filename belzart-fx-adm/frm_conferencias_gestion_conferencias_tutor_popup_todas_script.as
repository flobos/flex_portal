// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

private var func_mod_fun_idn:String;
//*******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = this.parentApplication.func_mod_fun_idn;
	ro_gestion_conferencias.muestra_conferencias_total(func_mod_fun_idn);
}
//***********************************************************************************************************
private function result_muestra_conferencias_total(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		this.dg_conferencias.dataProvider = event.result;
	}
	else
	{
		mx.controls.Alert.show("No se encontraron conferencias asociadas","Alerta");
		btn_cancelar_click();
	}
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
