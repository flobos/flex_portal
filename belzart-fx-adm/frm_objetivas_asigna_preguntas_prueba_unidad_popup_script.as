// ActionScript file
import libreria.*;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.*;


//******************************************************************************************************
private function inicio():void
{
	ro_asigna_preguntas_prueba_unidad_popup.muestra_detalle_prueba(Application.application.cmb_tipo_prueba.selectedItem.data2);
}
//******************************************************************************************************
private function result_muestra_detalle_prueba(event:ResultEvent):void
{
	dg_detalle.dataProvider = event.result;
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
//********************************************************************************************************