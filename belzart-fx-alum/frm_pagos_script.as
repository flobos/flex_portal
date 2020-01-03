import flash.events.Event;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var url_frame:URLRequest;
private var mat_encriptada:String;

private function frm_pagos_load():void
{
	ro_pagos.pagos_muestra(this.parentApplication.mat_idn);
}

private function no_devuelve_datos(event:Event):void{

mx.controls.Alert.show('No se han encontrado pagos para esta matrícula.','Pagos')
}
private function btn_pagos_click(event:Event):void{
		url_frame = new URLRequest("http://www.iplacex.cl/bchile_pagos/pago_bchile.asp?paridmt=a1sdsf34sdf89wfwfw95xgfjl&mt="+ this.parentApplication.mat_idn + "&parimat3=asdewulbkjbvxiuweqyrwetoixcnmpoixyi15568dsa");
		//url_frame = new URLRequest("http://192.168.1.127:8401/paginas/pago_bchile.asp?paridmt=a1sdsf34sdf89wfwfw95xgfjl&mt="+ this.parentApplication.mat_idn + "&parimat3=asdewulbkjbvxiuweqyrwetoixcnmpoixyi15568dsa");
		navigateToURL(url_frame, "_blank");
}
private function result_pagos_muestra(event:ResultEvent):void {

	var arreglo:Object;
	arreglo = event.result;
	if (arreglo.length < 1)
		{
			no_devuelve_datos(event);
		}
	else
		{	
			dt_pagos.dataProvider = arreglo;
		}
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
