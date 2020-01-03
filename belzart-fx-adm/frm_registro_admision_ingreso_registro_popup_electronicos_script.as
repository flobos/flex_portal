// ActionScript file


import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

private function cmb_tipo_contacto_change():void
{
	if (cmb_tipo_contacto.selectedIndex > 0)  
	{
		lbl_detalle.enabled = true
		this.lbl_detalle.setFocus();
		if (cmb_tipo_contacto.selectedLabel == 'email')
		{
			emailValidator.source = lbl_detalle; 
		}
		this.cmb_tipo_contacto.enabled = false;
	}
	else
	{
		lbl_detalle.text = "";
		lbl_detalle.enabled = false;
	}
}

private function validarEmail():Boolean { 
		//camputamos los valores de cada validador 
		
	var validarEmail:ValidationResultEvent =emailValidator.validate(); 
		
		//verificamos si todos cumplen
		if (validarEmail.type == ValidationResultEvent.VALID ) 
		{
			return true;
		} else { 
			return false;
		} 
		
}

private var envio_defecto:String;
//*******************************************************************************************************
private function inicio():void{

	this.cmb_tipo_contacto.setFocus();
	var arreglo:ArrayCollection = new ArrayCollection;
	ro_ingreso_registro.muestra_tipo_contacto();
}
//*******************************************************************************************************
private function result_muestra_tipo_contacto(event:ResultEvent):void
{
	cmb_tipo_contacto.dataProvider = event.result;
}
//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}

private function btn_guardar_click():void
{	
	if (this.cmb_tipo_contacto.selectedLabel == 'email')
	{
		if (validarEmail())
		{
			if (this.lbl_detalle.text == "")
				mx.controls.Alert.show("Debe ingresar el detalle de contacto","Alerta");
			else if (this.cmb_tipo_contacto.selectedIndex == 0)
				mx.controls.Alert.show("Debe indicar el tipo de contacto","Alerta");
			else
				ro_ingreso_registro.agrega_contacto(lbl_detalle.text, cmb_tipo_contacto.selectedIndex);
		}
		else
		{
			mx.controls.Alert.show("La dirección ingresada no es válida. Ubique el cursor sobre el cuadro de texto para ver el error.","Error");
		}
	}
	else
	{
		if (this.lbl_detalle.text == "")
			mx.controls.Alert.show("Debe ingresar el detalle de contacto","Alerta");
		else if (this.cmb_tipo_contacto.selectedIndex == 0)
			mx.controls.Alert.show("Debe indicar el tipo de contacto","Alerta");
		else
			ro_ingreso_registro.agrega_contacto(lbl_detalle.text, cmb_tipo_contacto.selectedIndex);
	}
	
}

//*******************************************************************************************************
private function result_agrega_contacto(event:ResultEvent):void
{	
	if (event.result.length <1 )
		mx.controls.Alert.show("Ha ocurrido un error al guardar el contacto. Intente nuevamente","Error");
	else
	{	
		var arreglo:ArrayCollection = new ArrayCollection;
	 	var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
	 	
	 	o_cuatro_campos.campo_uno = event.result[0].campo_uno;
		o_cuatro_campos.campo_dos = lbl_detalle.text;
		o_cuatro_campos.campo_tres = cmb_tipo_contacto.selectedLabel
		o_cuatro_campos.campo_cuatro = "Por Activar";
		
		var formulario:Array;
		formulario = this.parentApplication.cnv_pantalla.getChildren();	
			
		if (formulario[0].dg_electronicos.dataProvider != null) {
			arreglo = formulario[0].dg_electronicos.dataProvider;
		}
		arreglo.addItem(o_cuatro_campos);
		formulario[0].dg_electronicos.dataProvider = arreglo;
		
		if(formulario[0].pantalla == "modifica")
			formulario[0].electronicos_agregar.addItem(event.result[0].campo_uno);
		
		PopUpManager.removePopUp(this);	
	}

}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}
