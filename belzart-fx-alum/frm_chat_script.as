import flash.utils.setInterval;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

private var eje_aca_idn:String;
private var tc_idn:String;
////**********************************************************************************************************
private function carga_chat():void
{
	eje_aca_idn = this.parentApplication.eje_aca_idn;
	ro_chat_alumno.chat_muestra_todos_segun_fecha(eje_aca_idn); 
	ro_chat_alumno.chat_muestra_nombre_tutor(eje_aca_idn);
	
	tc_idn = this.parentApplication.tc_idn;
	
}
////**********************************************************************************************************
private function click_btn_entrar():void{
	
    lbl_chat.text = cmb_chat.selectedItem.data
	lbl_chat_activo.text= cmb_chat.selectedItem.data2
	lbl_chat_sube.text= cmb_chat.selectedItem.data3
	
	if (lbl_chat_activo.text== '0' ) {
		
		mx.controls.Alert.show('Este Chat Se Activará el día    ' + lbl_chat_sube.text  +"      ");
		
		}else{
		ro_chat_alumno.chat_activa_usuario(Number(lbl_chat.text), tc_idn)
		
		ro_chat_alumno.chat_verifica_bloqueo(Number(lbl_chat.text), tc_idn)
	
	
	//actualiza_verificacion_bloqueo()
		}
}
//-----------------------------------------------------
private function click_btn_envia():void{
	
	var texto_html:String

//texto_html = "<FONT SIZE=" + chr(39) + "10" + chr(39) + " COLOR=" + chr(39) + "#FF0000" + chr(39) + "><B>" + txt_texto.text + "</B></FONT>"
//<FONT SIZE="3" COLOR="#FF0000"><B></B></FONT>
//mx.controls.Alert.show(texto_html)
//"<FONT SIZE=" + chr(39) + "3" + chr(39) + "<B>" + txt_texto.text + "</B></FONT>"
	
	ro_chat_alumno.chat_inserta_conversacion(Number(lbl_cod_alumno.text), txt_texto.text)
	ro_chat_alumno.chat_muestra_conversacion(Number(lbl_chat.text))	
	txt_texto.text='';
	txt_texto.setFocus();
	txt_conversacion_alumnos.validateNow();
	txt_conversacion_alumnos.verticalScrollPosition = txt_conversacion_alumnos.maxVerticalScrollPosition;
	
}
//-----------------------------------------------------

private function result_chat_muestra_todos_segun_fecha(event:ResultEvent):void{

	cmb_chat.dataProvider = event.result
	
	
}
//-----------------------------------------------------
private function result_chat_muestra_nombre_tutor(event:ResultEvent):void{

	//txt_nombre_tutor.dataProvider = event.result
	
	
	var arreglo6:Object;
	arreglo6 = event.result;
/*				
	if (arreglo6[0].campo_uno != undefined){
		
		txt_nombre_tutor.text = ": " + arreglo6[0].campo_uno +" "+ arreglo6[0].campo_dos +" "+ arreglo6[0].campo_tres
		
		
	   }else {
		 mx.controls.Alert.show(arreglo6[0].campo_uno,'ERROR')
		}
	*/
	if (arreglo6.length > 0){
		
		txt_nombre_tutor.text = ": " + arreglo6[0].campo_uno +" "+ arreglo6[0].campo_dos +" "+ arreglo6[0].campo_tres
		
		
	   }else {
		 mx.controls.Alert.show("No se encontró el nombre del Tutor",'ERROR')
		}
}


//-----------------------------------------------------

