import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

// ActionScript Document
public var mat_idn:String;
//***********************************************************************************************************
private function inicio():void
{
	mat_idn = this.parentApplication.mat_idn;
	ro_calendarios.ro_carga_eje_aca_por_toma(mat_idn);
}
//***********************************************************************************************************
private function result_datos_carga_eje_aca_por_toma(event:ResultEvent):void
{
	cmb_eje_aca.dataProvider = event.result;
}
//***********************************************************************************************************
//***********************************************************************************************************
private function result_datos_carga_fechas_foro_sincronico(event:ResultEvent):void{
	dg_foros_sincronicos.dataProvider = event.result;
}
//***********************************************************************************************************
private function result_datos_carga_fechas_foro_Asincronico(event:ResultEvent):void{
	
	dg_foros_Asincronicos.dataProvider = event.result;
	
}
//***********************************************************************************************************
//***********************************************************************************************************
private function cmb_eje_aca_change(event:Event):void
{
	dg_fecha_notas.dataProvider = undefined;
	dg_biblio_aca.dataProvider = undefined;
	dg_foros_sincronicos.dataProvider = undefined;
	dg_foros_Asincronicos.dataProvider = undefined;
		
	ro_calendarios.ro_carga_fechas_notas_toma(mat_idn, cmb_eje_aca.selectedItem.data);
	ro_calendarios.ro_carga_fechas_bibliotecas_academicas(cmb_eje_aca.selectedItem.data);
	
	ro_calendarios.ro_carga_fechas_foro_sincronico(mat_idn, cmb_eje_aca.selectedItem.data);
	ro_calendarios.ro_carga_fechas_foro_Asincronico(mat_idn, cmb_eje_aca.selectedItem.data);
	
}
//***********************************************************************************************************
private function result_datos_carga_fechas_notas_toma(event:ResultEvent):void
{
	dg_fecha_notas.dataProvider = event.result;
}
//***********************************************************************************************************
private function result_datos_carga_fechas_bibliotecas_academicas(event:ResultEvent):void
{
	dg_biblio_aca.dataProvider = event.result;
}
//***********************************************************************************************************
private function btn_imprimir_click(event:Event):void
{
	var url :URLRequest = new URLRequest('http://164.77.193.131:8100/cfusion/ipxcf/cf_flex_reporte_calendario_academico.cfm?mat_idn=' + String(mat_idn));
		navigateToURL(url, "_blank");
	
//	getURL('http://164.77.193.131:8100/cfusion/ipxcf/cf_flex_reporte_calendario_academico.cfm?mat_idn=' + String(mat_idn) , "_blank");
}

/////********************************

private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
