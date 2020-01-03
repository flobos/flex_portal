// ActionScript file

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var rut_usuario:String;
//***********************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
} 
//***********************************************************************************************************
private function inicio():void
{
	echoRO.return_sub_entidad_identificacion();
}
//***********************************************************************************************************
private function result_return_sub_entidad_identificacion(event:ResultEvent):void
{
	rut_usuario=event.result[0].data
	ro_frm_main_frame.muestra_funcion(rut_usuario);
	lbl_nombre.text=event.result[0].label
}
//***********************************************************************************************************
private function result_muestra_funcion(event:ResultEvent):void
{
	cmb_funcion.dataProvider =event.result;
	
	//mx.controls.Alert.show(String(event.result[1].label))
}
//***********************************************************************************************************
private function cmb_funcion_change():void{

	ro_frm_main_frame.muestra_campus_modalidad(String(rut_usuario), String(cmb_funcion.selectedItem.data));
	Application.application.lbl_funcion.text=cmb_funcion.selectedItem.label
	btn_aceptar.enabled = false;
}
//***********************************************************************************************************
private function cmb_modalidad_change():void{

		
	/*var v_sesion_mod_func=new Object();
	v_sesion_mod_func.func_mod_fun = Number(cmb_campus_modallidad.selectedItem.data);
	servlet_func_mod.session("set", "v_sesion_mod_func", v_sesion_mod_func);	
	
	var v_sesion_mod_idn=new Object();
	v_sesion_mod_idn.mod_idn = Number(cmb_campus_modallidad.selectedItem.data2);
	servlet_mod_idn.session("set", "v_sesion_mod_idn", v_sesion_mod_idn);*/	
	
	Application.application.mod_idn=cmb_campus_modalidad.selectedItem.data2
	Application.application.func_mod_fun_idn=cmb_campus_modalidad.selectedItem.data
	
	Application.application.lbl_modalidad.text=cmb_campus_modalidad.selectedItem.label
	if(String(cmb_funcion.selectedItem.data2) == '100' || rut_usuario == '78.230.020-2')
	{
		btn_aceptar.enabled = true;
	}
	else
	{
		ro_frm_main_frame.muestra_ejecuciones_academicas(cmb_campus_modalidad.selectedItem.data);
		btn_aceptar.enabled = false;
	}	
}

//***********************************************************************************************************
private function result_muestra_ejecuciones_academicas(event:ResultEvent):void
{
	dg_ramos.dataProvider =event.result;
	//mx.controls.Alert.show("OK");
}
//***********************************************************************************************************

private function result_muestra_campus_modalidad(event:ResultEvent):void
{
	cmb_campus_modalidad.dataProvider =event.result;
	
	//mx.controls.Alert.show(String(event.result[1].label))
}
//***********************************************************************************************************
private function dg_ramos_selecciona():void
{
	if (dg_ramos.selectedItem.campo_uno!=undefined){
		btn_aceptar.enabled = true;
		Application.application.eje_aca_idn=dg_ramos.selectedItem.campo_uno
	}
	else btn_aceptar.enabled = false;
	
}
//***********************************************************************************************************
private function btn_aceptar_click():void{
	
	if (cmb_funcion.selectedIndex!=0 && cmb_campus_modalidad.selectedIndex!=0  ){
		echoRO.funcion_modalidad(cmb_campus_modalidad.selectedItem.data, cmb_campus_modalidad.selectedItem.data2)
		
		Application.application.echoRO.return_funcion_modalidad();
		Application.application.pnl_principal.visible = true;
		Application.application.iFrame.visible=true;
		PopUpManager.removePopUp(this);
	}
	else
		mx.controls.Alert.show("Antes debe seleccionar su función y luego la modalidad","Belzart FX - Ayuda");	
}

//***********************************************************************************************************


