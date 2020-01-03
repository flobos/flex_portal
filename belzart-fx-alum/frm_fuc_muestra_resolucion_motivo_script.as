import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var num_fuc:String;
public var num_motivo:String;

private function result_muestra_resolucion_motivo(event:ResultEvent):void
{
	var arreglo:Object;
	arreglo = event.result;
	
	txt_motivo.text = arreglo[0].campo_tres;
	txt_fecha_resolucion.text = arreglo[0].campo_dos;
	txt_resolucion.text = arreglo[0].campo_uno;
	txt_consulta.text = arreglo[0].campo_cuatro;
}

private function inicio():void
{
	txt_fuc_numero.text = num_fuc;
	//mx.controls.Alert.show(lbl_fuc_numero.text)
	
	ro.muestra_resolucion_motivo(num_motivo);
}

private function nuevo_fuc():void
{
	var popup99:frm_fuc_ingreso = frm_fuc_ingreso(PopUpManager.createPopUp( this, frm_fuc_ingreso , true));
	mx.managers.PopUpManager.centerPopUp(popup99);
	
//	var popup99 = 
//	popup99 = undefined
//	popup99 = mx.managers.PopUpManager.createPopUp(this, frm_fuc_ingreso, true);
	
}

private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this)
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
