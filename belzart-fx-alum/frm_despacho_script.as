import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;


private function frm_despacho_load():void
{	
//	mx.controls.Alert.show(this.parentApplication.mat_idn);
	ro_despacho.despacho_muestra(this.parentApplication.mat_idn);
}



private function no_devuelve_datos(event:Event):void
{
	mx.controls.Alert.show('No se han encontrado despachos para esta matrícula.', 'Información')
}


private function result_despacho_muestra(event:ResultEvent) :void
{
	var arreglo:Object;
	arreglo = event.result;
	
	if (arreglo.length != 0)
	{
		dt_despacho.dataProvider = arreglo;
	}
	else
	{
		no_devuelve_datos(event);
	}
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
