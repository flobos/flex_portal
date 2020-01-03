import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

private var v_mat_idn:String; 
private var v_eje_idn:String

private function tw_creationComplete():void{
	tw_pretomas.enabled = true;
	v_mat_idn = this.parentApplication.mat_idn;
	ro_pretoma.pretoma_valida_pretoma_abierta(v_mat_idn)

}


private function result_pretoma_valida_pretoma_abierta(event:ResultEvent):void{
	

var arreglo100:Object;
	arreglo100 = event.result; 
	
	if (arreglo100.length < 1){
	
		mx.controls.Alert.show('No hay proceso de pretoma abierto en estos momentos o usted ya pretomo ramos para esta ejecucion.','MENSAJE' )	
		
		tw_pretomas.visible = false
	}
	else{
		v_eje_idn = arreglo100[0].campo_tres

		lbl_codigo_pretoma.text = arreglo100[0].campo_uno

		lbl_mensaje.text = "Para ejecucion: " + arreglo100[0].campo_cuatro + ". Con fecha de generacion: " + dfconv.format(arreglo100[0].campo_dos) + "."
		
		ro_pretoma.pretoma_muestra(v_mat_idn, v_eje_idn);
	}
	
}

private function result_pretoma_muestra(event:ResultEvent):void{
	
	
	rpt_pretomas.dataProvider = event.result

}


private function btn_validar_click():void{
var arreglo_pretomas:Object;
var arreglo_pretomas_aceptadas:ArrayCollection = new ArrayCollection;
var conta:Number
var i:Number
var j:Number
conta = 0

arreglo_pretomas = rpt_pretomas.dataProvider

	for(i = 0; i < arreglo_pretomas.length ; i++)
	{
	
		if (lbl_situacion[i].text == '101') {
	   		cb_pretomas[i].selected = true
		}
	}
	
	for(j = 0; j < arreglo_pretomas.length ; j++)
	{
	
		if (cb_pretomas[j].selected == true) {
			
	   		var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	   		o_dos_campos.data = lbl_codigo_producto_pretoma[j].text;
	   		o_dos_campos.label = cb_pretomas[j].label;
//	   		arreglo_pretomas_aceptadas.addItemAt({codigo: String(lbl_codigo_producto_pretoma[j].text),nombre: String(cb_pretomas[j].label)},conta);
			arreglo_pretomas_aceptadas.addItem(o_dos_campos);
			conta++ 
		}
	
	}
	
	if (conta > 0){
	
	var popup2:frm_pretoma_alumno_popup_pretomas = frm_pretoma_alumno_popup_pretomas(PopUpManager.createPopUp( this, frm_pretoma_alumno_popup_pretomas , true));
	

	
	popup2.arreglo_pretomas_verifica = arreglo_pretomas_aceptadas
	popup2.codigo_pretoma_verifica = lbl_codigo_pretoma.text
	
	mx.managers.PopUpManager.centerPopUp(popup2);
//			
	}else{
		
	mx.controls.Alert.show('No hay ramos para pretomar seleccionados en la lista superior.','ERROR' )	
	}

}

private function btn_aceptar_click():void{
	




}





private function f_devuelve_obligatorio(codigo:String, valor_final:Boolean ):Boolean {


	
		if (codigo == '101')
		{
			valor_final = true;
		}
		else
		{
			valor_final = false;
		}

	return valor_final;
}


private function f_devuelve_enabled(codigo:String, valor_final:Boolean ):Boolean {
	
		if (codigo == '101')
		{
			valor_final = false;
		}
		else
		{
			valor_final = false;
		}

	return valor_final;
}

private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
