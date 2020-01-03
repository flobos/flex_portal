import libreria.*;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var enc_pre_idn:String;
public var enc_cat_idn:String;
public var enc_ver_idn:String;
public var ultimo_encabezado:ArrayCollection;
public var encabezado:ArrayCollection = new ArrayCollection;
//*****************************************************************************************************
private function inicio():void
{	
	this.ro_encuestas.cargar_pregunta(enc_pre_idn);
}
//*****************************************************************************************************
private function result_cargar_pregunta(event:ResultEvent):void{
	
	if (event.result.length > 0)
	{
		this.ro_encuestas.busca_respuestas(this.enc_pre_idn, this.enc_ver_idn, this.enc_cat_idn);
	}
	else
	{
		mx.controls.Alert.show("No se encontró la pregunta N°" + this.enc_pre_idn,"Alerta");
	}
	
	
}
//*****************************************************************************************************
private function result_busca_respuestas(event:ResultEvent):void{
	if (event.result.length > 0)
	{
		
		this.rpt_respuestas.dataProvider = event.result;
	}
	else
	{
		mx.controls.Alert.show("No se encontró el encabezado de la pregunta N°" + this.enc_pre_idn,"Error");
	}
	
	
}

//*****************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}