private function result_chat_activa_usuario(event:ResultEvent):void{
	var arreglo1:Object;
	arreglo1 = event.result;
				
	if (arreglo1.length > 0 ){
		
		lbl_cod_alumno.text = arreglo1[0].campo_uno
		ro_chat_alumno.chat_muestra_usuarios_activos(Number(lbl_chat.text))
	   }else {
		 mx.controls.Alert.show("No se puede activar el usuario",'ERROR')
		}
}
//-----------------------------------------------------
private function result_chat_muestra_usuarios_activos(event:ResultEvent):void{
	dg_alumnos.dataProvider = event.result
}
//-----------------------------------------------------
private function result_chat_inserta_conversacion(event:ResultEvent):void{
	
	var arreglo1:Object;
	arreglo1 = event.result
				
	if (arreglo1[0].data == '1'){
		
		ro_chat_alumno.chat_muestra_conversacion(Number(lbl_chat.text))
		txt_texto.text=''
			     
   }else{
	
		mx.controls.Alert.show(arreglo1[0].label)
	}
}
//function result_chat_muestra_conversacion(event){
	//tl_chat.dataProvider = event.result
   //txt_conversacion_alumnos.text ='' 
//}

/*function result_chat_muestra_conversacion(event){

	var arreglo_11:Array
	var conjunto_conversaciones:Array
	
	arreglo_11 = event.result;
	
	if (event.result == undefined)
	{
	mx.controls.Alert.show('No Existe')
	}
	else
	{ 
	limpia()
	
	for( var i = 0; i < arreglo_11.length; i++ ){
	
	txt_conversacion_alumnos.text =  txt_conversacion_alumnos.text + String(arreglo_11[i].campo_dos + ' ' + arreglo_11[i].campo_tres)
	 //mx.controls.Alert.show(arreglo_11[i].campo_uno,'hola')
	}
	}
}*/
//-----------------------------------------------------
private function result_chat_muestra_conversacion(event:ResultEvent):void{

	var arreglo_11:Object;
	var conjunto_conversaciones:Array
	
	arreglo_11 = event.result;
	
	if (arreglo_11.length == 0)
	{
		mx.controls.Alert.show('No Existe')
	}
	else
	{ 
	limpia()
	
	txt_conversacion_alumnos.text =  arreglo_11[0].campo_uno
	
	 //mx.controls.Alert.show(arreglo_11[i].campo_uno,'hola')
	 
	}
}
//-----------------------------------------------------
private function result_chat_muestra_conversacion_tutor(event:ResultEvent):void{

	var arreglo_11:Object;
	var conjunto_conversaciones:Array
	
	arreglo_11 = event.result;
	
	if (arreglo_11.length == 0)
	{
		mx.controls.Alert.show('No Existe')
	}
	else
	{ 
		
	txt_profesor.text =  arreglo_11[0].campo_uno
	
	 //mx.controls.Alert.show(arreglo_11[i].campo_uno,'hola')
	}
}
//-----------------------------------------------------
private function verifica_enter(event:KeyboardEvent):void{
	
	if (event.charCode==13){
		
		click_btn_envia()
		
	}
}
//-----------------------------------------------------
private function limpia():void{
	
	//txt_texto.text=''
	txt_conversacion_alumnos.text=''
	
}

