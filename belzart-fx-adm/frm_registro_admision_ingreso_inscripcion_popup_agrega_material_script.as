// ActionScript file
// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
//*******************************************************************************************************
private function inicio():void
{

}

//******************************************************************************************************
private function buscar_materiales():void
{	
	if (this.lbl_nombre.text ==""){
		this.dg_materiales.dataProvider = null;
	}
	else {
		ro_ingreso_inscripcion.busca_materiales(this.lbl_nombre.text);	
	}
}
//******************************************************************************************************
private function result_busca_materiales(event:ResultEvent):void
{
	this.dg_materiales.dataProvider = event.result;
}
//******************************************************************************************************
private function btn_agregar_click():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	if (this.dg_materiales.selectedItem != null)
	{	
		o_dos_campos.data = dg_materiales.selectedItem.data;
		o_dos_campos.label = dg_materiales.selectedItem.label;
		arreglo.addItem(o_dos_campos);
		if (this.parentApplication.tn_productos.selectedChild.dg_material_apoyo.dataProvider == null)
		{
			this.parentApplication.tn_productos.selectedChild.dg_material_apoyo.dataProvider = arreglo;
		}
		else
		{
			this.parentApplication.tn_productos.selectedChild.dg_material_apoyo.dataProvider.addItem(o_dos_campos);
		}
		PopUpManager.removePopUp(this);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un Material","Alerta");
	}
}

//*******************************************************************************************************

private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}