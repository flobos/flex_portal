import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;


private function inicio():void
{
	this.dg_comunas.setFocus();
	ro_ingreso_inscripcion.muestra_comunas();
}
private function btn_seleccionar_click():void
{
	if (this.dg_comunas.selectedItem != null)
	{
		var formulario:Array;
		formulario = this.parentApplication.cnv_pantalla.getChildren();
		formulario[0].levantar_fonos(this.dg_comunas.selectedItem.label);
		PopUpManager.removePopUp(this);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un código de área","Alerta");
		this.dg_comunas.setFocus();
	}
	
}

private function result_muestra_comunas(event:ResultEvent):void
{
	this.dg_comunas.dataProvider = event.result;
}

private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);
}

private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}