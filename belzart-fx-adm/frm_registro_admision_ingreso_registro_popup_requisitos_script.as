// ActionScript file



import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var pantalla:String;
public var arreglo:ArrayCollection;
private var arr_requisitos:ArrayCollection;
private var envio_defecto:String;
//*******************************************************************************************************
private function inicio():void{
	this.dg_disponibles.setFocus();
	var formulario:Array;
	formulario = this.parentApplication.cnv_pantalla.getChildren();	
	
	arr_requisitos = formulario[0].requisitos; 
	this.dg_asignados.dataProvider = arr_requisitos;
	this.ro_ingreso_registro.muestra_requisitos();
	this.ro_ingreso_registro.muestra_prioridad();
}
//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function btn_agregar_click():void
{	
	if (this.dg_disponibles.selectedItem != null)
	{
		var obj:obj_ocho_campos = new obj_ocho_campos;
		
		obj.campo_uno = "N";
		obj.campo_dos = this.dg_disponibles.selectedItem.data;
		obj.campo_tres = this.dg_disponibles.selectedItem.label;
		obj.campo_cuatro = "Por ingresar";
		obj.campo_cinco = this.ns_duracion.value.toString();
		obj.campo_seis = this.ns_cantidad.value.toString();
		obj.campo_siete = this.cmb_prioridad.selectedItem.data;
		obj.campo_ocho = this.cmb_prioridad.selectedItem.label;
		
		this.dg_asignados.dataProvider.addItem(obj);
		
	}
}
//*******************************************************************************************************
private function btn_guardar_click():void
{	
	var formulario:Array;
	formulario = this.parentApplication.cnv_pantalla.getChildren();	
	
	
	formulario[0].requisitos = this.dg_asignados.dataProvider;
	
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function btn_quitar_click():void
{	
	if (this.dg_asignados.selectedItem != null)
	{
		if (pantalla == "modifica"){
			if(dg_asignados.selectedItem.campo_uno == "N")
			{
				this.dg_asignados.dataProvider.removeItemAt(this.dg_asignados.selectedIndex);
			}
			else
			{
				this.dg_asignados.selectedItem.campo_cuatro = "A eliminar";	
			}
		}
		if (pantalla == "ingreso")
		{
			this.dg_asignados.dataProvider.removeItemAt(this.dg_asignados.selectedIndex);
		}
		
	}
}
//*******************************************************************************************************
private function result_muestra_requisitos(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron requisitos","Error");
	else
	{	
		this.dg_disponibles.dataProvider = event.result;
	}
}
//*******************************************************************************************************
private function result_muestra_prioridad(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron prioridades","Error");
	else
	{	
		this.cmb_prioridad.dataProvider = event.result;
	}
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}