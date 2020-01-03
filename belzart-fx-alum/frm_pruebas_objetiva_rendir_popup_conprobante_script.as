import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;


public var trabajo:String
public var nota:String

private function f_carga():void{
	
	trabajo = parentApplication.trabajo;
	nota = parentApplication.nota;
	ro_trabajo.muestra_info_trabajo(librerias.f_trim(trabajo))
	
}


private function result_muestra_info_trabajo(event:ResultEvent):void{
	
	var arreglo_info:Object;
	arreglo_info = event.result; 
	
	if(arreglo_info[0].campo_uno != null ) {
		lbl_alumno.text =  arreglo_info[0].campo_uno
		lbl_ramo.text =  arreglo_info[0].campo_dos
		lbl_prueba.text = arreglo_info[0].campo_cuatro
		lbl_codigo.text = arreglo_info[0].campo_tres
		lbl_nota.text = nota
		
		ro_trabajo.muestra_respuestas_trabajo(librerias.f_trim(trabajo))
	}
    else {
    	mx.controls.Alert.show("Ha ocurrido un error al ingresar la prueba.\nFavor intente nuevamente.\nSi el problema persiste comuníquese con el Departamento de Informática de IPLACEX","Alerta");
    	PopUpManager.removePopUp(this);
    }
	
	
}



private function result_muestra_respuestas_trabajo(event:ResultEvent):void{
	
	dg_respuestas.dataProvider = event.result
}


private function click_btn_imprimir():void {
            var pj : PrintJob = new PrintJob();
            if (pj.start() != true) return;
            pj.addPage(vb_trabajos);
			pj.send();

   }
   
private function click_btn_cerrar():void{
	 
	PopUpManager.removePopUp(this)
	
	}
   
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
