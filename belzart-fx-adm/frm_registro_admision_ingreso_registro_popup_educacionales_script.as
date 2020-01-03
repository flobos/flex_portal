// ActionScript file
// ActionScript file


import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.controls.TextInput;

public var pantalla:String;
private var arr_educacionales:ArrayCollection;
//*******************************************************************************************************
private function inicio():void{
	this.lbl_nombre.setFocus();
	var formulario:Array;
	formulario = this.parentApplication.cnv_pantalla.getChildren();	
	
	arr_educacionales = formulario[0].educacionales; 
	this.dg_educacionales.dataProvider = arr_educacionales;
	
	ro_ingreso_registro.muestra_tipo_educacional();
}
//******************************************************************************************************
private function mayusculas(texto:TextInput):void
{
	var texto_final:String;
	if (texto.text.length > 0)
	{
		texto_final = texto.text.toUpperCase();
		texto.text = texto_final;
	}
}
//*******************************************************************************************************
private function btn_agregar_click():void
{	
	if (this.lbl_nombre.text != "")
	{
		if (this.lbl_institucion.text != "")
		{
			if (this.lbl_fecha_ingreso.text != "")
			{
				if(this.lbl_fecha_egreso.text != "")
				{
					var obj:obj_ocho_campos = new obj_ocho_campos;
					
					obj.campo_uno = this.lbl_nombre.text;
					obj.campo_dos = this.lbl_institucion.text;
					obj.campo_tres = this.cmb_tipo.selectedItem.data;
					obj.campo_cuatro = this.cmb_tipo.selectedItem.label;
					obj.campo_cinco = this.lbl_fecha_ingreso.text;
					obj.campo_seis = this.lbl_fecha_egreso.text;
					obj.campo_siete = "N";
					obj.campo_ocho = "N";
					
					this.dg_educacionales.dataProvider.addItem(obj);
					this.lbl_nombre.setFocus();
				}
				else
				{
					mx.controls.Alert.show("Debe indicar una Fecha de Egreso","Alerta");
					this.lbl_fecha_egreso.setFocus();
				}
			}
			else
			{
				mx.controls.Alert.show("Debe indicar una Fecha de Ingreso","Alerta");
				this.lbl_fecha_ingreso.setFocus();
			}
		}
		else
		{
			mx.controls.Alert.show("Debe indicar una Institución","Alerta");
			this.lbl_institucion.setFocus();
		}
	}
	else
	{
		mx.controls.Alert.show("Debe indicar un Nombre / Título","Alerta");
		this.lbl_nombre.setFocus();
	}
}
//*******************************************************************************************************
private function result_muestra_tipo_educacional(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron tipos de antecedente educacional.","Error");
		btn_cancelar_click();
	}
	else
	{
		this.cmb_tipo.dataProvider = event.result;
	}
}
//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}

//*******************************************************************************************************
private function btn_guardar_click():void
{	
	var formulario:Array;
	formulario = this.parentApplication.cnv_pantalla.getChildren();	
	
	
	formulario[0].educacionales = this.dg_educacionales.dataProvider;
	
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function btn_quitar_click():void
{	
	if (this.dg_educacionales.selectedItem != null)
	{
		if (pantalla == "modifica"){
			if(dg_educacionales.selectedItem.campo_siete == "N")
			{
				this.dg_educacionales.dataProvider.removeItemAt(this.dg_educacionales.selectedIndex);
			}
			else
			{
				this.dg_educacionales.selectedItem.campo_cuatro = "A eliminar";	
			}
		}
		if (pantalla == "ingreso")
		{
			this.dg_educacionales.dataProvider.removeItemAt(this.dg_educacionales.selectedIndex);
		}
		
	}
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}
//******************************************************************************************************

private function formatea_fecha(date:Date):String {
	return dfconv.format(date);
} 