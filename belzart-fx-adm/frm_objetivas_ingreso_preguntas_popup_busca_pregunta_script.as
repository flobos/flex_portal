// ActionScript file


import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;

public var Cantidad_Respuestas:String;
public var uploadFOLDER:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 
public var url_frame:URLRequest;

//*******************************************************************************************************
private function inicio():void{
	var criterio_buscar:Array = new Array();
	criterio_buscar.push({data:1, label:"Código"});
	criterio_buscar.push({data:2, label:"Pregunta"});
	criterio_buscar.push({data:3, label:"Pauta"});
		
	cmb_buscar_por.dataProvider = criterio_buscar
	ro_ingreso_preguntas_popup.muestra_tipo_pregunta();
	getProperties();
}
//*******************************************************************************************************
private function result_muestra_tipo_pregunta(event:ResultEvent):void
{
	cmb_tip_pregunta.dataProvider = event.result;
}
//*******************************************************************************************************
private function result_busca_pregunta(event:ResultEvent):void
{
	var arreglo_vacio:ArrayCollection = new ArrayCollection;
	var o_tres_campos:obj_tres_campos = new obj_tres_campos;
	
		o_tres_campos.campo_uno = '';
		o_tres_campos.campo_dos = '';
		o_tres_campos.campo_tres = '';
		arreglo_vacio.addItem(o_tres_campos);
	
	dg_preguntas.dataProvider=event.result;
	
	rp_alternativas.dataProvider = arreglo_vacio;
}
//*******************************************************************************************************
private function btn_buscar_click():void
{
	var tip_preg_idn:String;
	var seleccion:ArrayCollection = new ArrayCollection;
	if (cmb_tip_pregunta.selectedIndex<1) 
		tip_preg_idn="0";
	else
		tip_preg_idn=String(cmb_tip_pregunta.selectedIndex); 
	
	ro_ingreso_preguntas_popup.busca_pregunta(	String(cmb_buscar_por.selectedItem.data),
												txt_criterio.text,
												tip_preg_idn,
												parentApplication.func_mod_fun_idn );
}
//******************************************************************************************************
private function result_busca_respuesta(event:ResultEvent):void
{
	
	rp_alternativas.dataProvider=event.result;
	var item:Object=rp_alternativas.dataProvider;
	var x:int;

	
	for( x = 0; x < rp_alternativas.dataProvider.length ; x++ )
	{
		if (item[x].campo_tres=='1')
			opt_correcta[x].selected=true;
	}
}
//******************************************************************************************************
private function busca_respuestas():void
{	
	if (this.dg_preguntas.selectedItem.campo_siete!= null) {
		this.img_pregunta.source = uploadFOLDER + this.dg_preguntas.selectedItem.campo_uno + "/" + this.dg_preguntas.selectedItem.campo_siete;
	}
	else{
		this.img_pregunta.source = uploadFOLDER + "sin_imagen.jpg"
	}
	ro_ingreso_preguntas_popup.busca_respuesta(this.dg_preguntas.selectedItem.campo_uno);
}
//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function btn_modificar_click():void
{	
	var x:Number;
	var ind:Number;
	
	if(rp_alternativas.dataProvider.length < 3){
		mx.controls.Alert.show("Debe seleccionar una pregunta.","Alerta");
	}
	else
	{	
		
		for( x = 0; x < rp_alternativas.dataProvider.length  ; x++ )
		{
			if (this.opt_correcta[x].selected == true){
				ind = x;
			}
		}
		
		
		parentApplication.cod_pregunta = dg_preguntas.selectedItem.campo_uno;
		var popup_modifica:frm_objetivas_ingreso_preguntas_popup_modifica_pregunta = frm_objetivas_ingreso_preguntas_popup_modifica_pregunta(PopUpManager.createPopUp( this, frm_objetivas_ingreso_preguntas_popup_modifica_pregunta , true));
		popup_modifica.txt_codigo.text = dg_preguntas.selectedItem.campo_uno;
		popup_modifica.txt_pauta.text = dg_preguntas.selectedItem.campo_cinco;
		popup_modifica.txt_pregunta.text = dg_preguntas.selectedItem.campo_dos;
		popup_modifica.txt_tipo.text = dg_preguntas.selectedItem.campo_tres;
		popup_modifica.rp_alternativas.dataProvider = this.rp_alternativas.dataProvider;
		popup_modifica.opt_correcta[ind].selected = true;
		popup_modifica.img_pregunta.source = this.img_pregunta.source;
		popup_modifica.progressBar.label = this.dg_preguntas.selectedItem.campo_siete;
		popup_modifica.archivo_imagen = this.dg_preguntas.selectedItem.campo_siete;
		mx.managers.PopUpManager.centerPopUp(popup_modifica);
		btn_cancelar_click();
		

	}
}
//******************************************************************************************************
private function btn_seleccionar():void
{

	var item:Object = rp_alternativas.dataProvider;
	var x:int;
	
	if (this.dg_preguntas.selectedItem == null){ //modificado: this.dg_preguntas.selectedItem.campo_uno no activa la alerta
		mx.controls.Alert.show('Debe seleccionar una pregunta de la lista','Ayuda')
	}
	else
	{	
		parentApplication.txt_pregunta.text= (this.dg_preguntas.selectedItem.campo_dos)		
		parentApplication.txt_pauta.text= (this.dg_preguntas.selectedItem.campo_cinco)
		parentApplication.lbl_codigo_pregunta.text= (this.dg_preguntas.selectedItem.campo_uno)
		parentApplication.cmb_tip_pregunta.selectedIndex=initCombobox(parentApplication.cmb_tip_pregunta, this.dg_preguntas.selectedItem.campo_tres)
		parentApplication.NS_CantRes.value = rp_alternativas.dataProvider.length 

		var arreglo:ArrayCollection = new ArrayCollection;
		
		for( x = 0; x < rp_alternativas.dataProvider.length  ; x++ )
		{
			var o_tres_campos:obj_tres_campos = new obj_tres_campos;
			o_tres_campos.campo_uno = "-";
			o_tres_campos.campo_dos = "";
			o_tres_campos.campo_tres = "0";
			arreglo.addItem(o_tres_campos);
		}
		parentApplication.rp_alternativas.dataProvider=arreglo;	

//		agregar la pregunta seleccionada al rp_preguntas_seleccionadas		
		
		var arre_preg_asigna:ArrayCollection = new ArrayCollection;//ag
		var preg_ingresada:int = 0;
		
		//si existen preguntas seleccionadas verifica que no se repitan
		if (parentApplication.rp_preguntas_seleccionadas.dataProvider != undefined) {
			arre_preg_asigna = parentApplication.rp_preguntas_seleccionadas.dataProvider;
		
			
			for( x = 0; x < arre_preg_asigna.length ; x++ ){
				if ( arre_preg_asigna[x].campo_dos == this.dg_preguntas.selectedItem.campo_uno )
					preg_ingresada = 1;
			}
		}
		
		// si no existe, agrega la pregunta al listado de seleccionadas 
		if ( preg_ingresada == 0 ){
			var o_cuatro_campos_resp:obj_cuatro_campos = new obj_cuatro_campos;
			this.cmb_tip_pregunta.selectedIndex = this.dg_preguntas.selectedItem.campo_tres;
			o_cuatro_campos_resp.campo_uno = this.dg_preguntas.selectedItem.campo_seis;//this.dg_preguntas.selectedItem.campo_uno;
			o_cuatro_campos_resp.campo_dos = this.dg_preguntas.selectedItem.campo_uno;
			o_cuatro_campos_resp.campo_tres = this.dg_preguntas.selectedItem.campo_dos;
			o_cuatro_campos_resp.campo_cuatro = this.cmb_tip_pregunta.selectedLabel;
			arre_preg_asigna.addItem(o_cuatro_campos_resp);
		}
		else {
			mx.controls.Alert.show("La pregunta ha sido seleccionada previamente", "Ayuda");
		}
				
		parentApplication.rp_preguntas_seleccionadas.dataProvider = arre_preg_asigna;


		//
		var o_tres_campos_obj:obj_tres_campos = new obj_tres_campos;
		if (this.dg_preguntas.selectedItem.campo_tres == '1')
		{
			parentApplication.tw_alternativas.enabled=true;
			for( x = 0; x < rp_alternativas.dataProvider.length ; x++ )
			{
				parentApplication.txt_respuesta[x].text=item[x].campo_dos
				parentApplication.lbl_cod_alternativa[x].text=item[x].campo_uno
				if (item[x].campo_tres=='1')
					parentApplication.opt_correcta[x].selected=true;
			}
		}
		else
		{
			
			parentApplication.tw_alternativas.enabled=false;
			for( x = 0; x < rp_alternativas.dataProvider.length ; x++ )
			{
				parentApplication.txt_respuesta[x].text=''
				parentApplication.lbl_cod_alternativa[x].text=''
				if (x==0)
					parentApplication.opt_correcta[x].selected=true;
			}
		}
		parentApplication.txt_pregunta.setFocus()
		PopUpManager.removePopUp(this);		
		
		
	}
}



//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}

//******************************************************************************************************
private function txt_criterio_keyDown(event:KeyboardEvent):void
{
	if (event.keyCode == Keyboard.ENTER)
	{
		btn_buscar_click();
	}
}

//*******************************************************************************************************
private function initCombobox(obj:Object,texto:String):int
{
	var x:int;
	
	
	for(var i:int=0;i<obj.dataProvider.length;i++)
	{
		var texto_combo:String = obj.dataProvider[i].data;
		if(texto_combo == texto){
			x=i;
//			break; quitado el 22 de abril por cmedina
		}
	}
	return x;
}
//******************************************************************************************************
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

			uploadFOLDER = xmlProperties.property.(name=="UploadFOLDER").value;
		}	
//*****************************************************************************************************
private function mostrar_imagen(event:Event):void {
	if (this.img_pregunta.source != null && this.img_pregunta.source.toString().indexOf("sin_imagen.jpg") < 1) {
		url_frame = new URLRequest(this.img_pregunta.source.toString());
		navigateToURL(url_frame, "_blank");
	}
}
