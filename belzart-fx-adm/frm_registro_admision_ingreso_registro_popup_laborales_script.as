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
private var arr_laborales:ArrayCollection = new ArrayCollection;
//*******************************************************************************************************
private function inicio():void{
	var formulario:Array;
	formulario = this.parentApplication.cnv_pantalla.getChildren();	
	
	arr_laborales = formulario[0].laborales; 
	this.dg_laborales.dataProvider = arr_laborales;
	this.lbl_cargo.setFocus();
	
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
	if (this.lbl_cargo.text != "")
	{
		if (this.lbl_empresa.text != "")
		{
					var obj:obj_siete_campos = new obj_siete_campos;
					
					obj.campo_uno = "N";
					obj.campo_dos = "N";
					obj.campo_tres = this.lbl_cargo.text;
					obj.campo_cuatro = this.lbl_empresa.text;
					obj.campo_cinco = this.lbl_fecha_ingreso.text;
					obj.campo_seis = this.lbl_fecha_fin.text;
					obj.campo_siete = this.lbl_descripcion.text;
					
					this.dg_laborales.dataProvider.addItem(obj);
					this.lbl_cargo.setFocus();
		}
		else
		{
			mx.controls.Alert.show("Debe indicar una Empresa","Alerta");
			this.lbl_empresa.setFocus();
		}
	}
	else
	{
		mx.controls.Alert.show("Debe indicar un Cargo","Alerta");
		this.lbl_cargo.setFocus();
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
	
	
	formulario[0].laborales = this.dg_laborales.dataProvider;
	
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function btn_quitar_click():void
{	
	if (this.dg_laborales.selectedItem != null)
	{
		if (pantalla == "modifica"){
			if(dg_laborales.selectedItem.campo_siete == "N")
			{
				this.dg_laborales.dataProvider.removeItemAt(this.dg_laborales.selectedIndex);
			}
			else
			{
				this.dg_laborales.selectedItem.campo_cuatro = "A eliminar";	
			}
		}
		if (pantalla == "ingreso")
		{
			this.dg_laborales.dataProvider.removeItemAt(this.dg_laborales.selectedIndex);
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