// ActionScript file
import flash.events.Event;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

private function inicio():void
{
	this.btn_modificar.enabled = false;
}


private function btn_ingreso_entidad():void
{
	var i:int = 0;
	var persona_natural:Boolean = false;
	for (i = 0; i< this.dg_entidades.dataProvider.length ; i ++)
	{
		if(this.dg_entidades.dataProvider[i].campo_cuatro == "Pers. Natural")
			persona_natural = true;
	}
	
	if (persona_natural)
	{
		mx.controls.Alert.show("No puede ingresar dos personas naturales con el mismo RUT","Alerta");
	}
	else
	{
		this.parentApplication.cargar_ingreso();
		PopUpManager.removePopUp(this);
	}
}

private function dg_entidades_change(event:Event):void
{
	this.btn_modificar.enabled = true;	
}

private function btn_modificar_entidad():void
{
	this.parentApplication.lbl_buscar_registro.text = this.dg_entidades.selectedItem.campo_cinco;
	this.parentApplication.cargar_modificar(this.dg_entidades.selectedItem.campo_tres);
	PopUpManager.removePopUp(this);
}

private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);
}