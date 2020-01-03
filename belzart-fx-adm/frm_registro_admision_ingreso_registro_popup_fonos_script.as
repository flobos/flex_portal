// ActionScript file
// ActionScript file


import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;


public var cod_area:String;
private var envio_defecto:String;
//*******************************************************************************************************
private function inicio():void{

	this.lbl_cod_area.setFocus();
	this.lbl_cod_area.text = cod_area;
	var arreglo:ArrayCollection = new ArrayCollection;
	ro_ingreso_registro.muestra_tipo_telefono();
}
//*******************************************************************************************************
private function result_muestra_tipo_telefono(event:ResultEvent):void
{
	cmb_tipo_telefono.dataProvider = event.result;
}
//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function popup_codigos():void
{
	var popup:frm_codigos_area = frm_codigos_area(PopUpManager.createPopUp( this, frm_codigos_area , true));
	mx.managers.PopUpManager.centerPopUp(popup);
	PopUpManager.removePopUp(this);
}
private function btn_guardar_click():void
{	
	
	if (this.lbl_cod_area.text == "")
	{
		mx.controls.Alert.show("Debe ingresar un código de área","Alerta");
		this.lbl_cod_area.setFocus();
	}
	else if (this.lbl_numero.text == "")
	{
		mx.controls.Alert.show("Debe ingresar un número","Alerta");
		this.lbl_numero.setFocus();
	}
	else if (this.cmb_tipo_telefono.selectedIndex == 0)
	{
		mx.controls.Alert.show("Debe indicar el tipo de teléfono","Alerta");
		this.cmb_tipo_telefono.setFocus();
	}
	else
		ro_ingreso_registro.agrega_telefono(lbl_cod_area.text, lbl_numero.text, cmb_tipo_telefono.selectedIndex);
}

//*******************************************************************************************************
private function result_agrega_telefono(event:ResultEvent):void
{	
	if (event.result.length <1 )
		mx.controls.Alert.show("Ha ocurrido un error al guardar el teléfono. Intente nuevamente","Error");
	else
	{	
		var arreglo:ArrayCollection = new ArrayCollection;
	 	var o_cinco_campos:obj_cinco_campos = new obj_cinco_campos;
	 	
	 	o_cinco_campos.campo_uno = event.result[0].campo_uno;
		o_cinco_campos.campo_dos = lbl_cod_area.text;
		o_cinco_campos.campo_tres = lbl_numero.text;
		o_cinco_campos.campo_cuatro = cmb_tipo_telefono.selectedLabel;
		o_cinco_campos.campo_cinco = "Por Activar";
		
		var formulario:Array;
		formulario = this.parentApplication.cnv_pantalla.getChildren();	
		
		if (formulario[0].dg_telefonos.dataProvider != null) {
			arreglo = formulario[0].dg_telefonos.dataProvider;
		}
		arreglo.addItem(o_cinco_campos);
		formulario[0].dg_telefonos.dataProvider = arreglo;
		
		if(formulario[0].pantalla == "modifica")
			{
				formulario[0].telefonos_agregar.addItem(event.result[0].campo_uno);
			}
		
		PopUpManager.removePopUp(this);	
	}

}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}