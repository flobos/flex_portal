// ActionScript file
import libreria.*;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import flash.net.URLRequest;


private var func_mod_fun_idn:String;
private var mod_cam_idn:String;
public var url_frame:URLRequest;
//******************************************************************************************************
private function inicio():void
{
	this.cmb_ejecuciones.enabled = false;
	this.cmb_est_pru.enabled = false;
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	ro_informes_academicos.obtiene_modalidad_campus(func_mod_fun_idn);
	
}
//***********************************************************************************************************
private function result_obtiene_modalidad_campus(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		this.mod_cam_idn = event.result[0].campo_uno;
	}
	else
	{
		mx.controls.Alert.show("No se pudo obtener la modalidad del campus","Error");
	}
}
//******************************************************************************************************
private function radiogroup_changeHandler(event:Event):void
{
	ro_informes_academicos.muestra_ejecuciones(mod_cam_idn);
	if (r3.selected == true)
	{
		ro_informes_academicos.muestra_tipo_prueba();
	}
	this.radiogroup.enabled = false;
}
//******************************************************************************************************
private function ver_informe():void
{
	var eje_idn:String;
	var est_pru_idn:String;
	
	
	
	if (this.cmb_ejecuciones.selectedItem != null)
	{
		eje_idn = this.cmb_ejecuciones.selectedItem.data;
		if (r1.selected == true)
		{
			url_frame = new URLRequest("http://164.77.193.133/reportes_flex_net/frm_reporte_acta_rendimiento_academico.aspx?eje_idn=" + eje_idn);
			navigateToURL(url_frame, "_blank");
		}
		if (r2.selected == true)
		{
			url_frame = new URLRequest("http://164.77.193.133/reportes_flex_net/frm_nomina_notas_cursos.aspx?eje_idn="+ eje_idn);
			navigateToURL(url_frame, "_blank");
		}
		if (r4.selected == true)
		{
			url_frame = new URLRequest("http://164.77.193.133/reportes_flex_net/frm_reporte_base_datos_general_notas.aspx?eje_idn="+ eje_idn);
			navigateToURL(url_frame, "_blank");
		}
		if (r3.selected == true)
		{
			est_pru_idn = this.cmb_est_pru.selectedItem.data;
			url_frame = new URLRequest("http://164.77.193.133/reportes_flex_net/frm_resumen_stado_notas_x_tipo_prueba_ejecucion.aspx?eje_idn="+eje_idn+"&est_pru_idn="+est_pru_idn);
			navigateToURL(url_frame, "_blank");
			
			
		}
		
	}
}
//******************************************************************************************************
private function result_muestra_ejecuciones(event:ResultEvent):void
{
	cmb_ejecuciones.enabled = true;
	cmb_ejecuciones.dataProvider = event.result;
}
//******************************************************************************************************
private function result_muestra_tipo_prueba(event:ResultEvent):void
{
	cmb_est_pru.enabled = true;
	cmb_est_pru.dataProvider = event.result;
}
//******************************************************************************************************
private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//*******