import flash.events.Event;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;


private var matricula:String

//***********************************************************************************************************
private function cargar_mensajes():void
{

	matricula =  this.parentApplication.mat_idn;
	ro_alumno_mensaje.muestra_mensaje_alumno(matricula, "0");
//	tl_mensajes.verticalScrollPolicy = "true";

}
//***********************************************************************************************************
private function change_tl_mensajes(event:Event):void
{
	var obj:Object;
	obj = dg_mensajes_no_leidos.selectedItem;
	
	mx.controls.Alert.show(obj.campo_cuatro, "Título del mensaje : " + obj.campo_tres);
	
	ro_alumno_mensaje.mensaje_actualiza_fecha_leido(obj.campo_ocho);
	
	ro_alumno_mensaje.muestra_mensaje_alumno(matricula, "0");
}

private function change_tl_mensajes_leidos(event:Event):void
{
	var obj:Object;
	obj = dg_mensajes_leidos.selectedItem;
	
	mx.controls.Alert.show(obj.campo_cuatro, "Título del mensaje : " + obj.campo_tres);
}

//***********************************************************************************************************
private function result_muestra_mensaje_alumno(event:ResultEvent):void
{
	dg_mensajes_no_leidos.dataProvider = event.result
}

//***********************************************************************************************************
private function result_mensaje_actualiza_fecha_leido(event:Event):void
{
}
//***********************************************************************************************************
/*
private function getCellData(model:):void
{
	var obj2:Object;
	obj2 = dg_mensajes_leidos.selectedItem;
	
	mx.controls.Alert.show(obj2.campo_cuatro, "Título del mensaje:" + obj2.campo_tres);
}
*/
//***********************************************************************************************************
private function result_tutor_mensaje_muestra_leidos(event:ResultEvent):void
{
	dg_mensajes_leidos.dataProvider = event.result
}
//***********************************************************************************************************
private function cargar_mensajes_leidos():void
{
	ro_alumno_mensaje.tutor_mensaje_muestra_leidos(matricula, "1");	
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
