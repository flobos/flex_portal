import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.collections.ArrayCollection;


import mx.rpc.events.*;

private var eje_aca_idn:String;
private var toma_cursos:String;


private function tw_encuesta_creationComplete():void{
	
	
	
    toma_cursos = String(this.parentApplication.tc_idn);
    ro_encuesta_alumno.encuesta_muestra_alumno(toma_cursos);

}

private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}


private function btn_responder_click():void{

	if (dg_encuestas.selectedItem.data == undefined ){
		mx.controls.Alert.show("Debe seleccionar una encuesta ...","ERROR");
	}else{
		var popup2:frm_encuesta_contesta_popup_preguntas = frm_encuesta_contesta_popup_preguntas(PopUpManager.createPopUp( this, frm_encuesta_contesta_popup_preguntas , true));
		popup2.codigo_encuesta = dg_encuestas.selectedItem.data;
		popup2.nombre_encuesta = dg_encuestas.selectedItem.label;
		popup2.tc_idn = toma_cursos;
	}

}
	
	
private function result_encuesta_muestra_alumno(event:ResultEvent):void{

	var arreglo16:Object;
	arreglo16 = event.result; 
	
	
	if (arreglo16.length == 0){
		mx.controls.Alert.show("Usted no tiene encuestas disponibles para este ramo...","MENSAJE");
	}else{
		dg_encuestas.dataProvider = event.result;
	}

}













