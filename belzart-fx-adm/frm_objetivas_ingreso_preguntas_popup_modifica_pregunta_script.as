// ActionScript file


import libreria.*;

import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;

public var url_frame:URLRequest;
public var cod_pregunta:String;
public var archivo_imagen:String;
public var ServerResponse:String;
public var ServerResponseRaw:String;
public var uploadURL:String;
public var uploadFOLDER:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 
//*******************************************************************************************************
private function inicio():void{
	cod_pregunta = parentApplication.cod_pregunta;
	getProperties();
	this.addEventListener(UploadEvent.UPLOAD_EVENT, uploadEventHandler);
}

//******************************************************************************************************
private function btn_guardar_click():void
{
	var item:Object=rp_alternativas.dataProvider;
	var x:int;
	var alt:String;
	var op_alt:String;
	
	if( txt_pregunta.length>1 && txt_pauta.length>1) //si se han completado todos los campos
	{
		alt='';
		op_alt='0'
		for( x = 0; x < item.length && alt=='' ; x++ )
		{
			if (txt_respuesta[x].text=='')
				alt=String(x+1); //si encuentra una alternativa vacia asigna el indice de la misma al string alt.
			if (opt_correcta[x].selected==true)
				op_alt='1'; //flag que marca 1 cuando encuentra una alternativa correcta seleccionada
		}
		
		if (alt=='') //si es una pregunta objetiva que tiene todas sus alternativas
		{
			if (op_alt=='1') //si es una pregunta objetiva que tiene todas sus alternativas y una es correcta
			{
				mx.controls.Alert.show("¿Realmente desea realizar los cambios a la pregunta?", "Cambio pregunta", 3, this, alertClickHandler);
			}
			else //si es una pregunta objetiva que no tiene alternativa seleccionada.
				mx.controls.Alert.show("Antes de realizar la operacion de guardar debe marcar la alternativa correcta", "Ayuda");
		}
		else	//si es una pregunta objetiva que no tiene todas sus alternativas
		{			
			mx.controls.Alert.show("La alternativa '" + alt + "' se encuentra incompleta, no se puede efectuar la operacion Guardar", "Ayuda")
		}
	}
	else //si no se han completado todos los campos
		mx.controls.Alert.show("Existen campos sin completar necesarios para poder efectuar la operacion de guardar", "Ayuda")
}

//******************************************************************************************************
private function alertClickHandler(event:CloseEvent):void {
  	var mod_ejecuciones:String;
  	if (event.detail==Alert.YES){
		if(chk_mod_eje_aca.selected== true) {
			mod_ejecuciones = '1';
		}
		else {
			mod_ejecuciones = '0';
		}
	//	archivo_imagen = "";
		if (this.progressBar.label.indexOf(".jpg",0) != -1)
		{
			if (this.progressBar.label != archivo_imagen)
			{	
				archivo_subida.iniciarSubida(uploadURL+"?folder=" + txt_codigo.text);
				archivo_imagen = this.progressBar.label;
			}
		}
		if (this.archivo_imagen == null)
		{
			archivo_imagen = "";
		}
		
		ro_modifica_preguntas.modifica_pregunta(txt_codigo.text, txt_tipo.text, txt_pregunta.text, txt_pauta.text, '', mod_ejecuciones,archivo_imagen );
    }
    	
}

//******************************************************************************************************
private function modifica_respuesta():void
{
	var x:int;
	var correcta:String;
	var mod_ejecuciones:String;
	
	if(chk_mod_eje_aca.selected== true) {
		mod_ejecuciones = '1';
		}
	else {
		mod_ejecuciones = '0';
		}
	
	for( x = 0; x < rp_alternativas.dataProvider.length ; x++ )
	{
		if (opt_correcta[x].selected==true)
			correcta='1';
		else
			correcta='0';
		ro_modifica_preguntas.modifica_respuesta(lbl_alternativa[x].text, txt_pregunta.text, txt_respuesta[x].text, correcta, '',mod_ejecuciones)
	}
	mx.controls.Alert.show("Modificación Realizada","Información");
	btn_cancelar_click();	
		
}

//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}
//*****************************************************************************************************
private function mostrar_imagen(event:Event):void {
	if (this.img_pregunta.source != null && this.img_pregunta.source.toString().indexOf("sin_imagen.jpg") < 1) {
		url_frame = new URLRequest(this.img_pregunta.source.toString());
		navigateToURL(url_frame, "_blank");
	}
}
//*****************************************************************************************************
///////////////////////////////////////////funciones subida de archivo///////////////////////////////
private function click_btn_examinar():void{
archivo_subida.examinar()
}
//*****************************************************************************************************
private function uploadEventHandler(event:UploadEvent):void {
			ServerResponse = event.ServerResponse;
			ServerResponseRaw = event.ServerResponseRaw;
}
//*****************************************************************************************************
private function getProperties():void {
			servicePropReader = new HTTPService();
			servicePropReader.url = "assets/properties.xml";		
			servicePropReader.resultFormat = "e4x";					
			servicePropReader.contentType = "application/xml";

			servicePropReader.addEventListener(ResultEvent.RESULT, propertyReaderResultHandler);
			servicePropReader.send();								
		}
//*****************************************************************************************************
private function propertyReaderResultHandler(event:ResultEvent):void {
			xmlProperties = XML(event.result);

			uploadURL = xmlProperties.property.(name=="UploadURL").value;
			uploadFOLDER = xmlProperties.property.(name=="UploadFOLDER").value;
		}	


