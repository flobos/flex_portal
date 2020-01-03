import flash.events.Event;

import libreria.*;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;
public var tc_idn:String;
////**********************************************************************************************************
private function carga_foros():void
{	
	tc_idn = this.parentApplication.tc_idn;
	ro_foro_alumno.foro_muestra_activos(this.parentApplication.eje_aca_idn);
}
////**********************************************************************************************************
private function click_btn_entrar():void{
   if (lbl_foro.text != ''){
	   txt_contenido.visible = true
	   txt_contenido.editable = false
	   tl_mensajes.visible = false
	   ro_foro_alumno.foro_muestra_respuestas(lbl_foro.text)
	  		if (txt_muestra_activo.text == "0"){
				
	  	 		Envia_opinion.visible = false 
				btn_volver.visible = true
	   			btn_actualiza.visible = true
	   			btn_entrar.visible = false
	   			respuestas.visible= true
				titulo_1.text="Tema:" 
			 	titulo_2.visible=true 
	 	 }else{
	   		Envia_opinion.visible = true
	   		btn_volver.visible = true
	  		btn_actualiza.visible = true
	  		btn_entrar.visible = false
	   		respuestas.visible= true
			titulo_1.text="Tema:"
			titulo_2.visible=false
			 
	  		}
		//ro_chat_alumno.chat_verifica_bloqueo(Number(lbl_chat.text), '207120')
		}	else {
			mx.controls.Alert.show('Seleccione un tema y luego haga Clic en el botón "Entrar"')
			}
}	
////**********************************************************************************************************
private function volver():void{
	respuestas.visible= false
	txt_contenido.text = ""
 	txt_contenido.visible = false
 	lbl_foro.text=''
 	tl_mensajes.visible = true
	Envia_opinion.visible = false
	btn_volver.visible = false
	btn_actualiza.visible = false
    btn_entrar.visible = true
	titulo_1.text="Tópicos del Foro"
	cuerpo_respuestas.dataProvider =undefined
	txt_muestra_activo.text =""
	titulo_2.visible=false

}
////**********************************************************************************************************
private function getCellData():void{
	
	 lbl_foro.text = (topicos.selectedItem.campo_uno)
	 //txt_contenido.text = (topicos.selectedItem.campo_uno) + ":______"+(topicos.selectedItem.campo_dos)
 txt_contenido.text = (topicos.selectedItem.campo_dos)
}
////**********************************************************************************************************
private function ejecuta_envio():void
{
	
	var popup:frm_foro_popup_envia_opinion = frm_foro_popup_envia_opinion(PopUpManager.createPopUp( this, frm_foro_popup_envia_opinion , true));
	popup.foro = this.lbl_foro.text;
	mx.managers.PopUpManager.centerPopUp(popup)
	
}
////**********************************************************************************************************
private function ver_normas():void{
	//var popup = mx.managers.PopUpManager.createPopUp(this, frm_adm_normas_foro, true);
}
////**********************************************************************************************************




private function change_tl_foro(event:Event):void{
	var obj:Object;
	obj = event.target.selectedItem;
	lbl_foro.text = (obj.campo_uno)
	txt_contenido.text = (obj.campo_dos)
	txt_muestra_activo.text = (obj.campo_cinco)
	//mx.controls.Alert.show(obj.campo_cuatro, "Título del mensaje:" + obj.campo_tres);
}
////**********************************************************************************************************
private function actualizar():void{
	ro_foro_alumno.foro_muestra_respuestas(lbl_foro.text)
}

////**********************************************************************************************************
////**********************************************************************************************************

private function result_foro_muestra_activos(event:ResultEvent):void{

	//topicos.dataProvider = event.result
	tl_mensajes.dataProvider = event.result
	
	
	
}
////**********************************************************************************************************
private function result_foro_muestra_respuestas(event:ResultEvent):void{
	
	
	
	var arreglo:Object;
	arreglo = event.result;
	var i:Number;
	var arreglo2:ArrayCollection = new ArrayCollection();
	var y:Number;
	
	
	y=0;
	
	
	for(i = 0; i < arreglo.length; i++ )
	{
			var obj:Object = new Object();
			obj.cuerpo = arreglo[i].campo_cuatro+"/<           "+ String(arreglo[i].campo_cinco) +" :   "+ String(arreglo[i].campo_dos) +">" + String(arreglo[i].campo_tres);
			arreglo2.addItem(obj);
			
//			arreglo2.addItemAt(y, {cuerpo:   String(arreglo[i].campo_cuatro) +"/<           "+ String(arreglo[i].campo_cinco) +" :   "+ String(arreglo[i].campo_dos) +">" + String(arreglo[i].campo_tres) });
			
			
			y++;
			
		
	}
	cuerpo_respuestas.dataProvider = arreglo2;
	
	
				
}
	
	
	
	
	
	
				

private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
