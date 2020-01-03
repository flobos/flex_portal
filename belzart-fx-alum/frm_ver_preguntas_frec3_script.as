import flash.events.Event;
import flash.events.KeyboardEvent;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

private var alu_idn:String;
private var tipo_producto:String;
////**********************************************************************************************************
private function result_muestra_idn_tema(event:ResultEvent):void{
	var arreglo1:Object;
	arreglo1 = event.result
	if (arreglo1.length > 0){
		if (librerias.f_trim(arreglo1[0].data) != '0'){
		txt_codigo_modalidad.text=arreglo1[0].data
	
		tipo_producto = this.parentApplication.tip_idn;
		txt_codigo_tip_prod.text=(tipo_producto)
		abrir_automatico()
		}
	}
	else{
		mx.controls.Alert.show("No existen Temas asociados", "Información");
	}
}
///________________________________________________________________
private function inicio():void
{
	alu_idn = this.parentApplication.alu_idn;
	ro_pregunta_frec.muestra_idn_tema(alu_idn)
	ro_pregunta_frec.pregunta_muestra_tema('1');

}
///********************************************************
private function btn_abrir_click(event:Event):void
{
	//getURL('http://192.168.1.172:8101/cfusion/ipxcf/muestra_temas.cfm?modalidad=' + txt_codigo_modalidad.text + '&tip_producto=' + txt_codigo_tip_prod.text + '', '_blank');
}
//__________________________________________
private function abrir_automatico():void
{
	//getURL('http://192.168.1.172:8101/cfusion/ipxcf/muestra_temas.cfm?modalidad=' + txt_codigo_modalidad.text + '&tip_producto=' + txt_codigo_tip_prod.text + '', '_blank');
}
/////********************* *******************************
private function selecciona_tema():void{
	
	dg_preguntas.dataProvider = ""
	dg_respuestas.dataProvider=""
	txt_respuesta.text=""
	txt_tema.text = cmb_tema.selectedItem.data		
}

////**********************************************************************************************************
//__________________________________________________________________
private function getCellData_pregunta_asocia(model:Boolean):void{
	
	dg_respuestas.dataProvider=""
	txt_respuesta.text=""
	txt_pregunta.text = dg_preguntas.selectedItem.data
	//txt_pregunta_texto.text = (dg_preguntas.selectedItem.label)
	
	cargar()
}
///
//__________________________________________________________________
private function result_pregunta_muestra_tema(event:ResultEvent):void{
	cmb_tema.dataProvider = event.result;
}

/////*********************  *******************************
private function clic_boton_entrar():void{
	   
		txt_verifica.text == ''
		if(txt_tema.text == '0') {
		mx.controls.Alert.show(' Debe seleccionar un Tema antes de continuar')
		}else{
			
			ro_asocia.asocia_muestra_preguntas(txt_codigo_modalidad.text,txt_codigo_tip_prod.text,txt_tema.text);
			
		    /*txt_pregunta.text=''
			txt_pregunta_texto.text=''
			txt_asigna_nueva_pregunta.text=''
			txt_pregunta_nueva_texto.text=''
			*/
		
				//mx.controls.Alert.show('pasa',txt_modalidad.text+txt_tipo_pro.text+txt_tema.text)
				}
			}
	
///********************************************************
private function result_asocia_muestra_preguntas(event:ResultEvent):void{
	
	dg_preguntas.dataProvider = event.result;
}
//*********************************************************
private function getCellData_respuestas(model:Boolean):void{
	//lbl_codigo_resp.text = (dg_respuestas.selectedItem.data)
	txt_respuesta.text=""
	txt_respuesta.text = dg_respuestas.selectedItem.label
	//deshabilita_respuesta()
}
//*********************************************************
///********************************************************	

private function cargar():void{
			ro_asocia.asocia_muestra_respuestas(txt_codigo_modalidad.text,txt_codigo_tip_prod.text,txt_tema.text,txt_pregunta.text);
	
    }
//__________________________________________________________________
private function result_asocia_muestra_respuestas (event:ResultEvent):void{
		
dg_respuestas.dataProvider = event.result	
}
//__________________________________________________________________


private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
