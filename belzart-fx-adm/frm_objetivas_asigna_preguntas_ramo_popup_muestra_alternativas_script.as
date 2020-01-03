// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.core.Application;

//******************************************************************************************************
private var cod_pregunta:String
//******************************************************************************************************
private function inicio():void
{
	
	cod_pregunta=Application.application.cod_pregunta_popup;
	
	ro_alternativas.busca_respuesta(cod_pregunta);
}
//******************************************************************************************************
private function result_busca_respuesta(event:ResultEvent):void
{
	
	rp_alternativas.dataProvider=event.result;
	var item:Object=rp_alternativas.dataProvider;
	var x:int;

	for( x = 0; x < 5 ; x++ )
	{
		if (item[x].campo_tres=='1')
			opt_correcta[x].selected=true;
	}
}
//*******************************************************************************************************
private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************