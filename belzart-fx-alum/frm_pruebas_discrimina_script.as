import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

// ActionScript Document

public var tc_idn:String;
public var tipo_prueba:String;
private function carga():void{
	btn_rendir.enabled = false
	tc_idn = this.parentApplication.tc_idn;
	
	ro_pruebas.muestra_proceso_evaluativo(tc_idn);
	
//	ro_pruebas.muestra_tipo_prueba(tc_idn);
}

private function change_cmb_proceso_evaluativo():void{
	
if (this.cmb_proceso_evaluativo.selectedIndex != 0)
{
	this.cmb_proceso_evaluativo.enabled = false;
	ro_pruebas.muestra_tipo_prueba(tc_idn, this.cmb_proceso_evaluativo.selectedItem.data);
}
else
{
	this.btn_rendir.enabled = false;
}
	
	
	
}

private function change_cmd_tipo_pruebas():void{
	
	if (this.cmd_tipo_pruebas.selectedIndex != 0)
	{
		ro_pruebas.muestra_info_prueba(tc_idn , cmd_tipo_pruebas.selectedItem.data,this.cmb_proceso_evaluativo.selectedItem.data )
	}
	else
	{
		this.btn_rendir.enabled = false;
	}
	
	
	
}


private function click_btn_rendir():void{
	
if (librerias.f_trim(lbl_codigo_mod.text) == "2") {	
	tipo_prueba = cmd_tipo_pruebas.selectedItem.data;
	this.parentApplication.tipo_prueba = tipo_prueba;
	this.parentApplication.pro_eva_idn = this.cmb_proceso_evaluativo.selectedItem.data;
	this.parentApplication.moduloSeleccionado = "frm_pruebas_objetiva_rendir.mxml.swf";
//	var popup21:frm_pruebas_objetiva_rendir = frm_pruebas_objetiva_rendir(PopUpManager.createPopUp( this, frm_pruebas_objetiva_rendir , true));
//	mx.managers.PopUpManager.centerPopUp(popup21);
	
	
}else{
	this.parentApplication.moduloSeleccionado = "frm_prueba_rendir.mxml.swf";
//	var popup31:frm_prueba_rendir = frm_prueba_rendir(PopUpManager.createPopUp( this, frm_prueba_rendir , true));
//	mx.managers.PopUpManager.centerPopUp(popup31);
	
}


btn_rendir.enabled = false
cmd_tipo_pruebas.enabled = false


}

private function result_muestra_proceso_evaluativo(event:ResultEvent):void{
	
	this.cmb_proceso_evaluativo.dataProvider =  event.result;
	
}

private function result_muestra_tipo_prueba(event:ResultEvent):void{
	
cmd_tipo_pruebas.dataProvider =  event.result;

}
private function result_muestra_info_prueba(event:ResultEvent):void{
	
	if (event.result.length < 1)
	{
		mx.controls.Alert.show("No se encontro la información de la prueba", "Alerta");		
	}
	else
	{
		var arreglo:Object;
		arreglo = event.result; 
		
		lbl_entrega.text = arreglo[0].campo_uno
		lbl_disponibilidad.text  = arreglo[0].campo_dos
		lbl_modalidad.text  = arreglo[0].campo_tres
		lbl_codigo_mod.text = arreglo[0].campo_cuatro
		this.parentApplication.tiempo_prueba = arreglo[0].campo_cinco
		lbl_ponderacion.text = arreglo[0].campo_seis
		btn_rendir.enabled = true;
		
		
		this.hb_disponibilidad.visible = true;
		this.hb_fecha_entrega.visible = true;
		this.hb_modalidad.visible = true;
		this.hb_ponderacion.visible = true;
		
	}
	
}

 
 
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