private function actualiza_conversacion_alumnos():void{
    setInterval(actualiza_ahora,10000);
 //  	setInterval(this,"actualiza_ahora",10000);               
}               
//-----------------------------------------------------  
private function actualiza_ahora():void {                   
//	result_chat_muestra_todos_segun_fecha()
	ro_chat_alumno.chat_muestra_conversacion(Number(lbl_chat.text))	
	if (lbl_chat.text!="0"){
	 	ro_chat_tutor.chat_muestra_conversacion_tutor(Number(lbl_chat.text))
	}
	
	txt_conversacion_alumnos.validateNow();
	txt_conversacion_alumnos.verticalScrollPosition = txt_conversacion_alumnos.maxVerticalScrollPosition;
	
	txt_profesor.validateNow();
	txt_profesor.verticalScrollPosition = txt_profesor.maxVerticalScrollPosition;
	 //mx.controls.Alert.show('funciona')
	 ro_chat_alumno.chat_actualiza_bloqueo(Number(lbl_chat.text), tc_idn)
}          
//-----------------------------------------------------
private function salir_chat():void {
    ro_chat_alumno.chat_desactiva_usuario(Number(lbl_chat.text), tc_idn)
    btn_envia.enabled = false;
    txt_conversacion_alumnos.text = "";
    txt_profesor.text = "";
    txt_nombre_tutor.text = "";
    txt_texto.enabled = false;
    
	mx.controls.Alert.show("Ha salido del chat");
    //this.unloadMovie()
}
//-----------------------------------------------------
private function result_chat_desactiva_usuario(event:Event):void{
	ro_chat_alumno.chat_muestra_usuarios_activos(Number(lbl_chat.text))
			  
}
//-----------------------------------------------------
private function color_azul():void{
	
	tw_ventana.setStyle("borderStyle","solid")
	tw_ventana.setStyle("backgroundColor","#0000FF") 
}
//-----------------------------------------------------
private function color_rojo():void{
	
	tw_ventana.setStyle("borderStyle","solid")
	tw_ventana.setStyle("backgroundColor","#FF0000") 
}
//-----------------------------------------------------
private function color_verde():void{
	
	tw_ventana.setStyle("borderStyle","solid")
	tw_ventana.setStyle("backgroundColor","#008001") 
}
//-----------------------------------------------------
private function color_blanco():void{
	
	tw_ventana.setStyle("borderStyle","solid")
	tw_ventana.setStyle("backgroundColor","#FFFFFF") 
}
//-----------------------------------------------------
private function actualiza_verificacion_bloqueo():void{
	
	
	}
//-----------------------------------------------------
private function result_chat_verifica_bloqueo(event:ResultEvent):void{
	
	var arreglo_14:Object;
	arreglo_14 = event.result;
	
	if (arreglo_14.length == 0)
		
	{
		mx.controls.Alert.show('No Existe Bloqueo');
	}
	else
	{ 
		
		txt_bloqueo.text= arreglo_14[0].campo_uno
		if (txt_bloqueo.text != '1'){
		 
			cv_chat.enabled = true
			cmb_chat.enabled = false
			btn_entrar.enabled = false
			lbl_chat.text = cmb_chat.selectedItem.data
			txt_texto.setFocus()
			ro_chat_alumno.chat_activa_usuario(Number(lbl_chat.text), tc_idn)
			ro_chat_alumno.chat_muestra_conversacion(Number(lbl_chat.text))
			ro_chat_tutor.chat_muestra_conversacion_tutor(Number(lbl_chat.text))
//			txt_profesor.verticalScrollPosition=300
			txt_profesor.verticalScrollPolicy="on"
			actualiza_conversacion_alumnos()
		}
		else 
		{		
			mx.controls.Alert.show('Bloqueo Existente');
			salir_chat()
		}
		 
	} 
}
//-----------------------------------------------------
private function result_chat_actualiza_bloqueo(event:ResultEvent):void{
	
	var arreglo_15:Object;
	arreglo_15 = event.result;
		if (arreglo_15.length == 0)
	{
		mx.controls.Alert.show('No Existe');
	}
	else
	{ 
		
	txt_bloqueo.text= arreglo_15[0].campo_uno
		
	rebloqueo()
	 		
	}
}
//-----------------------------------------------------
private function rebloqueo():void{
	 if (txt_bloqueo.text != '1'){
		 
		
	 }
	 else 
	 {		
	 	mx.controls.Alert.show('Bloqueado', 'Información');
		 salir_chat()
	 }
}

//**********************

	//<mx:method name="chat_muestra_usuarios_activos" result="result_chat_muestra_usuarios_activos(event)" fault="mx.controls.Alert.show(event.fault.faultstring, 'Error')"/>
  	

private function mensaje_muestra():void{
	cmb_chat.toolTip=(cmb_chat.selectedItem.label)
	
	}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
