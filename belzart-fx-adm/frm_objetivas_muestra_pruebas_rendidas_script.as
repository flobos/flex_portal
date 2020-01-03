// ActionScript file
import libreria.*;

import mx.controls.Alert;
import mx.events.*;
import mx.rpc.events.*;



//******************************************************************************************************
private function inicio():void
{
	
}
//******************************************************************************************************
private function result_muestra_carrera(event:ResultEvent):void
{
	var ob:Object;
	ob = event.result;
	
	
	txt_carrera.text = ob[0].campo_dos;
	txt_rut.text = ob[0].campo_tres;
	txt_alumno.text = ob[0].campo_cuatro;
}
//******************************************************************************************************
private function result_muestra_ramos(event:ResultEvent):void
{

	cmb_ramo.dataProvider = event.result;
	limpiar();
}
//******************************************************************************************************
private function result_muestra_nota(event:ResultEvent):void
{
	var ob:Object;
	ob = event.result;
	
	lbl_nota.text = ob[0].data;
	lbl_porc_aprob.text = ob[0].label;

	
}
//******************************************************************************************************
private function result_muestra_pruebas_ramos(event:ResultEvent):void
{

	cmb_prueba.dataProvider = event.result;
}
//******************************************************************************************************
private function result_muestra_preguntas_prueba(event:ResultEvent):void
{
	var x:int;
	var cod_paso:String;
	var res_correctas:int;
	var res_totales:int;
	cod_paso = "";
	res_correctas = 0;
	res_totales = 0;
	rp_preguntas.dataProvider = event.result;
	
	for(x = 0; x < rp_preguntas.dataProvider.length; x++){
		
		if (lbl_res_idn[x].text == lbl_res_res_idn[x].text){
			if (lbl_res_correcta[x].text == '1'){
				res_correctas++;
			}
			res_totales++;
			rbg_seleccion[x].selected = true;
		}
		
		
		if (cod_paso != lbl_pregunta[x].text){
//			
			lbl_pregunta[x].visible = true;
			cod_paso = lbl_pregunta[x].text;
			if (lbl_res_correcta[x].text == '1'){
				col_respuesta[x].enabled = false;
			}
		
		}
		else{
			if (lbl_res_correcta[x].text == '1'){
				this.col_respuesta[x].enabled = false;
			}
			lbl_pregunta[x].visible = false;
			lbl_pregunta[x].height = 0;
			lbl_pregunta[x].width = 0;
			
		}
		
	}
	lbl_correctas.text = String(res_correctas);
	lbl_totales.text = String(res_totales);

}
//******************************************************************************************************
private function btn_buscar_mat_click():void
{
	limpiar();
	txt_alumno.text = "";
	txt_rut.text = "";
	txt_carrera.text = "";
	cmb_prueba.dataProvider = undefined;
	
	
	ro_muestra_pruebas_rendidas.muestra_carrera(lbl_matricula.text);
	ro_muestra_pruebas_rendidas.muestra_ramos(lbl_matricula.text);	
}
//******************************************************************************************************
private function cmb_prueba_change():void
{
	limpiar();
	if (cmb_prueba.selectedIndex > 0){
	ro_muestra_pruebas_rendidas.muestra_preguntas_prueba(String(cmb_prueba.selectedItem.data));
	ro_muestra_pruebas_rendidas.muestra_nota(String(cmb_prueba.selectedItem.data));
	}
}
//******************************************************************************************************
private function cmb_ramo_change():void
{	
	cmb_prueba.dataProvider = undefined;
	limpiar();
	if (cmb_ramo.selectedIndex > 0){
//		mx.controls.Alert.show(String(cmb_ramo.selectedItem.data),String(cmb_ramo.selectedItem.label));
		ro_muestra_pruebas_rendidas.muestra_pruebas_ramos (String(cmb_ramo.selectedItem.data));
	}
	
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//*******************************************************************************************************
private function limpiar():void
{
	rp_preguntas.dataProvider = undefined;
	lbl_correctas.text = "";
	lbl_totales.text = "";
	lbl_porc_aprob.text = "";
	lbl_nota.text = "";
	
}