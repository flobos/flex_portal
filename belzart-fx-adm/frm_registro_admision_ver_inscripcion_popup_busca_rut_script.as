// ActionScript file


import flash.events.KeyboardEvent;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var ent_idn:String;


//*******************************************************************************************************
private function inicio():void{

	
	ro_ver_inscripcion.busca_inscripciones(this.ent_idn);
	
}
//*******************************************************************************************************
private function result_busca_inscripciones(event:ResultEvent):void
{
	if (event.result.length> 0)
	{
		dg_inscripciones.dataProvider = event.result;	
		this.dg_inscripciones.setFocus();
	}
	else
	{
		mx.controls.Alert.show("No se encontraron inscripciones","Alerta");
	}
	
}

private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}

//*******************************************************************************************************

private function btn_seleccionar_click():void
{
	if (this.dg_inscripciones.selectedItem != null)
	{
		this.parentApplication.carga_inscripcion(this.dg_inscripciones.selectedItem.campo_uno);	
		PopUpManager.removePopUp(this);	
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una inscripción","Alerta");
	}
	
}	
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}