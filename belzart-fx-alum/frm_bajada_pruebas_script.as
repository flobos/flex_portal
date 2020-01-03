import flash.net.FileReference;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

private var eje_aca_idn:String;
private var mat_idn:String;
private var DOWNLOAD_URL:String;

private var pb:ProgressBar;
private var btn:Button;
private var request:URLRequest; 
private var fileRef:FileReference;
//***********************************************************************************************************
private function inicio():void
{
	eje_aca_idn = this.parentApplication.eje_aca_idn;
	mat_idn = this.parentApplication.mat_idn;
	ro_bajar_pruebas_alumnos.bajada_pruebas_verifica(eje_aca_idn,mat_idn);
}
//***********************************************************************************************************
private function btn_comenzar_descarga_click(event:Event):void
{
	if(cmb_pruebas.selectedItem.data == undefined || cmb_pruebas.selectedItem.label == "-- Seleccione --" )
	{
		mx.controls.Alert.show('Debe seleccionar una Prueba del recuadro antes de presionar el boton', 'Infomación')
	}else{
		
		txt_url_archivo.text = librerias.f_trim(cmb_pruebas.selectedItem.data)
		archivo_bajada.iniciarDescarga(txt_url_archivo.text);
		
	}
}
//*********************************************************************************************
private function result_bajada_pruebas_verifica(event:ResultEvent):void
{
			cmb_pruebas.dataProvider = event.result;
			btn_comenzar_descarga.enabled = true
}
//*********************************************************************************************

private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
