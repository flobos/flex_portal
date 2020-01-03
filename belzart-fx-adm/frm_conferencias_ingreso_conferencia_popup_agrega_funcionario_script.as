// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

private var func_mod_fun_idn:String;
private var mod_cam_idn:String;
//*******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = this.parentApplication.func_mod_fun_idn;
	ro_ingreso_conferencia.buscar_modalidad_campus(func_mod_fun_idn);
}
//*******************************************************************************************************
private function result_buscar_modalidad_campus(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontró la modalidad del campus","ERROR");
		btn_cancelar_click();
	}
	else
	{
		mod_cam_idn = event.result[0].campo_uno;
	}
}
//*******************************************************************************************************
private function lbl_apellido_change():void{
	if (this.lbl_apellido_paterno.text != ""){
		ro_ingreso_conferencia.busca_funcionarios_por_apellido(this.lbl_apellido_paterno.text, mod_cam_idn);
	}
	else
	{
		this.dg_funcionarios.dataProvider = null;
	}
}
//*******************************************************************************************************
private function btn_seleccionar_click():void{
	if (this.dg_funcionarios.selectedItem != null)
	{
		this.parentApplication.txt_fun_codigo.text = this.dg_funcionarios.selectedItem.campo_uno;
		this.parentApplication.txt_fun_rut.text = this.dg_funcionarios.selectedItem.campo_dos;
		this.parentApplication.txt_fun_nombre.text = this.dg_funcionarios.selectedItem.campo_tres;
		this.parentApplication.txt_fun_funcion.text = this.dg_funcionarios.selectedItem.campo_cuatro;
		this.parentApplication.btn_agrega_funcionario.enabled = false;
		this.parentApplication.btn_quitar_funcionario.enabled = true;
		this.parentApplication.ro_ingreso_conferencia.muestra_ejecuciones_tutor(this.dg_funcionarios.selectedItem.campo_uno);
		this.parentApplication.chk_eje_tutor.selected = false;
		this.parentApplication.chk_eje_tutor.enabled = true;
		btn_cancelar_click();
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un funcionario", "Alerta");
	}
}
//*******************************************************************************************************
private function btn_buscar_click():void{
	if (this.lbl_funcionario.text != ""){
		ro_ingreso_conferencia.busca_funcionarios(this.lbl_funcionario.text, mod_cam_idn);
	}
	else
	{
		this.dg_funcionarios.dataProvider = null;
	}
}
//***********************************************************************************************************
private function result_busca_funcionarios(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		this.dg_funcionarios.dataProvider = null;
		mx.controls.Alert.show("No se han encontrado funcionarios con el parámetro indicado","Alerta");
	}
	else
	{
		this.dg_funcionarios.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
